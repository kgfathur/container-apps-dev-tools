// Importing 'http' module 
const http = require('http');
  
// Setting Port Number as 8080
const port = 8080;
  
// Setting hostname as the localhost
// NOTE: You can set hostname to something 
// else as well, for example, say 127.0.0.1
const hostname = '0.0.0.0';
  
// Creating Server 
const server = http.createServer((req,res)=>{
  
    // Handling Request and Response 
    res.statusCode=200;
    res.setHeader('Content-Type', 'text/plain');
    var req_url = "Address: " + req.headers.host;
    res.write('Containerized NodeJS!\n' + req_url + '\n');
    res.end();
});
  
// Making the server to listen to required
// hostname and port number
server.listen(port,hostname,()=>{
  
    // Callback 
    console.log(`Server running at http://${hostname}:${port}/`);
});