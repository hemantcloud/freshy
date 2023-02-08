class PlaceOrderModel {
  bool? status;
  Data? data;
  String? message;

  PlaceOrderModel({this.status, this.data, this.message});

  PlaceOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? orderId;
  int? tid;
  String? paymentMethod;

  Data({this.orderId, this.tid, this.paymentMethod});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    tid = json['tid'];
    paymentMethod = json['payment_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['tid'] = this.tid;
    data['payment_method'] = this.paymentMethod;
    return data;
  }
}
