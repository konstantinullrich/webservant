import 'dart:io';

import 'package:webservant/webservant.dart';

InternetAddress anyIPv4 = InternetAddress.anyIPv4;

class Webserver {
  final Map<String, UrlCollection> _handlerList = <String, UrlCollection>{};
  final int port;
  InternetAddress hostname = InternetAddress.anyIPv4;
  HttpServer server;
  bool fCORS;

  Webserver({InternetAddress hostname, this.port = 8080, this.fCORS = false}) {
    if (hostname != null) {
      this.hostname = hostname;
    }
  }

  /// Serve the [Webserver] with it's current state using http
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
        urlHandler
            .getUrlFor(uri)
            .function(Response(request, url, fCORS: fCORS));
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

  /// Add a Http Method call
  ///
  /// the default Method is GET
  void addMethodCall(String url, Function(Response) callback,
      {String method = 'GET'}) {
    method = method.toUpperCase();
    if (!_handlerList.containsKey(method)) {
      _handlerList[method] = UrlCollection();
    }
    _handlerList[method].add(Url(url, function: callback));
  }

  /// Add a Http GET Request
  void get(String url, Function(Response) callback) =>
      addMethodCall(url, callback, method: 'GET');

  /// Add a Http HEAD Request
  void head(String url, Function(Response) callback) =>
      addMethodCall(url, callback, method: 'HEAD');

  /// Add a Http POST Request
  void post(String url, Function(Response) callback) =>
      addMethodCall(url, callback, method: 'POST');

  /// Add a Http PUT Request
  void put(String url, Function(Response) callback) =>
      addMethodCall(url, callback, method: 'PUT');

  /// Add a Http DELETE Request
  void delete(String url, Function(Response) callback) =>
      addMethodCall(url, callback, method: 'DELETE');

  /// Add a Http CONNECT Request
  void connect(String url, Function(Response) callback) =>
      addMethodCall(url, callback, method: 'CONNECT');

  /// Add a Http OPTIONS Request
  void options(String url, Function(Response) callback) =>
      addMethodCall(url, callback, method: 'OPTIONS');

  /// Add a Http TRACE Request
  void trace(String url, Function(Response) callback) =>
      addMethodCall(url, callback, method: 'TRACE');

  /// Add a Http PATCH Request
  void patch(String url, Function(Response) callback) =>
      addMethodCall(url, callback, method: 'PATCH');
}
