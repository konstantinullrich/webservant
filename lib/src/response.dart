import 'dart:convert';
import 'dart:io';

import 'package:webservant/webservant.dart';

class Response {
  final HttpRequest _httpRequest;
  final HttpResponse _response;
  final Map<String, String> queryParameters;
  final Url originUrl;
  final bool fCORS;

  Response(this._httpRequest, this.originUrl, {this.fCORS = false})
      : _response = _httpRequest.response,
        queryParameters = _httpRequest.uri.queryParameters {
    if (fCORS) {
      addHeader('Access-Control-Allow-Origin', '*');
      addHeader('Access-Control-Allow-Methods', '*');
      addHeader('Access-Control-Allow-Headers', '*');
    }
  }

  /// Get the original [HttpRequest] from the 'dart:io'-lib
  HttpRequest get originalRequest => _httpRequest;

  /// Await the Data payload of PUT or POST Requests
  Future<String> get requestData => utf8.decoder.bind(_httpRequest).join();

  /// Get the Url Parameter from the request
  /// 
  /// Returns a [Map]
  Map<String, String> get urlParams =>
      originUrl.getParameters(_httpRequest.uri.path);

  /// Set the Http Status Code of the [HttpResponse]
  set statusCode(int value) => _response.statusCode = value;

  /// Add a Header to the [HttpResponse]
  void addHeader(String name, Object value) =>
      _response.headers.add(name, value);

  /// Set a Header of the [HttpResponse]
  void setHeader(String name, Object value) =>
      _response.headers.set(name, value);

  /// Remove a Header of the [HttpResponse]
  void removeHeader(String name, Object value) =>
      _response.headers.remove(name, value);
  
  /// Write a response
  void write(Object data) => _response.write(data);

  /// Send the [HttpResponse] and close the Request
  void send() => _response.close();
}
