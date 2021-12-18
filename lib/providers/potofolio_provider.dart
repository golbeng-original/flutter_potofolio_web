import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/core/image_state.dart';
import '/core/convert.dart';

import '/packet/packet.dart' as packet;

import 'common_struct.dart';
import 'request_provider.dart';

final ImageState defaultImageState = ImageState.asset(
  assetPath: 'assets/notfound.png',
);

class PotofolioData {
  late String id;
  late String title;
  late List<ImageState> images;

  PotofolioData({
    required this.id,
    required this.title,
    required this.images,
  });

  PotofolioData.empty() {
    id = '0';
    title = '';
    images = [];
  }

  ImageState get normalImageState {
    if (images.isEmpty) {
      return defaultImageState;
    }

    return images[0];
  }

  ImageState? get hoverImageState {
    if (images.length < 2) {
      return null;
    }

    return images[1];
  }

  int get initDetailPotofolioIndex {
    if (images.length < 2) {
      return 0;
    }

    return 1;
  }

  PotofolioData copy() {
    PotofolioData copyData = PotofolioData(
      id: id,
      title: title,
      images: [...images],
    );

    return copyData;
  }
}

class PotofolioProvider extends ChangeNotifier {
  static final List<ImageState> _emptyImageState = [
    ImageState.asset(
      assetPath: 'assets/notfound.png',
    ),
  ];

  final List<PotofolioData> _potofoliolist = [];

  int get potofolioLength {
    return _potofoliolist.length;
  }

  void initialize() {
    _potofoliolist.clear();

    _addPotofolioData(
      id: '0',
      title: 'Thumbnail Test1',
      images: [
        ImageState.network(
          id: 0,
          imageUri:
              'https://gd.tjoeun.co.kr/upload/bbs/portfolio/gallery/2020/2020092917342913245362207.jpg',
        ),
        ImageState.network(
          id: 0,
          imageUri:
              'https://cdn.notefolio.net/img/1e/c3/1ec3f46db2376f1b8864186d9a27af16d63f80bb60fc3d79fd247b2ae9bb996d_v1.jpg',
        ),
        ImageState.network(
          id: 0,
          imageUri: 'https://t1.daumcdn.net/cfile/blog/187BEA204BE7AAE8DE',
        ),
      ],
    );

    _addPotofolioData(
      id: '1',
      title: 'Thumbnail Test2',
      images: [
        ImageState.network(
          id: 0,
          imageUri: 'https://t1.daumcdn.net/cfile/blog/2455914A56ADB1E315',
        ),
        ImageState.network(
          id: 0,
          imageUri:
              'https://blog.kakaocdn.net/dn/0mySg/btqCUccOGVk/nQ68nZiNKoIEGNJkooELF1/img.jpg',
        ),
        ImageState.network(
          id: 0,
          imageUri:
              'https://blog.kakaocdn.net/dn/Bq6Ew/btqCXvB2bgg/bxEjWL4bAb6k3iY3js2qb0/img.jpg',
        ),
      ],
    );

    _addPotofolioData(
      id: '2',
      title: 'Thumbnail Test3',
      images: [
        ImageState.network(
          id: 0,
          imageUri:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtzfgVAiFqLmcrULkb5qDJ16hlDgsMsB83EQ&usqp=CAU',
        ),
        ImageState.network(
          id: 0,
          imageUri:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqD2JM73CU8mkKOtRNQPN3LtA67ntY41eNQyipMfk2jfGONRXvfOTGk4Cf_RELYvs7KZ8&usqp=CAU',
        ),
        ImageState.network(
          id: 0,
          imageUri:
              'http://thumbnail.10x10.co.kr/webimage/image/basic/17/B000178663-2.jpg?cmd=thumb&w=400&h=400&fit=true&ws=false',
        ),
      ],
    );
  }

  // 전체 목록 요처
  Future<RequestProviderResult> requestPotofolioList(
    BuildContext context,
  ) async {
    final requestProvider = context.read<RequestProvider>();

    final response = await requestProvider.getMethod('/api/potofolio');
    if (response.statusCode != 200) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'status code ${response.statusCode}',
      );
    }

    final ptofolioList =
        response.getResponsePacket<packet.ResponsePotofolioList>();
    if (ptofolioList == null) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'response packet is null',
      );
    }

    _potofoliolist.clear();
    for (var element in ptofolioList.list) {
      List<ImageState> imageStateList = convertImageStateList(
        requestProvider,
        element.responseImages,
      );

      _addPotofolioData(
        id: element.id.toString(),
        title: element.title,
        images: imageStateList,
      );
    }

    notifyListeners();

    return RequestProviderResult(isSuccess: true);
  }

  // 하나의 요소를 요청.
  Future<RequestProviderResult> requestPotofolioElement(
    BuildContext context, {
    required String id,
  }) async {
    final requestProvider = context.read<RequestProvider>();

    final response = await requestProvider.getMethod('/api/potofolio/$id');
    if (response.statusCode != 200) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'status code ${response.statusCode}',
      );
    }

    final responsePotofolioElement =
        response.getResponsePacket<packet.ResponsePotofolioElement>();
    if (responsePotofolioElement == null) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'response packet is null',
      );
    }

    List<ImageState> imageStateList = convertImageStateList(
      requestProvider,
      responsePotofolioElement.responseImages,
    );

    _addPotofolioData(
      id: responsePotofolioElement.id.toString(),
      title: responsePotofolioElement.title,
      images: imageStateList,
    );

    notifyListeners();

    return RequestProviderResult(isSuccess: true);
  }

  // potofolio 생성 요청
  Future<RequestProviderResult> requestNewPotofolio(
    BuildContext context, {
    required String title,
    required List<ImageState>? imageStates,
  }) async {
    List<packet.RequestSaveImage> requestSaveImages = [];

    if (imageStates != null) {
      requestSaveImages = convertRequestSaveImageList(imageStates);
    }

    final request = packet.RequestCreatePotofolio(
      title: title,
      requestSaveIamge: requestSaveImages,
    );

    final requestProvider = context.read<RequestProvider>();
    final responseData =
        await requestProvider.postMethod('/api/potofolio', request);
    if (responseData.statusCode != 200) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'status code ${responseData.statusCode}',
      );
    }

    final responsePacket =
        responseData.getResponsePacket<packet.ResponsePotofolioElement>();

    if (responsePacket == null) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'response packet is null',
      );
    }

    final responseImageStates = convertImageStateList(
      requestProvider,
      responsePacket.responseImages,
    );

    _addPotofolioData(
      id: responsePacket.id.toString(),
      title: responsePacket.title,
      images: responseImageStates,
    );

    notifyListeners();

    return RequestProviderResult(isSuccess: true);
  }

  // potofolio 수정 요청
  Future<RequestProviderResult> requestEditPotofolio(
    BuildContext context, {
    required String id,
    String? title,
    List<int>? removeImageIds,
    List<ImageState>? addImages,
  }) async {
    List<packet.RequestSaveImage>? requestSaveImages;

    if (addImages != null) {
      requestSaveImages = convertRequestSaveImageList(addImages);
    }

    final request = packet.RequestUpdatePotofolio(
        title: title,
        removeImageIds: removeImageIds,
        addImages: requestSaveImages);

    final requestProvider = context.read<RequestProvider>();
    final responseData = await requestProvider.putMethod(
      '/api/potofolio/$id',
      request,
    );

    if (responseData.statusCode != 200) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'status code ${responseData.statusCode}',
      );
    }

    final responsePacket =
        responseData.getResponsePacket<packet.ResponsePotofolioElement>();

    if (responsePacket == null) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'response packet is null',
      );
    }

    List<ImageState> responseImageStates = convertImageStateList(
      requestProvider,
      responsePacket.responseImages,
    );

    _addPotofolioData(
      id: responsePacket.id.toString(),
      title: responsePacket.title,
      images: responseImageStates,
    );

    notifyListeners();

    return RequestProviderResult(isSuccess: true);
  }

  //potofolio 제거 요청
  Future<RequestProviderResult> requestDeletePotofolio(
    BuildContext context, {
    required String id,
  }) async {
    final requestProvider = context.read<RequestProvider>();
    final responseData = await requestProvider.deleteMethod(
      '/api/potofolio/$id',
    );

    if (responseData.statusCode != 200) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'status code ${responseData.statusCode}',
      );
    }

    _removePotofolioData(id);
    notifyListeners();

    return RequestProviderResult(isSuccess: true);
  }

  void _addPotofolioData({
    required String id,
    required String title,
    List<ImageState>? images,
  }) {
    List<ImageState> potofolioImages = _emptyImageState;
    if (images != null && images.isNotEmpty) {
      potofolioImages = images;
    }

    int findindex = _potofoliolist.indexWhere((element) => element.id == id);
    if (findindex != -1) {
      _potofoliolist[findindex] = PotofolioData(
        id: id,
        title: title,
        images: potofolioImages,
      );
    } else {
      _potofoliolist.add(
        PotofolioData(
          id: id,
          title: title,
          images: potofolioImages,
        ),
      );
    }
  }

  PotofolioData? getPotofolioDataFromIndex(int index) {
    if (index >= _potofoliolist.length) {
      return null;
    }

    return _potofoliolist[index].copy();
  }

  PotofolioData? getPotofolioData(String id) {
    final findIndex = _potofoliolist.indexWhere((element) => element.id == id);
    if (findIndex == -1) {
      return null;
    }

    return _potofoliolist[findIndex].copy();
  }

  void _removePotofolioData(String id) {
    final findIndex = _potofoliolist.indexWhere((element) => element.id == id);
    if (findIndex == -1) {
      return;
    }

    _potofoliolist.removeAt(findIndex);
  }

  static String potofolioHeroKey(String id) {
    return 'potofolio_$id';
  }
}
