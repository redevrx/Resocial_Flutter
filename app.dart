import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  await http
      .get(
          "http://172.19.128.1:8080/resocial/api/v1/generate/token?channelName=redev&uid=0&role=publisher&expireTime=3600")
      .then((token) {
    Map t = jsonDecode(token.body);
    print('${t['token']}');
  }).catchError((e) => print(e));
}
