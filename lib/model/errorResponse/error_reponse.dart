class ErrorResponse {
  int status;
  int code;
  String error;

  ErrorResponse({this.status, this.code, this.error});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    this.status = json['status'];
    this.error = json['error'];
    this.code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.error;
    data['code'] = this.code;
    return data;
  }
}
