class Url {
  String _url;
  Function function;
  List<String> _parts = <String>[];

  String get url => _url;

  Url(String url, {this.function}) {
    if (url[0] == '/') {
      url = url.substring(1);
    }
    _url = url;
    _parts = url.split('/');
  }

  Map<String, String> getParameters(String url) {
    var params = <String, String>{};
    if (url[0] == '/') {
      url = url.substring(1);
    }
    var partsOfRequestedUrl = url.split('/');
    if (_parts.length == partsOfRequestedUrl.length) {
      var cursor = 0;
      _parts.forEach((part) {
        if(part.startsWith(':')) {
          params[part.substring(1)] = partsOfRequestedUrl[cursor];
        }
        cursor++;
      });
    }
    return params;
  }

  bool isMatching(String url) {
    if (url[0] == '/') {
      url = url.substring(1);
    }
    var partsOfRequestedUrl = url.split('/');

    if (partsOfRequestedUrl.length != _parts.length) {
      return false;
    }
    var cursor = 0;
    for (var part in _parts) {
      if(!part.startsWith(':') && part != partsOfRequestedUrl[cursor]) {
        return false;
      }
      cursor++;
    };

    return true;
  }

  @override
  String toString() => url;
}