import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/request_provider.dart';
import '/providers/common_struct.dart';
import '/core/image_state.dart';
import '/core/convert.dart';

import '/packet/packet.dart' as packet;

class EssayData {
  late final String id;
  String title = '';
  ImageState essayThumnailImage = ImageState.none();
  List<ImageState> images = [];
  String essayText = '';

  EssayData({
    required this.id,
    required this.title,
    required this.essayThumnailImage,
    required this.images,
    required this.essayText,
  });

  EssayData.empty() {
    id = '0';
    title = '';
    essayThumnailImage = ImageState.none();
    images = [];
    essayText = '';
  }

  String get essayThumbnailImageUrl {
    if (essayThumnailImage.isLocal == true) {
      return '';
    }

    return essayThumnailImage.imageUri ?? '';
  }

  EssayData copy() {
    EssayData copyData = EssayData(
      id: id,
      title: title,
      essayThumnailImage: essayThumnailImage,
      images: [...images],
      essayText: essayText,
    );

    return copyData;
  }
}

class EssayProvider extends ChangeNotifier {
  final List<EssayData> _essayList = [];

  int get essayLength {
    return _essayList.length;
  }

  // 전체 목록 요청
  Future<RequestProviderResult> requestEssayList(BuildContext context) async {
    final requestProvider = context.read<RequestProvider>();

    final response = await requestProvider.getMethod('/api/essay');
    if (response.statusCode != 200) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'status code ${response.statusCode}',
      );
    }

    final essayList = response.getResponsePacket<packet.ResponseEssayList>();
    if (essayList == null) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'response packet is null',
      );
    }

    _essayList.clear();

    for (var element in essayList.list) {
      _addEssayData(
        id: element.id.toString(),
        title: element.title,
        thumnailImageUrl: requestProvider.getFullUrl(element.thumbnailImage),
      );
    }

    notifyListeners();

    return RequestProviderResult(isSuccess: true);
  }

  // essay 하나 요소 요청
  Future<RequestProviderResult> requestEssayElement(
    BuildContext context, {
    required String id,
  }) async {
    final requestProvider = context.read<RequestProvider>();

    final response = await requestProvider.getMethod('/api/essay/$id');
    if (response.statusCode != 200) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'status code ${response.statusCode}',
      );
    }

    final responseEssayElement =
        response.getResponsePacket<packet.ResponseEssayElement>();
    if (responseEssayElement == null) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'response packet is null',
      );
    }

    final imageStateList = convertImageStateList(
      requestProvider,
      responseEssayElement.images,
    );

    _addEssayData(
      id: responseEssayElement.id.toString(),
      title: responseEssayElement.title,
      thumnailImageUrl:
          requestProvider.getFullUrl(responseEssayElement.thumbnailImage),
      images: imageStateList,
      essayText: responseEssayElement.essayContent,
    );

    return RequestProviderResult(isSuccess: true);
  }

  // essay 생성 요청
  Future<RequestProviderResult> requestNewEssay(
    BuildContext context, {
    required String title,
    required ImageState thumbnailImageState,
    List<ImageState>? imageStates,
    String? essayContent,
  }) async {
    final thumbnailRequestImage = convertRequestSaveIamge(thumbnailImageState);
    if (thumbnailRequestImage == null) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'generate thumnailRequestImage error',
      );
    }

    final requestSaveIamges = convertRequestSaveImageList(imageStates ?? []);
    final request = packet.RequestCreateEssay(
      title: title,
      thumbnailImage: thumbnailRequestImage,
      images: requestSaveIamges,
      essayContent: essayContent ?? '',
    );

    final requestProvider = context.read<RequestProvider>();
    final responseData =
        await requestProvider.postMethod('/api/essay', request);
    if (responseData.statusCode != 200) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'status code ${responseData.statusCode}',
      );
    }

    final responsePacket =
        responseData.getResponsePacket<packet.ResponseEssayElement>();
    if (responsePacket == null) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'response packet is null',
      );
    }

    final imageStateList = convertImageStateList(
      requestProvider,
      responsePacket.images,
    );

    _addEssayData(
      id: responsePacket.id.toString(),
      title: responsePacket.title,
      thumnailImageUrl:
          requestProvider.getFullUrl(responsePacket.thumbnailImage),
      images: imageStateList,
      essayText: responsePacket.essayContent,
    );

    notifyListeners();

    return RequestProviderResult(isSuccess: true);
  }

  // essay 수정 요청
  Future<RequestProviderResult> requestEditEssay(
    BuildContext context, {
    required String id,
    String? title,
    ImageState? thumbnailImage,
    List<int>? removeImageIds,
    List<ImageState>? addImages,
    String? essayContent,
  }) async {
    packet.RequestSaveImage? requestThumbnailSaveImage;
    if (thumbnailImage != null) {
      requestThumbnailSaveImage = convertRequestSaveIamge(thumbnailImage);
    }

    List<packet.RequestSaveImage>? requestSaveImages;
    if (addImages != null) {
      requestSaveImages = convertRequestSaveImageList(addImages);
    }

    final request = packet.RequestUpdateEssay(
      title: title,
      thumbnailImage: requestThumbnailSaveImage,
      removeImageIds: removeImageIds,
      addImages: requestSaveImages,
      essayContent: essayContent,
    );

    final requestProvider = context.read<RequestProvider>();
    final responseData = await requestProvider.putMethod(
      '/api/essay/$id',
      request,
    );

    if (responseData.statusCode != 200) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'status code ${responseData.statusCode}',
      );
    }

    final responsePacket =
        responseData.getResponsePacket<packet.ResponseEssayElement>();

    if (responsePacket == null) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'response packet is null',
      );
    }

    final imageStateList = convertImageStateList(
      requestProvider,
      responsePacket.images,
    );

    _addEssayData(
      id: responsePacket.id.toString(),
      title: responsePacket.title,
      thumnailImageUrl:
          requestProvider.getFullUrl(responsePacket.thumbnailImage),
      images: imageStateList,
      essayText: responsePacket.essayContent,
    );

    notifyListeners();

    return RequestProviderResult(isSuccess: true);
  }

  // essay 제거 요청
  Future<RequestProviderResult> requestDeleteEssay(
    BuildContext context, {
    required String id,
  }) async {
    final requestProvider = context.read<RequestProvider>();
    final responseData = await requestProvider.deleteMethod(
      '/api/essay/$id',
    );

    if (responseData.statusCode != 200) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'status code ${responseData.statusCode}',
      );
    }

    _removeEssayData(id);
    notifyListeners();

    return RequestProviderResult(isSuccess: true);
  }

  void _addEssayData({
    required String id,
    required String title,
    required String thumnailImageUrl,
    List<ImageState>? images,
    String essayText = '',
  }) {
    final thumbnailImageState = ImageState.network(
      id: 0,
      imageUri: thumnailImageUrl,
    );

    final essayData = EssayData(
      id: id,
      title: title,
      essayThumnailImage: thumbnailImageState,
      images: images ?? [],
      essayText: essayText,
    );

    final findIndex = _essayList.indexWhere((element) => element.id == id);
    if (findIndex == -1) {
      _essayList.add(essayData);
      return;
    }

    _essayList[findIndex] = essayData;
  }

  EssayData? getEssayDataFromIndex(int index) {
    if (index >= _essayList.length) {
      return null;
    }

    return _essayList[index].copy();
  }

  EssayData? getEssayData(String id) {
    final findIndex = _essayList.indexWhere((element) => element.id == id);
    if (findIndex == -1) {
      return null;
    }

    return _essayList[findIndex].copy();
  }

  void _removeEssayData(String id) {
    final findIndex = _essayList.indexWhere((element) => element.id == id);
    if (findIndex == -1) {
      return;
    }

    _essayList.removeAt(findIndex);
  }
}
