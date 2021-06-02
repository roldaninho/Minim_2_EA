import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:unihub_app/networking/api_exceptions.dart';
import 'dart:async';
import 'api_exceptions.dart';

class ApiBaseHelper {
  String _baseUrl;

  void setUrl() {
    //Produccion
    //_baseUrl = "http://147.83.7.164:4000";
    //Desarrollo

    try {
      if (Platform.isAndroid) {
        _baseUrl = "http://10.0.2.2:4000";
      } else {
        _baseUrl = "http://127.0.0.1:4000";
      }
    } catch (e) {
      _baseUrl = "http://127.0.0.1:4000";
    }
  }

  Future<dynamic> post(String url, dynamic content) async {
    setUrl();
    print('Api Post, url $url');
    Map<String, String> customHeaders = {
      'content-type': 'application/json',
      'authorization': await getToken(),
    };
    var bodyF = jsonEncode(content);
    var finalResponse;
    try {
      print('Content: ' + content.toString());
      final response = await http.post(Uri.parse(_baseUrl + url),
          headers: customHeaders, body: bodyF);
      finalResponse = response;
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api post recieved!');
    return finalResponse;
  }

  Future<dynamic> get(String url) async {
    setUrl();
    print('Api get, url $url');
    Map<String, String> customHeaders = {
      'content-type': 'application/json',
      'authorization': await getToken(),
    };
    var finalResponse;
    try {
      final response =
          await http.get(Uri.parse(_baseUrl + url), headers: customHeaders);
      finalResponse = response;
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api get received!');
    return finalResponse;
  }

  Future<dynamic> delete(String url) async {
    setUrl();
    print('Api delete, url $url');
    var finalResponse;
    try {
      Map<String, String> customHeaders = {
        'authorization': await getToken(),
      };
      final response =
          await http.delete(Uri.parse(_baseUrl + url), headers: customHeaders);
      finalResponse = response;
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api delete received!');
    return finalResponse;
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      return prefs.getString('jwt');
    } catch (exception) {
      return null;
    }
  }

  dynamic _returnResponse(http.Response response) {
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print('200 Received');
        return response.statusCode;
      case 201:
        print('201 Received');
        return response.statusCode;
      //throw BadRequestException(json.decode(response.body.toString()));
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
