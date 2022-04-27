import 'dart:convert';

import 'package:http/http.dart' as http;

class BECall {
  final String _url = "https://das-digitale-impfbuch.herokuapp.com/";

  Future login(data, route) async {
    var fullURL = _url + route;
    return await http.post(
      Uri.parse(fullURL),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  Future createPatient(data, route) async {
    var fullURL = _url + route;
    return await http.post(
      Uri.parse(fullURL),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  Future getUserInfoById(id, String? route, token) async {
    var fullURL = _url + route! + '/' + id;
    print(fullURL);
    return await http.get(
      Uri.parse(fullURL),
      headers: _setHeadersWithToken(token),
    );
  }

  _setHeaders() => {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      };
  _setHeadersWithToken(token) => {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Authorization': 'Bearer $token',
      };
}
