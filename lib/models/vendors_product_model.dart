class VendorsProductModel {
  bool? status;
  Data? data;
  String? message;

  VendorsProductModel({this.status, this.data, this.message});

  VendorsProductModel.fromJson(Map<String, dynamic> json) {
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
  VendorDetails? vendorDetails;
  List<Services>? services;
  List<Products>? products;
  int? total;

  Data({this.vendorDetails, this.services, this.products, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    vendorDetails = json['vendor_details'] != null
        ? new VendorDetails.fromJson(json['vendor_details'])
        : null;
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vendorDetails != null) {
      data['vendor_details'] = this.vendorDetails!.toJson();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class VendorDetails {
  int? id;
  String? image;
  String? name;
  String? isVerified;

  VendorDetails({this.id, this.image, this.name, this.isVerified});

  VendorDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    isVerified = json['is_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['is_verified'] = this.isVerified;
    return data;
  }
}

class Services {
  int? id;
  String? image;
  String? name;
  String? status;

  Services({this.id, this.image, this.name, this.status});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}

class Products {
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
  String? deletedAt;
  String? categoryName;
  String? measurement;
  List<String>? cartExist;
  String? isVendorInCart;
  String? oldVendorName;
  List<Variant>? variant;
  String? itemCount;
  int? myVariantId;

  Products(
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
        this.variant,
        required this.itemCount,
        required this.myVariantId});

  Products.fromJson(Map<String, dynamic> json) {
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

class CartExist{
  CartExist();
  CartExist.fromJson(Map<String, dynamic> json) {}
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
