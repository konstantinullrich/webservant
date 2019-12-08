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

  });
}
