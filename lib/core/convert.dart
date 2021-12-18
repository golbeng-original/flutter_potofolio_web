import 'dart:convert';

import 'package:flutter_portfolio_web/providers/about_provider.dart';

import '/providers/request_provider.dart';
import '/packet/packet.dart' as packet;
import 'image_state.dart';

packet.RequestSaveImage? convertRequestSaveIamge(ImageState imageState) {
  if (imageState.isLocal == false) {
    return null;
  }

  if (imageState.localFile == null) {
    return null;
  }

  if (imageState.localFile!.bytes == null) {
    return null;
  }

  final base64Encoding = base64.encode(imageState.localFile!.bytes!);

  return packet.RequestSaveImage(
    filename: imageState.localFile!.fileName,
    data: base64Encoding,
  );
}

ImageState convertImageState(
  RequestProvider requestProvider,
  packet.ResponseImage responseImage,
) {
  return ImageState.network(
    id: responseImage.id,
    imageUri: requestProvider.getFullUrl(responseImage.imageUrl),
  );
}

List<packet.RequestSaveImage> convertRequestSaveImageList(
    List<ImageState> imageStates) {
  List<packet.RequestSaveImage> requestSaveImages = [];

  for (var imageState in imageStates) {
    final requestSaveImage = convertRequestSaveIamge(imageState);
    if (requestSaveImage == null) {
      continue;
    }

    requestSaveImages.add(requestSaveImage);
  }

  return requestSaveImages;
}

List<ImageState> convertImageStateList(
  RequestProvider requestProvider,
  List<packet.ResponseImage> responseImages,
) {
  List<ImageState> imageStateList = [];

  for (var responseImage in responseImages) {
    imageStateList.add(convertImageState(requestProvider, responseImage));
  }

  return imageStateList;
}

AboutData convertAboutData(
  RequestProvider requestProvider,
  packet.ResponseAbout responseAbout,
) {
  var aboutData = AboutData();
  aboutData.profileName = responseAbout.profileName;

  if (responseAbout.profileImage.isEmpty) {
    aboutData.profileImage = ImageState.none();
  } else {
    aboutData.profileImage = ImageState.network(
      id: 0,
      imageUri: requestProvider.getFullUrl(responseAbout.profileImage),
    );
  }

  aboutData.contact = responseAbout.contact;
  aboutData.introuceContent = responseAbout.introduceContent;
  aboutData.historyList = _convertAboutHistories(responseAbout.histories);

  return aboutData;
}

List<HistoryData> _convertAboutHistories(
  List<packet.ResponseAboutHistoryElement>? responseHistories,
) {
  List<HistoryData> histories = [];

  if (responseHistories == null) {
    return histories;
  }

  for (var responseHistory in responseHistories) {
    histories.add(
      HistoryData(
        id: responseHistory.id,
        category: responseHistory.category,
        duration: responseHistory.duration,
        content: responseHistory.content,
      ),
    );
  }

  return histories;
}

List<packet.RequesAboutHistoryElement> convertRequestAddAboutHistories(
  List<HistoryData> historyDataList,
) {
  List<packet.RequesAboutHistoryElement> list = [];
  for (var history in historyDataList) {
    list.add(
      packet.RequesAboutHistoryElement(
        category: history.category,
        duration: history.duration,
        content: history.content,
      ),
    );
  }

  return list;
}

List<packet.RequestUpdateAboutHistoryElement>
    convertRequestUpdateAboutHistories(
  List<HistoryData> historyDataList,
) {
  List<packet.RequestUpdateAboutHistoryElement> list = [];
  for (var history in historyDataList) {
    list.add(
      packet.RequestUpdateAboutHistoryElement(
        id: history.id,
        category: history.category,
        duration: history.duration,
        content: history.content,
      ),
    );
  }

  return list;
}
