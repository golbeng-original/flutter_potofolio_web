import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/request_provider.dart';
import '/providers/common_struct.dart';
import '/core/image_state.dart';
import '/core/convert.dart';

import '/packet/packet.dart' as packet;

class HistoryData {
  int id;
  String category = '';
  String duration = '';
  String content = '';

  HistoryData({
    required this.id,
    this.category = '',
    this.duration = '',
    this.content = '',
  });
}

class AboutData {
  ImageState profileImage = ImageState.none();
  String profileName = '';
  String contact = '';
  String introuceContent = '';

  List<HistoryData> historyList = [];

  AboutData copy() {
    AboutData copyData = AboutData();
    copyData.profileImage = profileImage;
    copyData.profileName = profileName;
    copyData.contact = contact;
    copyData.introuceContent = introuceContent;

    for (var originaHistory in historyList) {
      copyData.historyList.add(HistoryData(
        id: originaHistory.id,
        category: originaHistory.category,
        duration: originaHistory.duration,
        content: originaHistory.content,
      ));
    }

    return copyData;
  }
}

class AboutProvider extends ChangeNotifier {
  AboutData _aboutData = AboutData();

  AboutData get aboutData {
    return _aboutData;
  }

  void initialize() {
    /*
    _aboutData.profileName = '조병호';
    _aboutData.profileImage = ImageState.network(
        id: 0,
        imageUri:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSseMNEY-uaKYNviDVA_S3dZIR3MAyLZhRwrQ&usqp=CAU');

    _aboutData.contact =
        '010 8415 6001\n\n21qudhg@naver.com\n\n서울특별시 송파구 석촌동 259-10';

    _aboutData.introuceContent =
        '<p>공간에 대한 개념이 없었던 어렸을 적 부터 공간을 가지고 놀기 좋아했습니다.</p> <p style="font-weight:bold">공간의 틈만 있으면 이불로 비밀기지를 만들고</p><p>, 다친 길강아지를 위해 아파트 지하에 임시 거주지를 만들어 주거나, 커다란 바위들 사이에 아지트를 만들어 놀기도 하였습니다. 건축에 대해서 무지했던 어린시절부터 오늘날까지 진행중인 경험들은 오늘날 건축을 할 수 있게 해주는 자양분이 되고 있습니다. 직접 해보지 않은 일에 대해서 스스로 체득하고자 많은 경험을 쌓고자 합니다. 내가 아닌 다른사람이 꿈꾸는 공간을 계획한다는 점에서 항상 정직해야한다는 생각을 가지고 일은 신중하고 꼼꼼하게 해내려 합니다. 계획안으로 머물렀던 프로젝트들이 점점 구체화 되고 공사가 되어 실현이 되어가고 있는 저의 시점에서 앞으로 나야가야할 방향을 바라봅니다. 프로젝트를 게획부터 마무리까지 진행하면서 큰 성취감도 있지만, 다시한번 되돌아보면 항상 부족함을 느끼곤 합니다. 저는 성취감보다 그 부족함을 제가 나야가야할 방향이라고 늘 생각합니다.  프로젝트가 갖고있는 이야기와 본질, 프로젝트의 구체화 과정, 실시도면의 중요성, 공사현장의 경험이 제가 생각했던 방향의 발자취입니다. 앞으로도 채워나가야할 발자취들이 정말 많겠지만 부족함을 발팜삼아 성취감에 도취하지 않고 앞으로 앞으로 한걸음 나아가고자 합니다.</p>';

    _aboutData.historyList = [
      HistoryData(
          category: 'edicatopm',
          duration: '2006 - 2009',
          content: '증평공업고등학교 | 건축과 졸업'),
      HistoryData(
          category: '', duration: '2009 - 2016', content: '한밭대학교 | 건축과 졸업'),
      HistoryData(category: 'Works', duration: '2016 - 2018', content: '로디자인'),
      HistoryData(category: '', duration: '2018 - 2020', content: '하눌주택'),
      HistoryData(
          category: 'Awards', duration: '2014', content: '제 9회 차세대 문화공간 건축상'),
      HistoryData(category: '', duration: '2015', content: '제 9회 차세대 문화공간 건축상'),
      HistoryData(
          category: '', duration: '2015', content: '제 24회 대한민국 건축대전 특선'),
      HistoryData(
          category: '', duration: '2015', content: '제 6회 교육시설 디자인 공모전 우수상'),
      HistoryData(category: '', duration: '2016', content: '건축문화대상 계획부문 우수상'),
      HistoryData(category: '', duration: '2016', content: '실내지다인학회 공모전 우수상'),
    ];
    */
  }

  // about 목록 가져오기
  Future<RequestProviderResult> requestAbout(BuildContext context) async {
    final requestProvider = context.read<RequestProvider>();

    final response = await requestProvider.getMethod('/api/about');
    if (response.statusCode != 200) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'status code ${response.statusCode}',
      );
    }

    final aboutPacket = response.getResponsePacket<packet.ResponseAbout>();
    if (aboutPacket == null) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'response packet is null',
      );
    }

    _aboutData = convertAboutData(requestProvider, aboutPacket);

    notifyListeners();

    return RequestProviderResult(isSuccess: true);
  }

  // about 내용 변경
  Future<RequestProviderResult> requestEditAbout(
    BuildContext context, {
    String? profileName,
    ImageState? profileImage,
    String? contact,
    String? introduceContent,
  }) async {
    packet.RequestSaveImage? requestSaveProfileImage;
    if (profileImage != null) {
      requestSaveProfileImage = convertRequestSaveIamge(profileImage);
    }

    final request = packet.RequestUpdateAbout(
      profileName: profileName,
      profileImage: requestSaveProfileImage,
      contact: contact,
      introduceContent: introduceContent,
    );

    final requestProvider = context.read<RequestProvider>();
    final responseData = await requestProvider.postMethod(
      '/api/about',
      request,
    );

    if (responseData.statusCode != 200) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'status code ${responseData.statusCode}',
      );
    }

    final responseAbout =
        responseData.getResponsePacket<packet.ResponseAbout>();
    if (responseAbout == null) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'response packet is null',
      );
    }

    final newAboutData = convertAboutData(requestProvider, responseAbout);

    _aboutData.profileName = newAboutData.profileName;
    _aboutData.profileImage = newAboutData.profileImage;
    _aboutData.contact = newAboutData.contact;
    _aboutData.introuceContent = newAboutData.introuceContent;

    notifyListeners();

    return RequestProviderResult(isSuccess: true);
  }

  // about 히스토리 변경
  Future<RequestProviderResult> requestEditAboutHistorires(
    BuildContext context, {
    List<int>? removeHistores,
    List<HistoryData>? addHistoires,
    List<HistoryData>? updateHistories,
  }) async {
    List<packet.RequesAboutHistoryElement>? requestAddHistories;
    List<packet.RequestUpdateAboutHistoryElement>? requestUpdateHistories;

    if (addHistoires != null) {
      requestAddHistories = [];
      for (var addHistory in addHistoires) {
        requestAddHistories.add(packet.RequesAboutHistoryElement(
          category: addHistory.category,
          duration: addHistory.duration,
          content: addHistory.content,
        ));
      }
    }

    if (updateHistories != null) {
      requestUpdateHistories = [];
      for (var updateHistory in updateHistories) {
        requestUpdateHistories.add(packet.RequestUpdateAboutHistoryElement(
          id: updateHistory.id,
          category: updateHistory.category,
          duration: updateHistory.duration,
          content: updateHistory.content,
        ));
      }
    }

    final request = packet.RequestUpdateAboutHistory(
      removeIds: removeHistores,
      appendHistories: requestAddHistories,
      updateHistories: requestUpdateHistories,
    );

    final requestProvider = context.read<RequestProvider>();
    final responseData =
        await requestProvider.postMethod('/api/about-history', request);
    if (responseData.statusCode != 200) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'status code ${responseData.statusCode}',
      );
    }

    final responseAbout =
        responseData.getResponsePacket<packet.ResponseAbout>();
    if (responseAbout == null) {
      return RequestProviderResult(
        isSuccess: false,
        error: 'response packet is null',
      );
    }

    final newAboutData = convertAboutData(requestProvider, responseAbout);
    _aboutData.historyList = newAboutData.historyList;

    notifyListeners();

    return RequestProviderResult(isSuccess: true);
  }
}
