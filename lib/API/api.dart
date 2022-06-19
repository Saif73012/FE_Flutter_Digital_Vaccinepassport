import 'dart:convert';
import 'package:dio/dio.dart';
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

  Future sendEmail({
    required String email,
    required String username,
    required String adress,
    required String officeName,
  }) async {
    const templateId = 'template_yy1s8pp';

    const serviceId = 'service_dp4nn7j';
    const userId = 'gr-4PyWJWvbMREQ0H';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    try {
      await http.post(url,
          headers: _setHeaders(),
          body: json.encode({
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': userId,
            'template_params': {
              'user_officeName': officeName,
              'user_username': username,
              'user_adress': adress,
              'user_email': email,
            }
          }));
    } catch (e) {
      return e;
    }
  }

  Future sendEmail2({
    required String email,
    required String username,
    required String officeName,
    required String message,
  }) async {
    const templateId = 'template_gab3ybk';

    const serviceId = 'service_dp4nn7j';
    const userId = 'gr-4PyWJWvbMREQ0H';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    await http.post(url,
        headers: _setHeaders(),
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'user_officeName': officeName,
            'user_username': username,
            'user_message': message,
            'user_email': email,
          }
        }));
  }

  Future login2(data, route) async {
    var fullURL = _url + route;
    Response response;
    var dio = Dio();
    try {
      response = await dio.post(
        fullURL,
        options: Options(contentType: Headers.jsonContentType, headers: {
          'Access-Control-Allow-Origin': '*',
        }),
        data: jsonEncode(data),
      );

      return response;
    } catch (e) {
      return e;
    }
  }

  Future createEntry(data, String? route, token) async {
    var fullURL = _url + route!;

    return await http.post(
      Uri.parse(fullURL),
      body: jsonEncode(data),
      headers: _setHeadersWithToken(token),
    );
  }

  Future createBEApiCall(data, route) async {
    var fullURL = _url + route;
    return await http.post(
      Uri.parse(fullURL),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  Future getRouteInfo(route, token) async {
    var fullURL = _url + route;

    var dio = Dio(BaseOptions(headers: {
      "Authorization": "Bearer $token",
      "ContentType": "application/json",
      'Access-Control-Allow-Origin': '*',
    }));
    try {
      final response = await dio.get(fullURL);

      if (response.statusCode == 200) {
        return (response.data);
      } else {
        // ignore: avoid_print
        print('${response.statusCode} : ${response.data.toString()}');
        throw response;
      }
    } catch (error) {
      // ignore: avoid_print
      print(error);
    }
  }

  Future getUserInfoById(id, String? route, token) async {
    var fullURL = _url + route! + '/' + id;

    var dio = Dio(BaseOptions(headers: {
      "Authorization": "Bearer $token",
      "ContentType": "application/json",
      'Access-Control-Allow-Origin': '*',
    }));
    try {
      final response = await dio.get(fullURL);

      if (response.statusCode == 200) {
        return (response.data);
      } else {
        // ignore: avoid_print
        print('${response.statusCode} : ${response.data.toString()}');
        throw response;
      }
    } catch (error) {
      // ignore: avoid_print
      print(error);
    }
  }

  Future getUserSpecial(id, String? route, String? specialroute, token) async {
    var fullURL = _url + route! + '/' + id + '/' + specialroute!;

    var dio = Dio(BaseOptions(headers: {
      "Authorization": "Bearer $token",
      "ContentType": "application/json",
      'Access-Control-Allow-Origin': '*',
    }));
    try {
      final response = await dio.get(fullURL);

      if (response.statusCode == 200) {
        return (response.data);
      } else {
        // ignore: avoid_print
        print('${response.statusCode} : ${response.data.toString()}');
        throw response;
      }
    } catch (error) {
      // ignore: avoid_print
      print(error);
    }
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
