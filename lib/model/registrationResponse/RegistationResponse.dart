class RegistrationResponse {
  int status;
  String cookie;
  dynamic userId;

  RegistrationResponse({this.status, this.cookie, this.userId});

  RegistrationResponse.fromJson(Map<String, dynamic> json) {
    this.status = json['status'];
    this.cookie = json['cookie'];
    this.userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['cookie'] = this.cookie;
    data['user_id'] = this.userId;
    return data;
  }
}
