class FavouriteVideoResponse {
  int status;
  int userId;
  List<DataListBean> data;

  FavouriteVideoResponse({this.status, this.userId, this.data});

  FavouriteVideoResponse.fromJson(Map<String, dynamic> json) {
    this.status = json['status'];
    this.userId = json['user_id'];
    this.data = (json['data'] as List) != null
        ? (json['data'] as List).map((i) => DataListBean.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['data'] =
        this.data != null ? this.data.map((i) => i.toJson()).toList() : null;
    return data;
  }
}

class DataListBean {
  String id;
  String month;
  String label;
  String lang;
  String videoUrl;
  String videoThumb;
  String createdDate;
  String updatedDate;
  PlayStatusBean playStatus;

  DataListBean(
      {this.id,
      this.month,
      this.label,
      this.lang,
      this.videoUrl,
      this.videoThumb,
      this.createdDate,
      this.updatedDate,
      this.playStatus});

  DataListBean.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.month = json['month'];
    this.label = json['label'];
    this.lang = json['lang'];
    this.videoUrl = json['video_url'];
    this.videoThumb = json['video_thumb'];
    this.createdDate = json['created_date'];
    this.updatedDate = json['updated_date'];
    this.playStatus = json['play_status'] != null
        ? PlayStatusBean.fromJson(json['play_status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['month'] = this.month;
    data['label'] = this.label;
    data['lang'] = this.lang;
    data['video_url'] = this.videoUrl;
    data['video_thumb'] = this.videoThumb;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    if (this.playStatus != null) {
      data['play_status'] = this.playStatus.toJson();
    }
    return data;
  }
}

class PlayStatusBean {
  String id;
  String userId;
  String videoId;
  String month;
  String videoPlayStatus;
  String videoPlayTime;
  String isFavorite;
  String createdAt;
  String comment;
  String updatedAt;
  dynamic rating;

  PlayStatusBean(
      {this.id,
      this.userId,
      this.rating,
      this.videoId,
      this.month,
      this.videoPlayStatus,
      this.videoPlayTime,
      this.comment,
      this.isFavorite,
      this.createdAt,
      this.updatedAt});

  PlayStatusBean.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.userId = json['user_id'];
    this.rating = json['rating'];
    this.videoId = json['video_id'];
    this.month = json['month'];
    this.comment = json['comment'];
    this.videoPlayStatus = json['video_play_status'];
    this.videoPlayTime = json['video_play_time'];
    this.isFavorite = json['is_favorite'];
    this.createdAt = json['created_at'];
    this.updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['video_id'] = this.videoId;
    data['comment'] = this.comment;
    data['month'] = this.month;
    data['rating'] = this.rating;
    data['video_play_status'] = this.videoPlayStatus;
    data['video_play_time'] = this.videoPlayTime;
    data['is_favorite'] = this.isFavorite;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
