import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class GetCardToken {
  Future getCardToken(
      String cardNumber,
      String month,
      String year,
      String cvcNumber,
      String cardHolderName,
      BuildContext context) async {
    var responseJson;
    try {
      final response =
          await http.Client().post("https://api.stripe.com/v1/tokens", body: {
        "card[number]": cardNumber,
        "card[exp_month]": month,
        "card[exp_year]": year,
        "card[cvc]": cvcNumber,
        "card[name]": cardHolderName
      }, headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
        'Authorization': 'Bearer sk_test_Vcv04sLCi00ljN3C8GqrpDmw00SJk0bP62'
      });
      return responseJson = _returnResponse(response);
      // print(responseJson["id"]);
    } on Exception {
      throw Exception('No Internet connection');
    }
  }
	// sk_test_Vcv04sLCi00ljN3C8GqrpDmw00SJk0bP62
  // sk_test_Vcv04sLCi00ljN3C8GqrpDmw00SJk0bP62
// sk_live_lCtPjoinQO39U0PntCc9jqFB00OwzbUi5C
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

final getCardToken = GetCardToken();
