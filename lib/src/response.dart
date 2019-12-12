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

  HttpRequest get originalRequest => _httpRequest;

  Future<String> get requestData => utf8.decoder.bind(_httpRequest).join();

  Map<String, String> get urlParams =>
      originUrl.getParameters(_httpRequest.uri.path);

  void addHeader(String name, Object value) =>
      _response.headers.add(name, value);

  void removeHeader(String name, Object value) =>
      _response.headers.remove(name, value);

  void write(Object data) => _response.write(data);

  void send() => _response.close();
}
