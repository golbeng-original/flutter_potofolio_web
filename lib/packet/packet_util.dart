part of 'packet.dart';

dynamic fromJson<T>(Object? jsonContent) {
  if (jsonContent == null) {
    return null;
  }

  final jsonMap = jsonContent as Map<String, dynamic>?;
  if (jsonMap == null) {
    return null;
  }

  switch (T) {
    case ResonseLogin:
      return ResonseLogin.fromJson(jsonMap);
    case ResponsePotofolioList:
      return ResponsePotofolioList.fromJson(jsonMap);
    case ResponsePotofolioElement:
      return ResponsePotofolioElement.fromJson(jsonMap);
    case ResponseEssayList:
      return ResponseEssayList.fromJson(jsonMap);
    case ResponseEssayElement:
      return ResponseEssayElement.fromJson(jsonMap);
    case ResponseAbout:
      return ResponseAbout.fromJson(jsonMap);
    default:
      return null;
  }
}
