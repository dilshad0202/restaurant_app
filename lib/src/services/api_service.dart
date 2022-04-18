import 'package:dio/dio.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';

class ApiService {
  static Dio createDio() {
    return Dio();
  }

  static final dio = createDio();
  static final baseAPI = dio;

  static Future<Response> getApiData({String? url}) async {
    var  response;
    try {
      response = await baseAPI.get(url??"");
    } 
    on DioError catch (e) {
      if (DioErrorType.other == e.type) {
        if (e.message.contains('SocketException')) {
          debugPrint(e.toString());
        }
      } else if (DioErrorType.response == e.type) {
          debugPrint(response.e.toString());
      } 
       
    }
     return response;
  
  }
}
