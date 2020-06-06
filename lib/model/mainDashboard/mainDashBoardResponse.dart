class MainDashBoardResponse {
  List<Data> data;
  MembershipsInfo memberships_info;
  int status;
  int user_id;
  String userFcm;
  String video_thumbnail;
  String video_url;

  MainDashBoardResponse(
      {this.data,
      this.memberships_info,
      this.status,
      this.user_id,
      this.userFcm,
      this.video_thumbnail,
      this.video_url});

  factory MainDashBoardResponse.fromJson(Map<String, dynamic> json) {
    return MainDashBoardResponse(
      data: json['data'] != null
          ? (json['data'] as List).map((i) => Data.fromJson(i)).toList()
          : null,
      memberships_info: json['memberships_info'] != null
          ? json['memberships_info'] is Map<String, dynamic>
              ? MembershipsInfo.fromJson(json['memberships_info'])
              : null
          : null,
      status: json['status'],
      userFcm: json['user_fcm'],
      user_id: json['user_id'],
      video_thumbnail: json['video_thumbnail'],
      video_url: json['video_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['user_fcm'] = this.userFcm;
    data['user_id'] = this.user_id;
    data['video_thumbnail'] = this.video_thumbnail;
    data['video_url'] = this.video_url;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.memberships_info != null) {
      data['memberships_info'] = this.memberships_info.toJson();
    }
    return data;
  }
}

class MembershipsInfo {
  int id;
  Plan plan;
  int plan_id;
  PostX post;
  String status;
  int user_id;

  MembershipsInfo(
      {this.id, this.plan, this.plan_id, this.post, this.status, this.user_id});

  factory MembershipsInfo.fromJson(Map<String, dynamic> json) {
    return MembershipsInfo(
      id: json['id'],
      plan: json['plan'] != null ? Plan.fromJson(json['plan']) : null,
      plan_id: json['plan_id'],
      post: json['post'] != null ? PostX.fromJson(json['post']) : null,
      status: json['status'],
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['plan_id'] = this.plan_id;
    data['status'] = this.status;
    data['user_id'] = this.user_id;
    if (this.plan != null) {
      data['plan'] = this.plan.toJson();
    }
    if (this.post != null) {
      data['post'] = this.post.toJson();
    }
    return data;
  }
}

class Plan {
  int id;
  String name;
  Post post;
  String slug;

  Plan({this.id, this.name, this.post, this.slug});

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      name: json['name'],
      post: json['post'] != null ? Post.fromJson(json['post']) : null,
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    if (this.post != null) {
      data['post'] = this.post.toJson();
    }
    return data;
  }
}

class Post {
  String comment_count;
  String comment_status;
  String filter;
  String guid;
  int iD;
  int menu_order;
  String ping_status;
  String pinged;
  String post_author;
  String post_content;
  String post_content_filtered;
  String post_date;
  String post_date_gmt;
  String post_excerpt;
  String post_mime_type;
  String post_modified;
  String post_modified_gmt;
  String post_name;
  int post_parent;
  String post_password;
  String post_status;
  String post_title;
  String post_type;
  String to_ping;

  Post(
      {this.comment_count,
      this.comment_status,
      this.filter,
      this.guid,
      this.iD,
      this.menu_order,
      this.ping_status,
      this.pinged,
      this.post_author,
      this.post_content,
      this.post_content_filtered,
      this.post_date,
      this.post_date_gmt,
      this.post_excerpt,
      this.post_mime_type,
      this.post_modified,
      this.post_modified_gmt,
      this.post_name,
      this.post_parent,
      this.post_password,
      this.post_status,
      this.post_title,
      this.post_type,
      this.to_ping});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      comment_count: json['comment_count'],
      comment_status: json['comment_status'],
      filter: json['filter'],
      guid: json['guid'],
      iD: json['iD'],
      menu_order: json['menu_order'],
      ping_status: json['ping_status'],
      pinged: json['pinged'],
      post_author: json['post_author'],
      post_content: json['post_content'],
      post_content_filtered: json['post_content_filtered'],
      post_date: json['post_date'],
      post_date_gmt: json['post_date_gmt'],
      post_excerpt: json['post_excerpt'],
      post_mime_type: json['post_mime_type'],
      post_modified: json['post_modified'],
      post_modified_gmt: json['post_modified_gmt'],
      post_name: json['post_name'],
      post_parent: json['post_parent'],
      post_password: json['post_password'],
      post_status: json['post_status'],
      post_title: json['post_title'],
      post_type: json['post_type'],
      to_ping: json['to_ping'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_count'] = this.comment_count;
    data['comment_status'] = this.comment_status;
    data['filter'] = this.filter;
    data['guid'] = this.guid;
    data['iD'] = this.iD;
    data['menu_order'] = this.menu_order;
    data['ping_status'] = this.ping_status;
    data['pinged'] = this.pinged;
    data['post_author'] = this.post_author;
    data['post_content'] = this.post_content;
    data['post_content_filtered'] = this.post_content_filtered;
    data['post_date'] = this.post_date;
    data['post_date_gmt'] = this.post_date_gmt;
    data['post_excerpt'] = this.post_excerpt;
    data['post_mime_type'] = this.post_mime_type;
    data['post_modified'] = this.post_modified;
    data['post_modified_gmt'] = this.post_modified_gmt;
    data['post_name'] = this.post_name;
    data['post_parent'] = this.post_parent;
    data['post_password'] = this.post_password;
    data['post_status'] = this.post_status;
    data['post_title'] = this.post_title;
    data['post_type'] = this.post_type;
    data['to_ping'] = this.to_ping;
    return data;
  }
}

class PostX {
  String comment_count;
  String comment_status;
  String filter;
  String guid;
  int iD;
  int menu_order;
  String ping_status;
  String pinged;
  String post_author;
  String post_content;
  String post_content_filtered;
  String post_date;
  String post_date_gmt;
  String post_excerpt;
  String post_mime_type;
  String post_modified;
  String post_modified_gmt;
  String post_name;
  int post_parent;
  String post_password;
  String post_status;
  String post_title;
  String post_type;
  String to_ping;

  PostX(
      {this.comment_count,
      this.comment_status,
      this.filter,
      this.guid,
      this.iD,
      this.menu_order,
      this.ping_status,
      this.pinged,
      this.post_author,
      this.post_content,
      this.post_content_filtered,
      this.post_date,
      this.post_date_gmt,
      this.post_excerpt,
      this.post_mime_type,
      this.post_modified,
      this.post_modified_gmt,
      this.post_name,
      this.post_parent,
      this.post_password,
      this.post_status,
      this.post_title,
      this.post_type,
      this.to_ping});

  factory PostX.fromJson(Map<String, dynamic> json) {
    return PostX(
      comment_count: json['comment_count'],
      comment_status: json['comment_status'],
      filter: json['filter'],
      guid: json['guid'],
      iD: json['iD'],
      menu_order: json['menu_order'],
      ping_status: json['ping_status'],
      pinged: json['pinged'],
      post_author: json['post_author'],
      post_content: json['post_content'],
      post_content_filtered: json['post_content_filtered'],
      post_date: json['post_date'],
      post_date_gmt: json['post_date_gmt'],
      post_excerpt: json['post_excerpt'],
      post_mime_type: json['post_mime_type'],
      post_modified: json['post_modified'],
      post_modified_gmt: json['post_modified_gmt'],
      post_name: json['post_name'],
      post_parent: json['post_parent'],
      post_password: json['post_password'],
      post_status: json['post_status'],
      post_title: json['post_title'],
      post_type: json['post_type'],
      to_ping: json['to_ping'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_count'] = this.comment_count;
    data['comment_status'] = this.comment_status;
    data['filter'] = this.filter;
    data['guid'] = this.guid;
    data['iD'] = this.iD;
    data['menu_order'] = this.menu_order;
    data['ping_status'] = this.ping_status;
    data['pinged'] = this.pinged;
    data['post_author'] = this.post_author;
    data['post_content'] = this.post_content;
    data['post_content_filtered'] = this.post_content_filtered;
    data['post_date'] = this.post_date;
    data['post_date_gmt'] = this.post_date_gmt;
    data['post_excerpt'] = this.post_excerpt;
    data['post_mime_type'] = this.post_mime_type;
    data['post_modified'] = this.post_modified;
    data['post_modified_gmt'] = this.post_modified_gmt;
    data['post_name'] = this.post_name;
    data['post_parent'] = this.post_parent;
    data['post_password'] = this.post_password;
    data['post_status'] = this.post_status;
    data['post_title'] = this.post_title;
    data['post_type'] = this.post_type;
    data['to_ping'] = this.to_ping;
    return data;
  }
}

class Data {
  int tap_status;
  String total_palyed_video;
  String total_video;
  String type;
  String lastActivity;

  Data(
      {this.tap_status,
      this.lastActivity,
      this.total_palyed_video,
      this.total_video,
      this.type});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      tap_status: json['tab_status'],
      lastActivity: json['last_activity'],
      total_palyed_video: json['total_palyed_video'].toString(),
      total_video: json['total_video'].toString(),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tab_status'] = this.tap_status;
    data['total_palyed_video'] = this.total_palyed_video;
    data['last_activity'] = this.lastActivity;
    data['total_video'] = this.total_video;
    data['type'] = this.type;
    return data;
  }
}
