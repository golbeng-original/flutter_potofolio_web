import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/about_provider.dart';

import '/components/top_title.dart';
import '/components/edit_confirm_control_wdiget.dart';
import '/core/image_state.dart';
import '/util/dialog.dart';

import './components/about_contant_widget.dart';
import './components/about_content_widget.dart';
import './components/about_history_widget.dart';
import './components/about_profile_image_widget.dart';
import './components/about_profile_name_widget.dart';

class AboutEditScene extends StatefulWidget {
  const AboutEditScene({
    Key? key,
  }) : super(key: key);

  @override
  _AboutEditSceneState createState() => _AboutEditSceneState();
}

class _AboutEditSceneState extends State<AboutEditScene> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _contantEditingController =
      TextEditingController();

  AboutEditController? _controller;

  AboutData? _prevAboutData;
  AboutData? _currentAboutData;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      var aboutProvider = context.read<AboutProvider>();

      final result = await aboutProvider.requestAbout(context);
      if (result.isSuccess == true) {
        _prevAboutData = aboutProvider.aboutData;
        _currentAboutData = _prevAboutData!.copy();

        _initalizeAboutData(_currentAboutData!);
      }
    });
  }

  void _initalizeAboutData(AboutData aboutData) {
    _nameEditingController.text = aboutData.profileName;
    _contantEditingController.text = aboutData.contact;

    _controller = AboutEditController(
      initContent: aboutData.introuceContent,
    );

    setState(() {});
  }

  @override
  void dispose() {
    _nameEditingController.dispose();
    _contantEditingController.dispose();
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget = Container();
    if (_controller != null) {
      bodyWidget = Expanded(
        child: SingleChildScrollView(
          child: _createLayout(context),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const TopTitleWidget(),
          _confirmControlls(),
          bodyWidget,
        ],
      ),
    );
  }

  Future<Widget> _recordHtmlEdit(AboutData aboutData) async {
    await _controller?.recordHtmlText();

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 764) {
          return _createMoblieSize(context, aboutData);
        } else {
          return _createNormalSize(context, aboutData);
        }
      },
    );
  }

  Widget _createLayout(BuildContext context) {
    if (_currentAboutData == null) {
      return Container();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return FutureBuilder(
          future: _recordHtmlEdit(_currentAboutData!),
          builder: (context, snapshot) {
            if (constraints.maxWidth <= 764) {
              return _createMoblieSize(context, _currentAboutData!);
            } else {
              return _createNormalSize(context, _currentAboutData!);
            }
          },
        );
      },
    );
  }

  Widget _createMoblieSize(BuildContext context, AboutData aboutData) {
    if (_controller == null) {
      return Container();
    }

    return Column(
      children: [
        AboutProfileImageEditWidget(
          profileImageState: aboutData.profileImage,
          onTabAdd: _onPressProfileImageAdd,
          onTabRemove: _onPressProfileIamgeRemove,
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AboutProfileNameEditWidget(
            editingController: _nameEditingController,
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AboutProfileContantEditWidget(
            editingController: _contantEditingController,
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AboutContentEditWidget(
            controller: _controller!,
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: AboutHistoryEditWidget(
            aboutData: aboutData,
          ),
        ),
      ],
    );
  }

  Widget _createNormalSize(BuildContext context, AboutData aboutData) {
    return Column(
      children: [
        _createTopRow(context, aboutData),
        _createBottomRow(aboutData),
      ],
    );
  }

  Widget _createTopRow(BuildContext context, AboutData aboutData) {
    if (_controller == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 80,
        vertical: 32,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AboutProfileImageEditWidget(
            profileImageState: aboutData.profileImage,
            onTabAdd: _onPressProfileImageAdd,
            onTabRemove: _onPressProfileIamgeRemove,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 32),
              child: AboutContentEditWidget(
                controller: _controller!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createBottomRow(AboutData aboutData) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 80,
        vertical: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 240,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: AboutProfileNameEditWidget(
                    editingController: _nameEditingController,
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: AboutProfileContantEditWidget(
                    editingController: _contantEditingController,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 32),
              child: AboutHistoryEditWidget(
                aboutData: aboutData,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _confirmControlls() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: EditConfirmControlWidget(
        onPressUpload: () {
          _onPressUpload();
        },
        onPressCancel: () {
          _requestAboutRollback();
        },
      ),
    );
  }

  void _onPressProfileImageAdd() async {
    if (_currentAboutData == null) {
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result == null) {
      return;
    }

    var filePick = result.files.first;
    if (filePick.bytes == null) {
      return;
    }

    _currentAboutData!.profileImage = ImageState.file(
      id: 0,
      fileName: filePick.name,
      bytes: filePick.bytes,
    );

    setState(() {});
  }

  void _onPressProfileIamgeRemove() {
    if (_currentAboutData == null) {
      return;
    }

    DialogUtil.showOkCancelDialog(
      context: context,
      title: '프로파일 이미지 제거',
      content: '프로파일 이미지 제거를 제거하시겠습니까?',
      onTabOk: () {
        setState(() {
          _currentAboutData!.profileImage = ImageState.none();
        });
      },
    );
  }

  void _onPressUpload() {
    DialogUtil.showOkCancelDialog(
      context: context,
      title: '자기소개 업로드',
      content: '자기소개 업로드 하시겠습니까?',
      onTabOk: () {
        _requestAbout();
      },
    );
  }

  void _onPressUploadCancel() {
    DialogUtil.showOkCancelDialog(
      context: context,
      title: '자기소개 업로드 취소',
      content: '자기소개 업로드 취소 하시겠습니까?',
      onTabOk: () {
        _requestAbout();
      },
    );
  }

  void _requestAbout() async {
    if (_currentAboutData == null || _prevAboutData == null) {
      return;
    }

    ImageState? profileImage;
    String? profileName;
    String? contact;
    String? introdueContent;

    // profile이미지 변경 되었나?
    if (_currentAboutData!.profileImage != _prevAboutData!.profileImage) {
      profileImage = _currentAboutData!.profileImage;
    }

    // profileName이 변경 되었나??
    final currentProfileName = _nameEditingController.text;
    if (currentProfileName != _prevAboutData!.profileName) {
      profileName = currentProfileName;
    }

    // Contact가 변경되었나?
    final currentContact = _contantEditingController.text;
    if (currentContact != _prevAboutData!.contact) {
      contact = currentContact;
    }

    // introdueContent가 변경되었나?
    final currentIntroduceContent = await _controller!.content;
    if (currentIntroduceContent != _prevAboutData!.contact) {
      introdueContent = currentIntroduceContent;
    }

    final aboutProvider = context.read<AboutProvider>();
    await aboutProvider.requestEditAbout(
      context,
      profileImage: profileImage,
      profileName: profileName,
      contact: contact,
      introduceContent: introdueContent,
    );

    // History
    List<int> removeHistories = [];
    List<HistoryData> addHistories = [];
    List<HistoryData> updateHistories = [];

    // 지워진 History 조사
    for (var prevHistories in _prevAboutData!.historyList) {
      bool isExist = false;
      for (var currHistories in _currentAboutData!.historyList) {
        if (prevHistories.id == currHistories.id) {
          isExist = true;
          break;
        }
      }

      if (isExist == false) {
        removeHistories.add(prevHistories.id);
      }
    }

    // 추가 된 History 조사
    for (var currHistories in _currentAboutData!.historyList) {
      if (currHistories.id == 0) {
        addHistories.add(currHistories);
      }
    }

    // 변경 된 History 조사
    for (var prevHistoryElement in _prevAboutData!.historyList) {
      for (var currHistoryElement in _currentAboutData!.historyList) {
        //
        if (prevHistoryElement.id == currHistoryElement.id) {
          if (prevHistoryElement.category != currHistoryElement.category ||
              prevHistoryElement.duration != currHistoryElement.duration ||
              prevHistoryElement.content != currHistoryElement.content) {
            updateHistories.add(currHistoryElement);
          }

          break;
        }
      }
    }

    await aboutProvider.requestEditAboutHistorires(
      context,
      addHistoires: addHistories.isNotEmpty ? addHistories : null,
      updateHistories: updateHistories.isNotEmpty ? updateHistories : null,
      removeHistores: removeHistories.isNotEmpty ? removeHistories : null,
    );

    setState(() {});
  }

  void _requestAboutRollback() async {
    if (_currentAboutData == null || _prevAboutData == null) {
      return;
    }

    _currentAboutData = _prevAboutData!.copy();

    setState(() {});
  }
}
