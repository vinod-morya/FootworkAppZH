class ErrorResponse {
  int status;
  String error;

  ErrorResponse({this.status, this.error});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    this.status = json['status'];
    this.error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.error;
    return data;
  }
}
