# Example

## Set up a simple Webserver
````dart
var webserver = Webserver();
webserver.get('/search/:query', (Response response) {
 response.write(response.urlParams);
 response.send();
});
webserver.run();
````
