class VideoListResponseData {
  int status;
  String month;
  int userId;
  List<VideoListBean> data;

  VideoListResponseData({this.status, this.month, this.userId, this.data});

  VideoListResponseData.fromJson(Map<String, dynamic> json) {
    this.status = json['status'];
    this.month = json['month'];
    this.userId = json['user_id'];
    this.data = (json['data'] as List) != null
        ? (json['data'] as List).map((i) => VideoListBean.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['month'] = this.month;
    data['user_id'] = this.userId;
    data['data'] =
        this.data != null ? this.data.map((i) => i.toJson()).toList() : null;
    return data;
  }
}

class VideoListBean {
  String month;
  String lang;
  String label;
  String videoUrl;
  String videoThumb;
  String createdDate;
  String updatedDate;
  dynamic id;
  List<PlayStatusListBean> playStatus;

  VideoListBean(
      {this.month,
      this.label,
      this.lang,
      this.videoUrl,
      this.videoThumb,
      this.createdDate,
      this.updatedDate,
      this.id,
      this.playStatus});

  VideoListBean.fromJson(Map<String, dynamic> json) {
    this.month = json['month'];
    this.lang = json['lang'];
    this.label = json['label'];
    this.videoUrl = json['video_url'];
    this.videoThumb = json['video_thumb'];
    this.createdDate = json['created_date'];
    this.updatedDate = json['updated_date'];
    this.id = json['id'];
    this.playStatus = (json['play_status'] as List) != null
        ? (json['play_status'] as List)
            .map((i) => PlayStatusListBean.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['lang'] = this.lang;
    data['label'] = this.label;
    data['video_url'] = this.videoUrl;
    data['video_thumb'] = this.videoThumb;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['id'] = this.id;
    data['play_status'] = this.playStatus != null
        ? this.playStatus.map((i) => i.toJson()).toList()
        : null;
    return data;
  }
}

class PlayStatusListBean {
  String id;
  String userId;
  String videoId;
  String month;
  String videoPlayStatus;
  String videoPlayTime;
  String isFavorite;
  String createdAt;
  String updatedAt;
  String comment;
  dynamic rating;

  PlayStatusListBean(
      {this.id,
      this.userId,
      this.videoId,
      this.month,
      this.comment,
      this.rating,
      this.videoPlayStatus,
      this.videoPlayTime,
      this.isFavorite,
      this.createdAt,
      this.updatedAt});

  PlayStatusListBean.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.userId = json['user_id'];
    this.rating = json['rating'];
    this.videoId = json['video_id'];
    this.comment = json['comment'];
    this.month = json['month'];
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
    data['comment'] = this.comment;
    data['video_id'] = this.videoId;
    data['rating'] = this.rating;
    data['month'] = this.month;
    data['video_play_status'] = this.videoPlayStatus;
    data['video_play_time'] = this.videoPlayTime;
    data['is_favorite'] = this.isFavorite;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
