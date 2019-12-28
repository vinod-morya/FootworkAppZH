class StateListResponse {
  int status;
  List<StateListBean> state;

  StateListResponse({this.status, this.state});

  StateListResponse.fromJson(Map<String, dynamic> json) {
    this.status = json['status'];
    this.state = (json['state'] as List) != null
        ? (json['state'] as List).map((i) => StateListBean.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['state'] =
        this.state != null ? this.state.map((i) => i.toJson()).toList() : null;
    return data;
  }
}

class StateListBean {
  String code;
  String name;

  StateListBean({this.code, this.name});

  StateListBean.fromJson(Map<String, dynamic> json) {
    this.code = json['code'];
    this.name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}
