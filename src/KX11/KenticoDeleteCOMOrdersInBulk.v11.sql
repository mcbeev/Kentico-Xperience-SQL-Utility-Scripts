/* KenticoDeleteCOMOrdersinBulk.v11.sql       */
/* Goal: Clear out COM_Order tables in bulk   */
/* Description: Bulk delete E-commerce orders */
/*	and all of the related FK data, EXCEPT	  */
/*	for an internal domain where we want to	  */
/*	keep our test orders from				  */
/* Intended Kentico Verison: 11.x             */
/* Author: Brian McKeiver (mcbeev@gmail.com)  */
/* Revision: 1.0                              */
/* Comment: Removing 10k orders took ~ 25s    */
/* Take a backup first! Don't be THAT guy!	  */

DECLARE @EmailDomainToKeep NVARCHAR(512)
DECLARE @OrderBillingAddressID INT
DECLARE @OrderShippingAddressID INT
DECLARE @OrderAddressUsedCount INT
DECLARE @OrderID INT
DECLARE @CustomerID INT
DECLARE @TotalOrders INT
DECLARE @BatchSize INT
DECLARE @KeepCustomersAlive INT -- yeah it's that serious ;)
DECLARE @CustomersRemoved INT
DECLARE @DEBUG INT

--Email domain of customer email addresses where we want to keep emails from (our testing orders)
-- Always leave our customers and orders from this domain no matter what
SET @EmailDomainToKeep = '@domain.com'

--How many to delete at a time, be careful!
SET @BatchSize = 1000

--For printing of messages
SET @DEBUG = 1

--Default is to remove all Orphan'd Customers(Customers with no orders left)
--Change to a 1 to keep them around and ONLY remove Orders and OrderItems
SET @KeepCustomersAlive = 0

--Just a counter for debug reasons
SET @CustomersRemoved = 0

SET NOCOUNT ON

--Figure out how many Orders we can find to remove that don't match our email domain to keep
SELECT @TotalOrders=COUNT(OrderID) 
FROM COM_Order O
INNER JOIN COM_Customer C ON
	O.OrderCustomerID = C.CustomerID
WHERE C.CustomerEmail NOT LIKE '%'+ @EmailDomainToKeep +'%'

PRINT 'Total Orders found: ' + CONVERT(nvarchar(50), @TotalOrders) + ' that do not match domain to keep: ' + @EmailDomainToKeep

IF @DEBUG = 1 PRINT 'Attempting to Remove up to '  + CONVERT(nvarchar(50), @BatchSize) + ' orders.'

SELECT TOP (@BatchSize) OrderID INTO #tmpOrderIDs 
FROM COM_Order O
INNER JOIN COM_Customer C ON
	O.OrderCustomerID = C.CustomerID
WHERE C.CustomerEmail NOT LIKE '%'+ @EmailDomainToKeep +'%'
ORDER BY OrderCustomerID

WHILE EXISTS(SELECT * FROM #tmpOrderIds)
BEGIN

	SELECT TOP 1 @OrderID = OrderID FROM #tmpOrderIDs
	IF @DEBUG = 1 PRINT @OrderID

    --Remove OrderItemSKUFile from this Order's Order Items
	--SELECT * FROM COM_OrderItemSKUFile WHERE [OrderItemID] IN (
	DELETE FROM COM_OrderItemSKUFile WHERE [OrderItemID] IN (
		SELECT [OrderItemID]
		FROM COM_OrderItem
		WHERE [OrderItemOrderID] = @OrderID
	)

	--Remove Order Items from this Order's Order Items
	DELETE FROM COM_OrderItem WHERE [OrderItemOrderID] = @OrderID
	--SELECT * FROM COM_OrderItem WHERE [OrderItemOrderID] = @OrderID

	--Remove from the Order from the User's Order Status
	DELETE FROM COM_OrderStatusUser WHERE [OrderID] = @OrderID
	--SELECT * FROM COM_OrderStatusUser WHERE [OrderID] = @OrderID

	--Figure out the two Addresses and CustomerID
	SELECT @OrderBillingAddressID = COALESCE(OrderBillingAddressID, -1)
			,@OrderShippingAddressID = COALESCE(OrderShippingAddressID, -1)
			,@CustomerID = OrderCustomerID 
	FROM COM_Order 
	WHERE [OrderID] = @OrderID

	--Remove the Order
	DELETE FROM COM_Order WHERE [OrderID] = @OrderID
	--SELECT * FROM COM_Order WHERE [OrderID] = @OrderID

	--See if Billing Address is used on any orders still
	SELECT @OrderAddressUsedCount = Count(OrderCompanyAddressID) FROM COM_Order WHERE [OrderCompanyAddressID] = @OrderBillingAddressID
	IF @OrderAddressUsedCount = 0 AND @OrderBillingAddressID > 0
	BEGIN
		--Remove the Billing Addresses as they are no longer tied to any orders
		DELETE FROM COM_OrderAddress WHERE [AddressID] = @OrderBillingAddressID
		IF @DEBUG = 1 PRINT 'Deleted Billing Address ' + CONVERT(nvarchar(50), @OrderBillingAddressID)
	END

	SET @OrderAddressUsedCount = -1
	
	--See if Shipping Address is used on any orders still
	SELECT @OrderAddressUsedCount = Count(OrderCompanyAddressID) FROM COM_Order WHERE [OrderCompanyAddressID] = @OrderShippingAddressID
	IF @OrderAddressUsedCount = 0  AND @OrderShippingAddressID > 0
	BEGIN
		--Remove the Shipping Addresses as they are no longer tied to any orders
		DELETE FROM COM_OrderAddress WHERE [AddressID] = @OrderShippingAddressID
		IF @DEBUG = 1 PRINT 'Deleted Shipping Address ' + CONVERT(nvarchar(50), @OrderShippingAddressID)
	END

	IF @KeepCustomersAlive = 0
	BEGIN
		IF @DEBUG = 1 PRINT 'Attempting to Remove CustomerID '+ CONVERT(nvarchar(50), @CustomerID)

		--We just removed the last order for this customer, now we can remove the customer
		SELECT @TotalOrders = Count(OrderID) FROM COM_Order WHERE [OrderCustomerID] = @CustomerID
		IF @TotalOrders = 0
		BEGIN
			--Have to clear out the Shopping Cart references first
			DELETE COM_ShoppingCartSKU
			FROM COM_ShoppingCartSKU S
			INNER JOIN COM_ShoppingCart C ON 
				S.ShoppingCartID = C.ShoppingCartID
			INNER JOIN COM_Customer CO ON
				C.ShoppingCartCustomerID = CO.CustomerID
			WHERE CO.CustomerID = @CustomerID

			DELETE COM_ShoppingCartCouponCode
			FROM COM_ShoppingCartCouponCode S
			INNER JOIN COM_ShoppingCart C ON 
				S.ShoppingCartID = C.ShoppingCartID
			INNER JOIN COM_Customer CO ON
				C.ShoppingCartCustomerID = CO.CustomerID
			WHERE CO.CustomerID = @CustomerID

			DELETE COM_ShoppingCart WHERE ShoppingCartCustomerID = @CustomerID

			--Then clear out the addresses for this Customer
			DELETE COM_Address WHERE AddressCustomerID = @CustomerID

			--Finally! can remove the Customer
			DELETE COM_Customer	WHERE CustomerID = @CustomerID

			SET @CustomersRemoved = @CustomersRemoved + 1
			IF @DEBUG = 1 PRINT 'Customer removed'
		END
		ELSE
		BEGIN
			PRINT 'Skipping as Customer still has orders'
		END
		
	END

	IF @DEBUG = 1 PRINT 'Deleted order ' + CONVERT(nvarchar(100), @OrderID)

	--Remove item from temp table to process
	DELETE FROM #tmpOrderIDs WHERE OrderID = @OrderID
END

SET NOCOUNT OFF

DROP TABLE #tmpOrderIDs

SELECT @TotalOrders = COUNT(OrderID) FROM COM_Order

PRINT 'Removed ' + CONVERT(nvarchar(50), @BatchSize) + ' orders'
Print 'Removed ' + CONVERT(nvarchar(50), @CustomersRemoved) + ' customers'
PRINT 'Succcess. Total Orders Remain: ' + CONVERT(nvarchar(50), @TotalOrders)
