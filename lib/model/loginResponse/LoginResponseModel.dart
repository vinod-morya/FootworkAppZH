class LoginResponseModel {
  int status;
  String cookie;
  String cookieName;
  UserBean user;

  LoginResponseModel({this.status, this.cookie, this.cookieName, this.user});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    this.status = json['status'];
    this.cookie = json['cookie'];
    this.cookieName = json['cookie_name'];
    this.user = json['user'] != null ? UserBean.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['cookie'] = this.cookie;
    data['cookie_name'] = this.cookieName;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class UserBean {
  String username = "";
  String nicename = "";
  String email = "";
  String url = "";
  String registered = "";
  String displayname = "";
  String firstname = "";
  String lastname = "";
  String nickname = "";
  String description = "";
  String avatar = "";
  String country = "";
  String state = "";
  String city = "";
  String postcode = "";
  String phone = "";
  String password = "";
  String notificationStatus = "";
  int id;
  int userRole;
  CapabilitiesBean capabilities;
  String address = "";

  UserBean(
      {this.username,
      this.nicename,
      this.email,
      this.url,
      this.registered,
      this.displayname,
      this.firstname,
      this.lastname,
      this.notificationStatus,
      this.password,
      this.nickname,
      this.description,
      this.avatar,
      this.country,
      this.state,
      this.city,
      this.postcode,
      this.phone,
      this.id,
      this.userRole,
      this.capabilities,
      this.address});

  UserBean.fromJson(Map<String, dynamic> json) {
    this.username = json['username'];
    this.nicename = json['nicename'];
    this.email = json['email'];
    this.notificationStatus = json['notification_status'];
    this.url = json['url'];
    this.password = json['password'];
    this.registered = json['registered'];
    this.displayname = json['displayname'];
    this.firstname = json['firstname'];
    this.lastname = json['lastname'];
    this.nickname = json['nickname'];
    this.description = json['description'];
    this.avatar = json['avatar'];
    this.country = json['country'];
    this.state = json['state'];
    this.city = json['city'];
    this.postcode = json['postcode'];
    this.phone = json['phone'];
    this.id = json['id'];
    this.userRole = json['user_role'];
    this.capabilities = json['capabilities'] != null
        ? CapabilitiesBean.fromJson(json['capabilities'])
        : null;
    this.address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['nicename'] = this.nicename;
    data['email'] = this.email;
    data['password'] = this.password;
    data['url'] = this.url;
    data['notification_status'] = this.notificationStatus;
    data['registered'] = this.registered;
    data['displayname'] = this.displayname;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['nickname'] = this.nickname;
    data['description'] = this.description;
    data['avatar'] = this.avatar;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['postcode'] = this.postcode;
    data['phone'] = this.phone;
    data['id'] = this.id;
    data['user_role'] = this.userRole;
    if (this.capabilities != null) {
      data['capabilities'] = this.capabilities.toJson();
    }
    data['address'] = this.address;
    return data;
  }
}

class CapabilitiesBean {
  bool subscriber;

  CapabilitiesBean({this.subscriber});

  CapabilitiesBean.fromJson(Map<String, dynamic> json) {
    this.subscriber = json['subscriber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscriber'] = this.subscriber;
    return data;
  }
}
