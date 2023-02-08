class GetCartModel {
  bool? status;
  Data? data;
  String? message;

  GetCartModel({this.status, this.data, this.message});

  GetCartModel.fromJson(Map<String, dynamic> json) {
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
  AddressCart? address;
  Cart? cart;
  CartTotal? cartTotal;

  Data({this.address, this.cart, this.cartTotal});

  Data.fromJson(Map<String, dynamic> json) {
    address =
    json['address'] != null ? new AddressCart.fromJson(json['address']) : null;
    cart = json['cart'] != null ? new Cart.fromJson(json['cart']) : null;
    cartTotal = json['cart_total'] != null
        ? new CartTotal.fromJson(json['cart_total'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.cart != null) {
      data['cart'] = this.cart!.toJson();
    }
    if (this.cartTotal != null) {
      data['cart_total'] = this.cartTotal!.toJson();
    }
    return data;
  }
}

class AddressCart {
  int? id;
  String? userId;
  String? house;
  String? apartment;
  String? lat;
  String? lng;
  String? type;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  AddressCart(
      {this.id,
        this.userId,
        this.house,
        this.apartment,
        this.lat,
        this.lng,
        this.type,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  AddressCart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    house = json['house'];
    apartment = json['apartment'];
    lat = json['lat'];
    lng = json['lng'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['house'] = this.house;
    data['apartment'] = this.apartment;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['type'] = this.type;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Cart {
  List<Items>? items;
  int? total;

  Cart({this.items, this.total});

  Cart.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Items {
  int? id;
  String? userId;
  String? productId;
  String? productImage;
  String? productTitle;
  String? qty;
  String? vendorId;
  String? variantId;
  String? perWeight;
  String? price;
  String? subtotal;
  String? addressId;
  Null? shippingCharges;
  Null? vat;
  String? total;

  Items(
      {this.id,
        this.userId,
        this.productId,
        this.productImage,
        this.productTitle,
        this.qty,
        this.vendorId,
        this.variantId,
        this.perWeight,
        this.price,
        this.subtotal,
        this.addressId,
        this.shippingCharges,
        this.vat,
        this.total});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    productImage = json['product_image'];
    productTitle = json['product_title'];
    qty = json['qty'];
    vendorId = json['vendor_id'];
    variantId = json['variant_id'];
    perWeight = json['per_weight'];
    price = json['price'];
    subtotal = json['subtotal'];
    addressId = json['address_id'];
    shippingCharges = json['shipping_charges'];
    vat = json['vat'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['product_image'] = this.productImage;
    data['product_title'] = this.productTitle;
    data['qty'] = this.qty;
    data['vendor_id'] = this.vendorId;
    data['variant_id'] = this.variantId;
    data['per_weight'] = this.perWeight;
    data['price'] = this.price;
    data['subtotal'] = this.subtotal;
    data['address_id'] = this.addressId;
    data['shipping_charges'] = this.shippingCharges;
    data['vat'] = this.vat;
    data['total'] = this.total;
    return data;
  }
}

class CartTotal {
  int? shippingCharges;
  int? subtotal;
  String? vat;
  int? vatPerc;
  String? total;

  CartTotal(
      {this.shippingCharges,
        this.subtotal,
        this.vat,
        this.vatPerc,
        this.total});

  CartTotal.fromJson(Map<String, dynamic> json) {
    shippingCharges = json['shipping_charges'];
    subtotal = json['subtotal'];
    vat = json['vat'].toString();
    vatPerc = json['vat_perc'];
    total = json['total'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shipping_charges'] = this.shippingCharges;
    data['subtotal'] = this.subtotal;
    data['vat'] = this.vat.toString();
    data['vat_perc'] = this.vatPerc;
    data['total'] = this.total.toString();
    return data;
  }
}
