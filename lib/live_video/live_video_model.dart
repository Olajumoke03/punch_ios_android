
class LiveVideoModel {
  String? status;
  bool? streaming;
  Data? data;

  LiveVideoModel({this.status, this.streaming, this.data});

  LiveVideoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    streaming = json['streaming'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['streaming'] = this.streaming;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? url;
  String? title;

  Data({this.url, this.title});

  Data.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['title'] = this.title;
    return data;
  }
}



