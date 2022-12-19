import 'package:new_flutter_demo/database_helper.dart';

class DataModel {
    OrderInfo? orderInfo;

    DataModel({this.orderInfo});

    factory DataModel.fromJson(Map<String, dynamic> json) {
        return DataModel(
            orderInfo: json['orderInfo'] != null ? OrderInfo.fromJson(json['orderInfo']) : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        if (orderInfo != null) {
            data['orderInfo'] = orderInfo?.toJson();
        }
        return data;
    }
}

class OrderInfo {
    List<Order>? orders;

    OrderInfo({this.orders});

    factory OrderInfo.fromJson(Map<String, dynamic> json) {
        return OrderInfo(
            orders: json['orders'] != null ? (json['orders'] as List).map((i) => Order.fromJson(i)).toList() : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data =  <String, dynamic>{};
        if (orders != null) {
            data['orders'] = orders?.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Order {
    int? order_id;
    String? order_type;
    String? expected_date;
    int? sequence_no;

    Order({this.order_id, this.order_type, this.sequence_no, this.expected_date});

    factory Order.fromJson(Map<String, dynamic> json) {
        return Order(
            order_id: json['order_id'],
            order_type: json['order_type'],
            sequence_no: json['sequence_no'],
            expected_date: json['expected_date'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data[DatabaseHelper.columnOrderId] = order_id.toString();
        data[DatabaseHelper.columnOrderType] = order_type.toString();
        data[DatabaseHelper.columnSequenceNo] = sequence_no.toString();
        data[DatabaseHelper.columnExpectedDate] = expected_date.toString();
        return data;
    }



}