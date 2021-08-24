import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CreateCutomer {
  Future createCutomer(String token, String email, BuildContext context) async {
    var responseJson;
    try {
      final response = await http.Client()
          .post("https://api.stripe.com/v1/customers", body: {
        "description": email,
        "source": token,
        
      }, headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
        'Authorization': 'Bearer sk_test_Vcv04sLCi00ljN3C8GqrpDmw00SJk0bP62'
      });
      print(response.body);
      return responseJson = _returnResponse(response);
     
    } on Exception {
      throw Exception('No Internet connection');
    }
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw Exception(response.body.toString());
      case 401:
      case 403:
        throw Exception(response.body.toString());
      case 500:
      default:
        throw Exception(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

final createCutomer = CreateCutomer();
