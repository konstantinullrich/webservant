import 'package:webservant/webservant.dart';
import 'package:test/test.dart';

void main() {
  group('A group of Url tests', () {
    Url url;

    setUp(() {
      url = Url('/search/:query');
    });

    test('Url is matching', () {
      expect(url.isMatching('/search/test'), isTrue);
    });

    test('Url is not matching', () {
      expect(url.isMatching('/notsearch/test'), isFalse);
    });

    test('get parameter from url', () {
      expect(url.getParameters('/search/test'), {'query': 'test'});
    });

    test('get parameter from url', () {
      var blogUrl = Url('/blog/:author/:post');
      expect(blogUrl.getParameters('/blog/kullrich/30042001'),
          {'author': 'kullrich', 'post': '30042001'});
    });
  });

  group('A group of UrlCollection tests', () {
    UrlCollection urlCollection;

    setUp(() {
      urlCollection = UrlCollection();

      urlCollection.add(Url('/test'));
      urlCollection.add(Url('/test/2'));
    });

    test('Check if Url is in Collection', () {
      expect(urlCollection.includes('/test'), isTrue);
    });

    test('Check if Url is not in Collection', () {
      expect(urlCollection.includes('/test/3'), isFalse);
    });

    test('Get Url from Collection', () {
      expect(
          urlCollection.getUrlFor('/test').toString(), Url('/test').toString());
    });
  });
}
