class HomeModel {
  bool? status;
  Data? data;
  String? message;

  HomeModel({this.status, this.data, this.message});

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<Category>? category;
  List<BannerModel>? banner;
  List<FeatureVendor>? featureVendor;

  Data({this.category, this.banner, this.featureVendor});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(Category.fromJson(v));
      });
    }
    if (json['banner'] != null) {
      banner = <BannerModel>[];
      json['banner'].forEach((v) {
        banner!.add(BannerModel.fromJson(v));
      });
    }
    if (json['feature_vendor'] != null) {
      featureVendor = <FeatureVendor>[];
      json['feature_vendor'].forEach((v) {
        featureVendor!.add(FeatureVendor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.banner != null) {
      data['banner'] = this.banner!.map((v) => v.toJson()).toList();
    }
    if (this.featureVendor != null) {
      data['feature_vendor'] =
          this.featureVendor!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? id;
  String? image;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Category(
      {this.id,
        this.image,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class BannerModel {
  int? id;
  String? image;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  BannerModel(
      {this.id,
        this.image,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class FeatureVendor {
  int? id;
  String? image;
  String? name;
  String? email;
  Null? emailVerifiedAt;
  Null? countryCode;
  String? phone;
  String? address;
  String? lat;
  String? lng;
  String? role;
  String? isVerified;
  String? featured;
  String? device;
  Null? deviceId;
  Null? fcmToken;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  List<Categories>? categories;
 String? rating;

  FeatureVendor(
      {this.id,
        this.image,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.countryCode,
        this.phone,
        this.address,
        this.lat,
        this.lng,
        this.role,
        this.isVerified,
        this.featured,
        this.device,
        this.deviceId,
        this.fcmToken,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.categories,
       this.rating
      });

  FeatureVendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    countryCode = json['country_code'];
    phone = json['phone'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    role = json['role'];
    isVerified = json['is_verified'];
    featured = json['featured'];
    device = json['device'];
    deviceId = json['device_id'];
    fcmToken = json['fcm_token'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    rating = json['rating'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['role'] = this.role;
    data['is_verified'] = this.isVerified;
    data['featured'] = this.featured;
    data['device'] = this.device;
    data['device_id'] = this.deviceId;
    data['fcm_token'] = this.fcmToken;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
   data['rating'] = this.rating.toString();
    return data;
  }
}

class Categories {
  int? id;
  String? image;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Categories(
      {this.id,
        this.image,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
