class GetWalletModel {
  bool? status;
  Data? data;
  String? message;

  GetWalletModel({this.status, this.data, this.message});

  GetWalletModel.fromJson(Map<String, dynamic> json) {
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
  Wallet? wallet;

  Data({this.wallet});

  Data.fromJson(Map<String, dynamic> json) {
    wallet =
    json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    return data;
  }
}

class Wallet {
  int? id;
  String? userId;
  String? balance;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Wallet(
      {this.id,
        this.userId,
        this.balance,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    balance = json['balance'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['balance'] = this.balance;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
