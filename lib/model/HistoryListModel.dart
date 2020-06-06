import 'package:flutter/material.dart';

class HistoryListModel {
  String message;
  dynamic status;
  List<DataListBean> data;

  HistoryListModel({this.message, this.status, this.data});

  HistoryListModel.fromJson(Map<String, dynamic> json) {
    this.message = json['message'];
    this.status = json['status'];
    this.data = (json['data'] as List) != null
        ? (json['data'] as List).map((i) => DataListBean.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['data'] =
        this.data != null ? this.data.map((i) => i.toJson()).toList() : null;
    return data;
  }
}

class DataListBean {
  dynamic id;
  String name;
  String catImage;
  dynamic categoryNumber;
  dynamic playVideoCount;
  IconData icon;

  DataListBean(
      {this.id,
      this.name,
      this.catImage,
      this.categoryNumber,
      this.playVideoCount,
      this.icon});

  DataListBean.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.catImage = json['cat_image'];
    this.categoryNumber = json['category_number'];
    this.playVideoCount = json['play_video_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cat_image'] = this.catImage;
    data['category_number'] = this.categoryNumber;
    data['play_video_count'] = this.playVideoCount;
    return data;
  }
}
