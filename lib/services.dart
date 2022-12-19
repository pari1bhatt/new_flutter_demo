import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:new_flutter_demo/data_model.dart';

class Services {
  static const basURL = 'https://qaadmin.onzway.com/apis/get-orders-v3.json';

  static Future<DataModel> callAPI() async {
    Map<String, String> jsonHeader = {
      'content-type': 'application/json',
    };

    var responce = await http.post(
      Uri.parse(basURL),
      body: {"restaurant_id": "1", "status": '4', "page": "1"},
    );
    print("responce: ${responce.statusCode}");

    var data = json.decode(responce.body);
    DataModel dataModel = DataModel.fromJson(data['data']);
    debugPrint(dataModel.orderInfo?.orders?[0].order_id.toString() );

    return dataModel;
  }
}
