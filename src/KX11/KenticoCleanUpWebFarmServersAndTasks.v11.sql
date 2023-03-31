
declare @server nvarchar(200), @serverid int
set @server = '<your server name>'

select @serverid = serverid
from cms_webfarmserver
where servername = @server

delete cms_webfarmserverlog
where serverid = @serverid

delete cms_webfarmservermonitoring
where serverid = @serverid

delete cms_webfarmservertask
where serverid = @serverid

delete cms_webfarmtask
where TaskMachineName = @server

delete cms_webfarmserver
where serverid = @serverid
