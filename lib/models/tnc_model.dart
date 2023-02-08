class TNCModel {
  bool? status;
  Data? data;
  String? message;

  TNCModel({this.status, this.data, this.message});

  TNCModel.fromJson(Map<String, dynamic> json) {
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
  String? tnc;

  Data({this.tnc});

  Data.fromJson(Map<String, dynamic> json) {
    tnc = json['tnc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tnc'] = this.tnc;
    return data;
  }
}
