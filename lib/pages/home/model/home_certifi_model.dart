import 'dart:ffi';

class HomeCertifiModel {
  String? title;
  int? width;
  int? height;
  String? describeText;

  HomeCertifiModel({this.title, this.width, this.height, this.describeText});

  HomeCertifiModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    width = json['width'];
    height = json['height'];
    describeText = json['describeText'];
  }
}
