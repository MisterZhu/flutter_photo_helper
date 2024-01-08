import 'dart:ffi';

class HomeCertifiModel {
  String? title;
  Int? width;
  Int? height;
  String? describeText;

  HomeCertifiModel({this.title, this.width, this.height, this.describeText});

  HomeCertifiModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    width = json['width'];
    height = json['height'];
    describeText = json['describeText'];
  }
}
