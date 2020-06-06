class UserDashBoardResponse {
  int status;
  int userId;
  int currentMonth;
  MembershipsInfoBean membershipsInfo;
  dynamic thumbNail;
  dynamic videoUrl;
  List<DataListBean> data;
  List<PurchasedMonth> purchasedMonth;

  UserDashBoardResponse(
      {this.status,
      this.userId,
      this.currentMonth,
      this.membershipsInfo,
      this.purchasedMonth,
      this.data});

  UserDashBoardResponse.fromJson(Map<String, dynamic> json) {
    this.status = json['status'];
    this.userId = json['user_id'];
    this.thumbNail = json['video_thumbnail'];
    this.videoUrl = json['video_url'];
    this.currentMonth = json['current_month'];
    this.membershipsInfo = json['memberships_info'] != null
        ? MembershipsInfoBean.fromJson(json['memberships_info'])
        : null;
    this.data = (json['data'] as List) != null
        ? (json['data'] as List).map((i) => DataListBean.fromJson(i)).toList()
        : null;
    this.purchasedMonth = json['purchased_month'] != null
        ? (json['purchased_month'] as List)
            .map((i) => PurchasedMonth.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['video_thumbnail'] = this.thumbNail;
    data['video_url'] = this.videoUrl;
    data['current_month'] = this.currentMonth;
    if (this.membershipsInfo != null) {
      data['memberships_info'] = this.membershipsInfo.toJson();
    }
    if (this.purchasedMonth != null) {
      data['purchased_month'] =
          this.purchasedMonth.map((v) => v.toJson()).toList();
    }
    data['data'] =
        this.data != null ? this.data.map((i) => i.toJson()).toList() : null;
    return data;
  }
}

class MembershipsInfoBean {
  String status;
  int id;
  int planId;
  int userId;
  PlanBean plan;
  PostBean post;

  MembershipsInfoBean(
      {this.status, this.id, this.planId, this.userId, this.plan, this.post});

  MembershipsInfoBean.fromJson(Map<String, dynamic> json) {
    this.status = json['status'];
    this.id = json['id'];
    this.planId = json['plan_id'];
    this.userId = json['user_id'];
    this.plan = json['plan'] != null ? PlanBean.fromJson(json['plan']) : null;
    this.post = json['post'] != null ? PostBean.fromJson(json['post']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['id'] = this.id;
    data['plan_id'] = this.planId;
    data['user_id'] = this.userId;
    if (this.plan != null) {
      data['plan'] = this.plan.toJson();
    }
    if (this.post != null) {
      data['post'] = this.post.toJson();
    }
    return data;
  }
}

class DataListBean {
  String totalVideos;
  String month;
  String label;
  String lastActivity;
  int playVideo;
  int tapStatus;

  DataListBean(
      {this.totalVideos,
      this.month,
      this.label,
      this.lastActivity,
      this.playVideo,
      this.tapStatus});

  DataListBean.fromJson(Map<String, dynamic> json) {
    this.totalVideos = json['total_videos'];
    this.month = json['month'];
    this.label = json['label'];
    this.lastActivity = json['last_activity'];
    this.playVideo = json['play_video'];
    this.tapStatus = json['tap_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_videos'] = this.totalVideos;
    data['month'] = this.month;
    data['label'] = this.label;
    data['last_activity'] = this.lastActivity;
    data['play_video'] = this.playVideo;
    data['tap_status'] = this.tapStatus;
    return data;
  }
}

class PlanBean {
  String name;
  String slug;
  int id;
  PostBean post;

  PlanBean({this.name, this.slug, this.id, this.post});

  PlanBean.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.slug = json['slug'];
    this.id = json['id'];
    this.post = json['post'] != null ? PostBean.fromJson(json['post']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['id'] = this.id;
    if (this.post != null) {
      data['post'] = this.post.toJson();
    }
    return data;
  }
}

class PostBean {
  String postAuthor;
  String postDate;
  String postDateGmt;
  String postContent;
  String postTitle;
  String postExcerpt;
  String postStatus;
  String commentStatus;
  String pingStatus;
  String postPassword;
  String postName;
  String toPing;
  String pinged;
  String postModified;
  String postModifiedGmt;
  String postContentFiltered;
  String guid;
  String postType;
  String postMimeType;
  String commentCount;
  String filter;
  int ID;
  int postParent;
  int menuOrder;

  PostBean(
      {this.postAuthor,
      this.postDate,
      this.postDateGmt,
      this.postContent,
      this.postTitle,
      this.postExcerpt,
      this.postStatus,
      this.commentStatus,
      this.pingStatus,
      this.postPassword,
      this.postName,
      this.toPing,
      this.pinged,
      this.postModified,
      this.postModifiedGmt,
      this.postContentFiltered,
      this.guid,
      this.postType,
      this.postMimeType,
      this.commentCount,
      this.filter,
      this.ID,
      this.postParent,
      this.menuOrder});

  PostBean.fromJson(Map<String, dynamic> json) {
    this.postAuthor = json['post_author'];
    this.postDate = json['post_date'];
    this.postDateGmt = json['post_date_gmt'];
    this.postContent = json['post_content'];
    this.postTitle = json['post_title'];
    this.postExcerpt = json['post_excerpt'];
    this.postStatus = json['post_status'];
    this.commentStatus = json['comment_status'];
    this.pingStatus = json['ping_status'];
    this.postPassword = json['post_password'];
    this.postName = json['post_name'];
    this.toPing = json['to_ping'];
    this.pinged = json['pinged'];
    this.postModified = json['post_modified'];
    this.postModifiedGmt = json['post_modified_gmt'];
    this.postContentFiltered = json['post_content_filtered'];
    this.guid = json['guid'];
    this.postType = json['post_type'];
    this.postMimeType = json['post_mime_type'];
    this.commentCount = json['comment_count'];
    this.filter = json['filter'];
    this.ID = json['ID'];
    this.postParent = json['post_parent'];
    this.menuOrder = json['menu_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_author'] = this.postAuthor;
    data['post_date'] = this.postDate;
    data['post_date_gmt'] = this.postDateGmt;
    data['post_content'] = this.postContent;
    data['post_title'] = this.postTitle;
    data['post_excerpt'] = this.postExcerpt;
    data['post_status'] = this.postStatus;
    data['comment_status'] = this.commentStatus;
    data['ping_status'] = this.pingStatus;
    data['post_password'] = this.postPassword;
    data['post_name'] = this.postName;
    data['to_ping'] = this.toPing;
    data['pinged'] = this.pinged;
    data['post_modified'] = this.postModified;
    data['post_modified_gmt'] = this.postModifiedGmt;
    data['post_content_filtered'] = this.postContentFiltered;
    data['guid'] = this.guid;
    data['post_type'] = this.postType;
    data['post_mime_type'] = this.postMimeType;
    data['comment_count'] = this.commentCount;
    data['filter'] = this.filter;
    data['ID'] = this.ID;
    data['post_parent'] = this.postParent;
    data['menu_order'] = this.menuOrder;
    return data;
  }
}

class PurchasedMonth {
  String devicetype;
  String orderId;
  String purchasedmonth;
  int purchasetime;

  PurchasedMonth(
      {this.devicetype, this.orderId, this.purchasedmonth, this.purchasetime});

  factory PurchasedMonth.fromJson(Map<String, dynamic> json) {
    return PurchasedMonth(
      devicetype: json['devicetype'],
      orderId: json['orderId'],
      purchasedmonth: json['purchasedmonth'],
      purchasetime: json['purchasetime'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['devicetype'] = this.devicetype;
    data['orderId'] = this.orderId;
    data['purchasedmonth'] = this.purchasedmonth;
    data['purchasetime'] = this.purchasetime;
    return data;
  }
}
