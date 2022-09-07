class GenericResponse {
  late String message;
  late bool error;
  late int code;
  // this is a class function
  GenericResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    error = json['error'];
    code =json['code'];
  }
}
