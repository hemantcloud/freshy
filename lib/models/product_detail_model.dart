class ProductDetailModel {
  bool? status;
  Data? data;
  String? message;

  ProductDetailModel({this.status, this.data, this.message});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
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
  Product? product;

  Data({this.product});

  Data.fromJson(Map<String, dynamic> json) {
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? vendorId;
  String? categoryId;
  String? image;
  String? title;
  String? description;
  String? variantType;
  String? price;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? categoryName;
  String? measurement;
  List<String>? cartExist;
  String? isVendorInCart;
  String? oldVendorName;
  List<Variant>? variant;

  Product(
      {this.id,
        this.vendorId,
        this.categoryId,
        this.image,
        this.title,
        this.description,
        this.variantType,
        this.price,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.categoryName,
        this.measurement,
        this.cartExist,
        this.isVendorInCart,
        this.oldVendorName,
        this.variant});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    categoryId = json['category_id'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
    variantType = json['variant_type'];
    price = json['price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    categoryName = json['category_name'];
    measurement = json['measurement'];
    cartExist = json['cart_exist'].cast<String>();
    isVendorInCart = json['is_vendor_in_cart'];
    oldVendorName = json['old_vendor_name'];
    if (json['variant'] != null) {
      variant = <Variant>[];
      json['variant'].forEach((v) {
        variant!.add(new Variant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['category_id'] = this.categoryId;
    data['image'] = this.image;
    data['title'] = this.title;
    data['description'] = this.description;
    data['variant_type'] = this.variantType;
    data['price'] = this.price;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['category_name'] = this.categoryName;
    data['measurement'] = this.measurement;
    data['cart_exist'] = this.cartExist;
    data['is_vendor_in_cart'] = this.isVendorInCart;
    data['old_vendor_name'] = this.oldVendorName;
    if (this.variant != null) {
      data['variant'] = this.variant!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Variant {
  int? id;
  String? productId;
  String? perWeight;
  String? price;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? qty;

  Variant(
      {this.id,
        this.productId,
        this.perWeight,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.qty});

  Variant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    perWeight = json['per_weight'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    qty = json['qty'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['per_weight'] = this.perWeight;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['qty'] = this.qty.toString();
    return data;
  }
}
