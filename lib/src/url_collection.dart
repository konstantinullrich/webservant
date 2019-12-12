import 'package:webservant/webservant.dart';

class UrlCollection {
  final Map<String, Url> _collection = <String, Url>{};

  /// The number of urls in the collection
  int get length => _collection.length;

  /// Add a [Url] to the collection
  void add(Url addUrl) => _collection[addUrl.url] = addUrl;

  /// Remove a specific Url from the collection
  void remove(String removeUrl) {
    if (removeUrl[0] == '/') {
      removeUrl = removeUrl.substring(1);
    }
    _collection.remove(removeUrl);
  }

  /// Get the [Url] to the given [String] from the collection
  ///
  /// Returns a [Url]
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

  /// Check if a [Url] exists in the collection matching the given [String]
  ///
  /// Returns a [bool]
  bool includes(String url) => getUrlFor(url) != null;

  @override
  String toString() => _collection.keys.toString();
}
