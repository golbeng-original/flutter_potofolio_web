import 'package:flutter/scheduler.dart';
import 'package:json_annotation/json_annotation.dart';

part 'packet_util.dart';
part 'packet.g.dart';

abstract class Packet {
  Map<String, dynamic> toJson();
}

@JsonSerializable()
class RequestSaveImage extends Packet {
  @JsonKey(name: 'filename')
  final String filename;

  @JsonKey(name: 'data')
  final String data;

  RequestSaveImage({
    required this.filename,
    required this.data,
  });

  factory RequestSaveImage.fromJson(Map<String, dynamic> json) =>
      _$RequestSaveImageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequestSaveImageToJson(this);
}

@JsonSerializable()
class ResponseImage extends Packet {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'image')
  final String imageUrl;

  ResponseImage({required this.id, required this.imageUrl});

  factory ResponseImage.fromJson(Map<String, dynamic> json) =>
      _$ResponseImageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponseImageToJson(this);
}

@JsonSerializable()
class RequestLogin extends Packet {
  @JsonKey(name: 'username')
  final String userName;

  @JsonKey(name: 'password')
  final String password;

  RequestLogin({required this.userName, required this.password});

  factory RequestLogin.fromJson(Map<String, dynamic> json) =>
      _$RequestLoginFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequestLoginToJson(this);
}

@JsonSerializable()
class ResonseLogin extends Packet {
  @JsonKey(name: 'result')
  final int loginResult;
  // 0: Sucess, 1: wroung username, 2; wroung password, 3: token generate fail

  ResonseLogin({required this.loginResult});

  factory ResonseLogin.fromJson(Map<String, dynamic> json) =>
      _$ResonseLoginFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResonseLoginToJson(this);
}

@JsonSerializable()
class ResponsePotofolioElement extends Packet {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'images')
  final List<ResponseImage> responseImages;

  ResponsePotofolioElement({
    required this.id,
    required this.title,
    required this.responseImages,
  });

  factory ResponsePotofolioElement.fromJson(Map<String, dynamic> json) =>
      _$ResponsePotofolioElementFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponsePotofolioElementToJson(this);
}

@JsonSerializable()
class ResponsePotofolioList extends Packet {
  @JsonKey(name: 'list')
  List<ResponsePotofolioElement> list;

  ResponsePotofolioList({required this.list});

  factory ResponsePotofolioList.fromJson(Map<String, dynamic> json) =>
      _$ResponsePotofolioListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponsePotofolioListToJson(this);
}

@JsonSerializable()
class RequestUpdatePotofolio extends Packet {
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'remove_images')
  final List<int>? removeImageIds;
  @JsonKey(name: 'add_images')
  final List<RequestSaveImage>? addImages;

  RequestUpdatePotofolio({
    this.title,
    this.removeImageIds,
    this.addImages,
  });

  factory RequestUpdatePotofolio.fromJson(Map<String, dynamic> json) =>
      _$RequestUpdatePotofolioFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequestUpdatePotofolioToJson(this);
}

@JsonSerializable()
class RequestCreatePotofolio extends Packet {
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'images')
  final List<RequestSaveImage> requestSaveIamge;

  RequestCreatePotofolio({
    required this.title,
    required this.requestSaveIamge,
  });

  factory RequestCreatePotofolio.fromJson(Map<String, dynamic> json) =>
      _$RequestCreatePotofolioFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequestCreatePotofolioToJson(this);
}

@JsonSerializable()
class ResponseEssayThumbnailElement extends Packet {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'thumbnail')
  final String thumbnailImage;

  ResponseEssayThumbnailElement({
    required this.id,
    required this.title,
    required this.thumbnailImage,
  });

  factory ResponseEssayThumbnailElement.fromJson(Map<String, dynamic> json) =>
      _$ResponseEssayThumbnailElementFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponseEssayThumbnailElementToJson(this);
}

@JsonSerializable()
class ResponseEssayList extends Packet {
  @JsonKey(name: 'list')
  final List<ResponseEssayThumbnailElement> list;

  ResponseEssayList({
    required this.list,
  });

  factory ResponseEssayList.fromJson(Map<String, dynamic> json) =>
      _$ResponseEssayListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponseEssayListToJson(this);
}

@JsonSerializable()
class ResponseEssayElement extends Packet {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'thumbmail')
  final String thumbnailImage;
  @JsonKey(name: 'images')
  final List<ResponseImage> images;
  @JsonKey(name: 'essay_content')
  final String essayContent;

  ResponseEssayElement({
    required this.id,
    required this.title,
    required this.thumbnailImage,
    required this.images,
    required this.essayContent,
  });

  factory ResponseEssayElement.fromJson(Map<String, dynamic> json) =>
      _$ResponseEssayElementFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponseEssayElementToJson(this);
}

@JsonSerializable()
class RequestCreateEssay extends Packet {
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'thumbmail')
  final RequestSaveImage thumbnailImage;
  @JsonKey(name: 'images')
  final List<RequestSaveImage> images;
  @JsonKey(name: 'essay_content')
  final String essayContent;

  RequestCreateEssay({
    required this.title,
    required this.thumbnailImage,
    required this.images,
    required this.essayContent,
  });

  factory RequestCreateEssay.fromJson(Map<String, dynamic> json) =>
      _$RequestCreateEssayFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequestCreateEssayToJson(this);
}

@JsonSerializable()
class RequestUpdateEssay extends Packet {
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'thumbnail')
  final RequestSaveImage? thumbnailImage;
  @JsonKey(name: 'remove_images')
  final List<int>? removeImageIds;
  @JsonKey(name: 'add_images')
  final List<RequestSaveImage>? addImages;
  @JsonKey(name: 'essay_content')
  final String? essayContent;

  RequestUpdateEssay({
    this.title,
    this.thumbnailImage,
    this.removeImageIds,
    this.addImages,
    this.essayContent,
  });

  factory RequestUpdateEssay.fromJson(Map<String, dynamic> json) =>
      _$RequestUpdateEssayFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequestUpdateEssayToJson(this);
}

@JsonSerializable()
class ResponseAboutHistoryElement extends Packet {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'category')
  final String category;
  @JsonKey(name: 'duration')
  final String duration;
  @JsonKey(name: 'content')
  final String content;

  ResponseAboutHistoryElement({
    required this.id,
    required this.category,
    required this.duration,
    required this.content,
  });

  factory ResponseAboutHistoryElement.fromJson(Map<String, dynamic> json) =>
      _$ResponseAboutHistoryElementFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponseAboutHistoryElementToJson(this);
}

@JsonSerializable()
class ResponseAbout extends Packet {
  @JsonKey(name: 'profile_image')
  final String profileImage;
  @JsonKey(name: 'profile_name')
  final String profileName;
  @JsonKey(name: 'contact')
  final String contact;
  @JsonKey(name: 'introduce_content')
  final String introduceContent;
  @JsonKey(name: 'history_list')
  final List<ResponseAboutHistoryElement>? histories;

  ResponseAbout({
    required this.profileImage,
    required this.profileName,
    required this.contact,
    required this.introduceContent,
    required this.histories,
  });

  factory ResponseAbout.fromJson(Map<String, dynamic> json) =>
      _$ResponseAboutFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponseAboutToJson(this);
}

@JsonSerializable()
class RequestUpdateAbout extends Packet {
  @JsonKey(name: 'profile_image')
  final RequestSaveImage? profileImage;
  @JsonKey(name: 'profile_name')
  final String? profileName;
  @JsonKey(name: 'contact')
  final String? contact;
  @JsonKey(name: 'introduce_content')
  final String? introduceContent;

  RequestUpdateAbout({
    this.profileImage,
    this.profileName,
    this.contact,
    this.introduceContent,
  });

  factory RequestUpdateAbout.fromJson(Map<String, dynamic> json) =>
      _$RequestUpdateAboutFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequestUpdateAboutToJson(this);
}

@JsonSerializable()
class RequesAboutHistoryElement extends Packet {
  @JsonKey(name: 'category')
  final String category;
  @JsonKey(name: 'duration')
  final String duration;
  @JsonKey(name: 'content')
  final String content;

  RequesAboutHistoryElement({
    required this.category,
    required this.duration,
    required this.content,
  });

  factory RequesAboutHistoryElement.fromJson(Map<String, dynamic> json) =>
      _$RequesAboutHistoryElementFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequesAboutHistoryElementToJson(this);
}

@JsonSerializable()
class RequestUpdateAboutHistoryElement extends Packet {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'category')
  final String category;
  @JsonKey(name: 'duration')
  final String duration;
  @JsonKey(name: 'content')
  final String content;

  RequestUpdateAboutHistoryElement({
    required this.id,
    required this.category,
    required this.duration,
    required this.content,
  });

  factory RequestUpdateAboutHistoryElement.fromJson(
          Map<String, dynamic> json) =>
      _$RequestUpdateAboutHistoryElementFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$RequestUpdateAboutHistoryElementToJson(this);
}

@JsonSerializable()
class RequestUpdateAboutHistory extends Packet {
  @JsonKey(name: 'remove_id_list')
  final List<int>? removeIds;
  @JsonKey(name: 'append_history_list')
  final List<RequesAboutHistoryElement>? appendHistories;
  @JsonKey(name: 'update_history_list')
  final List<RequestUpdateAboutHistoryElement>? updateHistories;

  RequestUpdateAboutHistory({
    this.removeIds,
    this.appendHistories,
    this.updateHistories,
  });

  factory RequestUpdateAboutHistory.fromJson(Map<String, dynamic> json) =>
      _$RequestUpdateAboutHistoryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequestUpdateAboutHistoryToJson(this);
}

@JsonSerializable()
class ResponsePresent extends Packet {
  @JsonKey(name: 'result')
  final String result;
  @JsonKey(name: 'header')
  final String header;
  @JsonKey(name: 'error')
  final String error;
  @JsonKey(name: 'data')
  final String data;

  ResponsePresent({
    required this.result,
    required this.header,
    required this.error,
    required this.data,
  });
  factory ResponsePresent.fromJson(Map<String, dynamic> json) =>
      _$ResponsePresentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponsePresentToJson(this);
}
