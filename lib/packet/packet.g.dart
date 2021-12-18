// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestSaveImage _$RequestSaveImageFromJson(Map<String, dynamic> json) =>
    RequestSaveImage(
      filename: json['filename'] as String,
      data: json['data'] as String,
    );

Map<String, dynamic> _$RequestSaveImageToJson(RequestSaveImage instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      'data': instance.data,
    };

ResponseImage _$ResponseImageFromJson(Map<String, dynamic> json) =>
    ResponseImage(
      id: json['id'] as int,
      imageUrl: json['image'] as String,
    );

Map<String, dynamic> _$ResponseImageToJson(ResponseImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.imageUrl,
    };

RequestLogin _$RequestLoginFromJson(Map<String, dynamic> json) => RequestLogin(
      userName: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$RequestLoginToJson(RequestLogin instance) =>
    <String, dynamic>{
      'username': instance.userName,
      'password': instance.password,
    };

ResonseLogin _$ResonseLoginFromJson(Map<String, dynamic> json) => ResonseLogin(
      loginResult: json['result'] as int,
    );

Map<String, dynamic> _$ResonseLoginToJson(ResonseLogin instance) =>
    <String, dynamic>{
      'result': instance.loginResult,
    };

ResponsePotofolioElement _$ResponsePotofolioElementFromJson(
        Map<String, dynamic> json) =>
    ResponsePotofolioElement(
      id: json['id'] as int,
      title: json['title'] as String,
      responseImages: (json['images'] as List<dynamic>)
          .map((e) => ResponseImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResponsePotofolioElementToJson(
        ResponsePotofolioElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'images': instance.responseImages,
    };

ResponsePotofolioList _$ResponsePotofolioListFromJson(
        Map<String, dynamic> json) =>
    ResponsePotofolioList(
      list: (json['list'] as List<dynamic>)
          .map((e) =>
              ResponsePotofolioElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResponsePotofolioListToJson(
        ResponsePotofolioList instance) =>
    <String, dynamic>{
      'list': instance.list,
    };

RequestUpdatePotofolio _$RequestUpdatePotofolioFromJson(
        Map<String, dynamic> json) =>
    RequestUpdatePotofolio(
      title: json['title'] as String?,
      removeImageIds: (json['remove_images'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      addImages: (json['add_images'] as List<dynamic>?)
          ?.map((e) => RequestSaveImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RequestUpdatePotofolioToJson(
        RequestUpdatePotofolio instance) =>
    <String, dynamic>{
      'title': instance.title,
      'remove_images': instance.removeImageIds,
      'add_images': instance.addImages,
    };

RequestCreatePotofolio _$RequestCreatePotofolioFromJson(
        Map<String, dynamic> json) =>
    RequestCreatePotofolio(
      title: json['title'] as String,
      requestSaveIamge: (json['images'] as List<dynamic>)
          .map((e) => RequestSaveImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RequestCreatePotofolioToJson(
        RequestCreatePotofolio instance) =>
    <String, dynamic>{
      'title': instance.title,
      'images': instance.requestSaveIamge,
    };

ResponseEssayThumbnailElement _$ResponseEssayThumbnailElementFromJson(
        Map<String, dynamic> json) =>
    ResponseEssayThumbnailElement(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailImage: json['thumbnail'] as String,
    );

Map<String, dynamic> _$ResponseEssayThumbnailElementToJson(
        ResponseEssayThumbnailElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'thumbnail': instance.thumbnailImage,
    };

ResponseEssayList _$ResponseEssayListFromJson(Map<String, dynamic> json) =>
    ResponseEssayList(
      list: (json['list'] as List<dynamic>)
          .map((e) =>
              ResponseEssayThumbnailElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResponseEssayListToJson(ResponseEssayList instance) =>
    <String, dynamic>{
      'list': instance.list,
    };

ResponseEssayElement _$ResponseEssayElementFromJson(
        Map<String, dynamic> json) =>
    ResponseEssayElement(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailImage: json['thumbmail'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) => ResponseImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      essayContent: json['essay_content'] as String,
    );

Map<String, dynamic> _$ResponseEssayElementToJson(
        ResponseEssayElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'thumbmail': instance.thumbnailImage,
      'images': instance.images,
      'essay_content': instance.essayContent,
    };

RequestCreateEssay _$RequestCreateEssayFromJson(Map<String, dynamic> json) =>
    RequestCreateEssay(
      title: json['title'] as String,
      thumbnailImage:
          RequestSaveImage.fromJson(json['thumbmail'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>)
          .map((e) => RequestSaveImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      essayContent: json['essay_content'] as String,
    );

Map<String, dynamic> _$RequestCreateEssayToJson(RequestCreateEssay instance) =>
    <String, dynamic>{
      'title': instance.title,
      'thumbmail': instance.thumbnailImage,
      'images': instance.images,
      'essay_content': instance.essayContent,
    };

RequestUpdateEssay _$RequestUpdateEssayFromJson(Map<String, dynamic> json) =>
    RequestUpdateEssay(
      title: json['title'] as String?,
      thumbnailImage: json['thumbnail'] == null
          ? null
          : RequestSaveImage.fromJson(
              json['thumbnail'] as Map<String, dynamic>),
      removeImageIds: (json['remove_images'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      addImages: (json['add_images'] as List<dynamic>?)
          ?.map((e) => RequestSaveImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      essayContent: json['essay_content'] as String?,
    );

Map<String, dynamic> _$RequestUpdateEssayToJson(RequestUpdateEssay instance) =>
    <String, dynamic>{
      'title': instance.title,
      'thumbnail': instance.thumbnailImage,
      'remove_images': instance.removeImageIds,
      'add_images': instance.addImages,
      'essay_content': instance.essayContent,
    };

ResponseAboutHistoryElement _$ResponseAboutHistoryElementFromJson(
        Map<String, dynamic> json) =>
    ResponseAboutHistoryElement(
      id: json['id'] as int,
      category: json['category'] as String,
      duration: json['duration'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$ResponseAboutHistoryElementToJson(
        ResponseAboutHistoryElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'duration': instance.duration,
      'content': instance.content,
    };

ResponseAbout _$ResponseAboutFromJson(Map<String, dynamic> json) =>
    ResponseAbout(
      profileImage: json['profile_image'] as String,
      profileName: json['profile_name'] as String,
      contact: json['contact'] as String,
      introduceContent: json['introduce_content'] as String,
      histories: (json['history_list'] as List<dynamic>?)
          ?.map((e) =>
              ResponseAboutHistoryElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResponseAboutToJson(ResponseAbout instance) =>
    <String, dynamic>{
      'profile_image': instance.profileImage,
      'profile_name': instance.profileName,
      'contact': instance.contact,
      'introduce_content': instance.introduceContent,
      'history_list': instance.histories,
    };

RequestUpdateAbout _$RequestUpdateAboutFromJson(Map<String, dynamic> json) =>
    RequestUpdateAbout(
      profileImage: json['profile_image'] == null
          ? null
          : RequestSaveImage.fromJson(
              json['profile_image'] as Map<String, dynamic>),
      profileName: json['profile_name'] as String?,
      contact: json['contact'] as String?,
      introduceContent: json['introduce_content'] as String?,
    );

Map<String, dynamic> _$RequestUpdateAboutToJson(RequestUpdateAbout instance) =>
    <String, dynamic>{
      'profile_image': instance.profileImage,
      'profile_name': instance.profileName,
      'contact': instance.contact,
      'introduce_content': instance.introduceContent,
    };

RequesAboutHistoryElement _$RequesAboutHistoryElementFromJson(
        Map<String, dynamic> json) =>
    RequesAboutHistoryElement(
      category: json['category'] as String,
      duration: json['duration'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$RequesAboutHistoryElementToJson(
        RequesAboutHistoryElement instance) =>
    <String, dynamic>{
      'category': instance.category,
      'duration': instance.duration,
      'content': instance.content,
    };

RequestUpdateAboutHistoryElement _$RequestUpdateAboutHistoryElementFromJson(
        Map<String, dynamic> json) =>
    RequestUpdateAboutHistoryElement(
      id: json['id'] as int,
      category: json['category'] as String,
      duration: json['duration'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$RequestUpdateAboutHistoryElementToJson(
        RequestUpdateAboutHistoryElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'duration': instance.duration,
      'content': instance.content,
    };

RequestUpdateAboutHistory _$RequestUpdateAboutHistoryFromJson(
        Map<String, dynamic> json) =>
    RequestUpdateAboutHistory(
      removeIds: (json['remove_id_list'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      appendHistories: (json['append_history_list'] as List<dynamic>?)
          ?.map((e) =>
              RequesAboutHistoryElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      updateHistories: (json['update_history_list'] as List<dynamic>?)
          ?.map((e) => RequestUpdateAboutHistoryElement.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RequestUpdateAboutHistoryToJson(
        RequestUpdateAboutHistory instance) =>
    <String, dynamic>{
      'remove_id_list': instance.removeIds,
      'append_history_list': instance.appendHistories,
      'update_history_list': instance.updateHistories,
    };

ResponsePresent _$ResponsePresentFromJson(Map<String, dynamic> json) =>
    ResponsePresent(
      result: json['result'] as String,
      header: json['header'] as String,
      error: json['error'] as String,
      data: json['data'] as String,
    );

Map<String, dynamic> _$ResponsePresentToJson(ResponsePresent instance) =>
    <String, dynamic>{
      'result': instance.result,
      'header': instance.header,
      'error': instance.error,
      'data': instance.data,
    };
