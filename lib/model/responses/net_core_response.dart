class NetCoreResponse {
  late String message;
  // this is a class function
  NetCoreResponse.fromJson(Map<String, dynamic> json) {
    message = json['result'];
  }
}
