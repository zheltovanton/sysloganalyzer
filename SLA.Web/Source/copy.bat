net stop w3svc
copy slacweb.dll C:\Inetpub\wwwroot\slacweb.dll 
net start w3svc
start http://localhost/