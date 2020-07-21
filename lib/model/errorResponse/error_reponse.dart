class ErrorResponse {

  int status;
  int code;
  String error;
  dynamic thumbNail;
  dynamic videoUrl;

  ErrorResponse(
      {this.status, this.code, this.thumbNail, this.videoUrl, this.error});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    this.status = json['status'];
    this.error = json['error'];
    this.code = json['code'];
    this.thumbNail = json['video_thumbnail'];
    this.videoUrl = json['video_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.error;
    data['code'] = this.code;
    data['video_thumbnail'] = this.thumbNail;
    data['video_url'] = this.videoUrl;
    return data;
  }
}
