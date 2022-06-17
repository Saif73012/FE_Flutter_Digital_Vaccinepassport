// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
    final templateId = 'template_yy1s8pp';

    final serviceId = 'service_dp4nn7j';
    final userId = 'gr-4PyWJWvbMREQ0H';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(url,
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
  }

  Future sendEmail2({
    required String email,
    required String username,
    required String officeName,
    required String message,
  }) async {
    final templateId = 'template_gab3ybk';

    final serviceId = 'service_dp4nn7j';
    final userId = 'gr-4PyWJWvbMREQ0H';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(url,
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
      print('in if login2');
      response = await dio.post(
        fullURL,
        options: Options(contentType: Headers.jsonContentType, headers: {
          'Access-Control-Allow-Origin': '*',
        }),
        data: jsonEncode(data),
      );
      print(response);
      print('after print res');
      return response;
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future createEntry(data, String? route, token) async {
    var fullURL = _url + route!;
    print(fullURL);
    return await http.post(
      Uri.parse(fullURL),
      body: jsonEncode(data),
      headers: _setHeadersWithToken(token),
    );
  }

/*   Future createEntry2(id, data, String? route, token) async {
    var fullURL = _url + route! + '/' + id;

    var dio = Dio();
    try {
      print('in if createENtry2');
      print('in BE CALL for create ENtry');
      var response = await dio.post(
        fullURL,
        options: Options(contentType: Headers.jsonContentType, headers: {
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $token",
        }),
        data: jsonEncode(data),
      );
      print(response);
      print('after print res');
      return response;
    } catch (e) {
      print(e);
      return e;
    }
  }
 */
/*   Future createEntry(id, data, String? route, token) async {
    var fullURL = _url + route! + '/' + id;
    print(fullURL);

    var dio = Dio(BaseOptions(headers: {
      "Authorization": "Bearer $token",
      "ContentType": "application/json",
      'Access-Control-Allow-Origin': '*',
    }));

    try {
      print(dio.options.headers['Authorization']);
      print(dio.options.headers['ContentType']);

      print('before be call');
      final response = await dio.post(
        fullURL,
        data: jsonEncode(data),
      );
      print(response);
      print('after be call');

      if (response.statusCode == 200) {
        return (response.data);
      } else {
        print('${response.statusCode} : ${response.data.toString()}');
        throw response;
      }
    } catch (error) {
      print(error);
    }
  }
 */
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
    //print(fullURL);
    var dio = Dio(BaseOptions(headers: {
      "Authorization": "Bearer $token",
      "ContentType": "application/json",
      'Access-Control-Allow-Origin': '*',
    }));
    try {
      print(dio.options.headers['Authorization']);
      print(dio.options.headers['ContentType']);

      print('before be call');
      final response = await dio.get(fullURL);
      print(response);
      print('after be call');

      if (response.statusCode == 200) {
        return (response.data);
      } else {
        print('${response.statusCode} : ${response.data.toString()}');
        throw response;
      }
    } catch (error) {
      print(error);
    }
  }

  Future getUserInfoById(id, String? route, token) async {
    var fullURL = _url + route! + '/' + id;
    print(fullURL);
    var dio = Dio(BaseOptions(headers: {
      "Authorization": "Bearer $token",
      "ContentType": "application/json",
      'Access-Control-Allow-Origin': '*',
    }));
    try {
      print(dio.options.headers['Authorization']);
      print(dio.options.headers['ContentType']);

      print('before be call');
      final response = await dio.get(fullURL);
      print(response);
      print('after be call');

      if (response.statusCode == 200) {
        return (response.data);
      } else {
        print('${response.statusCode} : ${response.data.toString()}');
        throw response;
      }
    } catch (error) {
      print(error);
    }
  }

  Future getUserSpecial(id, String? route, String? specialroute, token) async {
    var fullURL = _url + route! + '/' + id + '/' + specialroute!;
    print(fullURL);
    var dio = Dio(BaseOptions(headers: {
      "Authorization": "Bearer $token",
      "ContentType": "application/json",
      'Access-Control-Allow-Origin': '*',
    }));
    try {
      print(dio.options.headers['Authorization']);
      print(dio.options.headers['ContentType']);

      print('before be call');
      final response = await dio.get(fullURL);
      print(response);
      print('after be call');

      if (response.statusCode == 200) {
        return (response.data);
      } else {
        print('${response.statusCode} : ${response.data.toString()}');
        throw response;
      }
    } catch (error) {
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
