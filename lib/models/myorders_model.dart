class MyOrdersModel {
  bool? status;
  Data? data;
  String? message;

  MyOrdersModel({this.status, this.data, this.message});

  MyOrdersModel.fromJson(Map<String, dynamic> json) {
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
  List<Orders>? orders;
  int? total;

  Data({this.orders, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Orders {
  String? orderId;
  String? vendorId;
  String? vendorImage;
  String? vendorName;
  int? userId;
  String? userImage;
  String? userName;
  String? subtotal;
  String? shippingCharges;
  int? percentageVat;
  String? vat;
  String? total;
  String? orderPlaced;
  String? oneTheWay;
  String? orderDelivered;
  String? status;
  String? isRated;
  List<Items>? items;
  Address? address;

  Orders(
      {this.orderId,
        this.vendorId,
        this.vendorImage,
        this.vendorName,
        this.userId,
        this.userImage,
        this.userName,
        this.subtotal,
        this.shippingCharges,
        this.percentageVat,
        this.vat,
        this.total,
        this.orderPlaced,
        this.oneTheWay,
        this.orderDelivered,
        this.status,
        this.isRated,
        this.items,
        this.address});

  Orders.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    vendorId = json['vendor_id'];
    vendorImage = json['vendor_image'];
    vendorName = json['vendor_name'];
    userId = json['user_id'];
    userImage = json['user_image'];
    userName = json['user_name'];
    subtotal = json['subtotal'];
    shippingCharges = json['shipping_charges'];
    percentageVat = json['percentage_vat'];
    vat = json['vat'];
    total = json['total'];
    orderPlaced = json['order_placed'];
    oneTheWay = json['one_the_way'];
    orderDelivered = json['order_delivered'];
    status = json['status'];
    isRated = json['is_rated'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['vendor_id'] = this.vendorId;
    data['vendor_image'] = this.vendorImage;
    data['vendor_name'] = this.vendorName;
    data['user_id'] = this.userId;
    data['user_image'] = this.userImage;
    data['user_name'] = this.userName;
    data['subtotal'] = this.subtotal;
    data['shipping_charges'] = this.shippingCharges;
    data['percentage_vat'] = this.percentageVat;
    data['vat'] = this.vat;
    data['total'] = this.total;
    data['order_placed'] = this.orderPlaced;
    data['one_the_way'] = this.oneTheWay;
    data['order_delivered'] = this.orderDelivered;
    data['status'] = this.status;
    data['is_rated'] = this.isRated;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    return data;
  }
}

class Items {
  int? id;
  String? orderId;
  String? userId;
  String? vendorId;
  String? productId;
  String? productImage;
  String? productName;
  String? qty;
  String? perWeight;
  String? price;
  String? subtotal;
  String? total;

  Items(
      {this.id,
        this.orderId,
        this.userId,
        this.vendorId,
        this.productId,
        this.productImage,
        this.productName,
        this.qty,
        this.perWeight,
        this.price,
        this.subtotal,
        this.total});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    productId = json['product_id'];
    productImage = json['product_image'];
    productName = json['product_name'];
    qty = json['qty'];
    perWeight = json['per_weight'];
    price = json['price'];
    subtotal = json['subtotal'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['vendor_id'] = this.vendorId;
    data['product_id'] = this.productId;
    data['product_image'] = this.productImage;
    data['product_name'] = this.productName;
    data['qty'] = this.qty;
    data['per_weight'] = this.perWeight;
    data['price'] = this.price;
    data['subtotal'] = this.subtotal;
    data['total'] = this.total;
    return data;
  }
}

class Address {
  From? from;
  From? to;

  Address({this.from, this.to});

  Address.fromJson(Map<String, dynamic> json) {
    from = json['from'] != null ? new From.fromJson(json['from']) : null;
    to = json['to'] != null ? new From.fromJson(json['to']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.from != null) {
      data['from'] = this.from!.toJson();
    }
    if (this.to != null) {
      data['to'] = this.to!.toJson();
    }
    return data;
  }
}

class From {
  String? location;
  String? lat;
  String? lng;
  String? type;

  From({this.location, this.lat, this.lng, this.type});

  From.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    lat = json['lat'];
    lng = json['lng'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this.location;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['type'] = this.type;
    return data;
  }
}
