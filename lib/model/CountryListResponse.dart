class CountryListResponse {
  int status;
  List<CountriesListBean> countries;

  CountryListResponse({this.status, this.countries});

  CountryListResponse.fromJson(Map<String, dynamic> json) {
    this.status = json['status'];
    this.countries = (json['countries'] as List) != null
        ? (json['countries'] as List)
            .map((i) => CountriesListBean.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['countries'] = this.countries != null
        ? this.countries.map((i) => i.toJson()).toList()
        : null;
    return data;
  }
}

class CountriesListBean {
  String name;
  String code;

  CountriesListBean({this.name, this.code});

  CountriesListBean.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    return data;
  }
}
