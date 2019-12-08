import 'dart:io';

import 'package:webservant/webservant.dart';

class Webserver {
  int port;
  InternetAddress hostname = InternetAddress.anyIPv4;
  HttpServer server;
  final Map<String, UrlCollection> _handlerList = <String, UrlCollection>{};

  Webserver({this.hostname, this.port = 8080});

  void run() async {
    server = await HttpServer.bind(hostname, port);
    print('Listening on http://${server.address.host}:${server.port}/');
    await for (HttpRequest request in server) {
      _handleRequest(request);
    }
  }

  void _handleRequest(HttpRequest request) {
    var uri = request.uri.path;
    if (_handlerList.containsKey(request.method)) {
      var urlHandler = _handlerList[request.method];
      if (urlHandler.includes(uri)) {
        var url = urlHandler.getUrlFor(uri);
        urlHandler.getUrlFor(uri).function(Response(request, url));
      } else {
        _send404(request);
      }
    } else {
      request.response
        ..statusCode = HttpStatus.methodNotAllowed
        ..write('Unsupported request: ${request.method}.')
        ..close();
    }
  }
  void _send404(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.notFound
      ..write('Error 404: Not found: ${request.uri.path}.')
      ..close();
  }
  void addMethodCall(String url, Function(Response) callback, {String method = 'GET'}) {
    method = method.toUpperCase();
    if (!_handlerList.containsKey(method)) {
      _handlerList[method] = UrlCollection();
    }
    _handlerList[method].add(Url(url, function: callback));
  }

  void get(String url, Function(Response) callback) => addMethodCall(url, callback, method: 'GET');
  void head(String url, Function(Response) callback) => addMethodCall(url, callback, method: 'HEAD');
  void post(String url, Function(Response) callback) => addMethodCall(url, callback, method: 'POST');
  void put(String url, Function(Response) callback) => addMethodCall(url, callback, method: 'PUT');
  void delete(String url, Function(Response) callback) => addMethodCall(url, callback, method: 'DELETE');
  void connect(String url, Function(Response) callback) => addMethodCall(url, callback, method: 'CONNECT');
  void options(String url, Function(Response) callback) => addMethodCall(url, callback, method: 'OPTIONS');
  void trace(String url, Function(Response) callback) => addMethodCall(url, callback, method: 'TRACE');
  void patch(String url, Function(Response) callback) => addMethodCall(url, callback, method: 'PATCH');
}