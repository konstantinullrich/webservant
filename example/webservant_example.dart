import 'dart:io';

import 'package:webservant/webservant.dart';

void main() {
  var webserver = Webserver(hostname: InternetAddress.loopbackIPv4);
  webserver.get('/search/:query', (Response response) {
    response.write(response.urlParams);
    response.send();
  });
  webserver.run();
}
