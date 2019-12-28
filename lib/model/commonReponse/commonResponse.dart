class CommonResponse {
  int status;
  String message;
  String msg;

  CommonResponse({this.status, this.message});

  CommonResponse.fromJson(Map<String, dynamic> json) {
    this.status = json['status'];
    this.message = json['message'];
    this.msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['message'] = this.message;
    return data;
  }
}
