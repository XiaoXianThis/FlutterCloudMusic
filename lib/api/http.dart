import 'dart:convert';
import 'package:http/http.dart' as http;

const port = 43439;                       //端口
const host = "http://localhost:$port";    //服务地址

Future<String> http_get(String url, {Map<String, String>? headers}) async {
  var result = await http.get(Uri.parse(url), headers: headers);
  return result.body;
}

Future<String> http_post(String url, {Map<String, String>? headers, Map<String, String>? body}) async {
  var result = await http.post(Uri.parse(url), headers: headers, body: body);
  return result.body;
}


Future<dynamic> http_get_json(String url, {Map<String, String>? headers}) async {
  var result = await http_get(url, headers: headers);
  return json.decode(result);
}

Future<dynamic> http_post_json(String url, {Map<String, String>? headers, Map<String, String>? body}) async {
  var result = await http_post(url, headers: headers, body: body);
  return json.decode(result);
}
