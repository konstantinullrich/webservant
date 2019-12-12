import 'package:webservant/webservant.dart';

class UrlCollection {
  final Map<String, Url> _collection = <String, Url>{};
  int get length => _collection.length;

  void add(Url addUrl) => _collection[addUrl.url] = addUrl;

  void remove(String removeUrl) {
    if (removeUrl[0] == '/') {
      removeUrl = removeUrl.substring(1);
    }
    _collection.remove(removeUrl);
  }

  Url getUrlFor(String url) {
    Url matchingUrl;
    _collection.forEach((String compareUrl, Url currentUrl) {
      if (currentUrl.isMatching(url)) {
        matchingUrl = currentUrl;
        return;
      }
    });
    return matchingUrl;
  }

  bool includes(String url) => getUrlFor(url) != null;

  @override
  String toString() => _collection.keys.toString();
}
