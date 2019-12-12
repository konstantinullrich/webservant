import 'package:webservant/webservant.dart';

void main() {
  var webserver = Webserver();
  webserver.get('/echo/:query', (Response response) {
    response.write(response.urlParams);
    response.send();
  });
  webserver.run();
}
