import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import 'package:zefyrka/zefyrka.dart';

import '/util/dialog.dart';

import '/core/image_state.dart';

import '/components/top_title.dart';
import '/components/edit_confirm_control_wdiget.dart';
import '/components/edit_image_state_widget.dart';
import '/components/header_title_widget.dart';
import '/components/element_add_button.dart';

import '/providers/essay_provider.dart';

class EssayDetailEditScene extends StatefulWidget {
  final String? id;

  const EssayDetailEditScene._({
    Key? key,
    this.id,
  }) : super(key: key);

  factory EssayDetailEditScene.newScene({Key? key}) {
    return EssayDetailEditScene._(
      key: key,
    );
  }

  factory EssayDetailEditScene.editScene({
    Key? key,
    required String id,
  }) {
    return EssayDetailEditScene._(
      key: key,
      id: id,
    );
  }

  @override
  _EssayDetailEditSceneState createState() => _EssayDetailEditSceneState();
}

class _EssayDetailEditSceneState extends State<EssayDetailEditScene> {
  final TextEditingController _textEditingController = TextEditingController();

  ZefyrController? _zefyrController;

  EssayData? _prevEssayData;
  EssayData? _essayData;

  @override
  void initState() {
    super.initState();

    _textEditingController.addListener(() {
      _essayData?.title = _textEditingController.text;
    });

    if (widget.id == null) {
      _essayData = EssayData.empty();
      _initZefryController("");
    }
    //
    else {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
        var essayProvider = context.read<EssayProvider>();
        final result = await essayProvider.requestEssayElement(
          context,
          id: widget.id!,
        );

        if (result.isSuccess == true) {
          _essayData = essayProvider.getEssayData(widget.id!);
          _prevEssayData = _essayData?.copy();

          _textEditingController.text = _essayData?.title ?? "";

          _initZefryController(_essayData?.essayText ?? "");
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();

    _zefyrController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TopTitleWidget(),
          _confirmControlls(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _createEssayTitleEditWidget(),
                  const HeaderTitleWidget(headerTitle: 'essay 썸네일'),
                  _createEssayThumbnailEditWidget(context),
                  const HeaderTitleWidget(headerTitle: 'essay 이미지'),
                  _createEssayWarpWidget(),
                  const HeaderTitleWidget(headerTitle: 'essay 글 편집'),
                  Container(
                    height: 800,
                    padding:
                        const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                    child: _createEssayContextEditWidget(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _confirmControlls() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: EditConfirmControlWidget(
        onPressUpload: () {
          _onPressUpload(context);
        },
        onPressCancel: () {
          _onPressCancel(context);
        },
      ),
    );
  }

  Widget _createEssayTitleEditWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextField(
        autofocus: false,
        controller: _textEditingController,
        maxLines: 5,
        decoration: const InputDecoration(
          labelText: '에세이 제목',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _createEssayThumbnailEditWidget(BuildContext context) {
    if (_essayData == null) {
      return Container();
    }

    var imageState = _essayData!.essayThumnailImage;

    if (imageState.isEmpty) {
      return ElementAddButton(
        width: 300.0,
        height: 300.0,
        margin: const EdgeInsets.all(32),
        onPressed: () {
          _onPressEassyThumbnailImageAdd(context, _essayData!);
        },
      );
    }

    return _createNormalEssayImage(
      context,
      imageState,
      onPressRemove: () {
        _onPressEssayThumbnailImageRemove(context, _essayData!);
      },
    );
  }

  Widget _createEssayWarpWidget() {
    if (_essayData == null) {
      return Container();
    }

    return Wrap(
      children: List.generate(
        _essayData!.images.length + 1,
        (index) {
          if (index == _essayData!.images.length) {
            return ElementAddButton(
              width: 300.0,
              height: 300.0,
              margin: const EdgeInsets.all(32),
              onPressed: () {
                _onPressEssayImageAdd(context, _essayData!);
              },
            );
          }

          var imageState = _essayData!.images[index];

          return _createNormalEssayImage(
            context,
            imageState,
            onPressRemove: () {
              _onPressEssayImageRemove(context, _essayData!, index);
            },
          );
        },
      ),
    );
  }

  Widget _createEssayContextEditWidget() {
    if (_essayData == null) {
      return Container();
    }

    if (_zefyrController == null) {
      return Container();
    }

    return Column(
      children: [
        ZefyrToolbar.basic(controller: _zefyrController!),
        Expanded(
          child: Container(
            color: Colors.white,
            child: ZefyrEditor(
              controller: _zefyrController!,
              autofocus: true,
            ),
          ),
        ),
      ],
    );

    /*
    return HtmlEditor(
      controller: _essayContentEdigincontroller,
      htmlEditorOptions: HtmlEditorOptions(
        hint: 'Essay 글 작성',
        shouldEnsureVisible: true,
        initialText: _essayData!.essayText,
      ),
      htmlToolbarOptions: const HtmlToolbarOptions(
        toolbarPosition: ToolbarPosition.aboveEditor,
        defaultToolbarButtons: [
          StyleButtons(),
          FontSettingButtons(),
          FontButtons(),
          ColorButtons(),
        ],
      ),
      otherOptions: const OtherOptions(height: 640),
    );
    */
  }

  Widget _createNormalEssayImage(
    BuildContext context,
    ImageState imageState, {
    VoidCallback? onPressRemove,
  }) {
    return Container(
      width: 300.0,
      height: 300.0,
      margin: const EdgeInsets.all(32),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.multiply,
                ),
                image: imageState.getImagePovider(),
              ),
            ),
          ),
          Center(
            child: EditImageStateWidget(
              imageState: imageState,
              onTabRemove: onPressRemove,
            ),
          )
        ],
      ),
    );
  }

  void _initZefryController(String content) {
    if (content.isEmpty == true) {
      _zefyrController = ZefyrController();
      return;
    }

    var document = NotusDocument.fromJson(jsonDecode(content));
    _zefyrController = ZefyrController(document);
  }

  String _getZefryDocuemnt() {
    if (_zefyrController == null) {
      return '';
    }

    final content = jsonEncode(_zefyrController!.document);
    return content;
  }

  void _onPressEssayImageRemove(
    BuildContext context,
    EssayData essayData,
    int imageIndexindex,
  ) {
    DialogUtil.showOkCancelDialog(
      context: context,
      title: '에세이 이미지 제거',
      content: '에세이 이미지 제거를 제거하시겠습니까?',
      onTabOk: () {
        setState(() {
          essayData.images.removeAt(imageIndexindex);
        });
      },
    );
  }

  void _onPressEssayThumbnailImageRemove(
    BuildContext context,
    EssayData essayData,
  ) {
    DialogUtil.showOkCancelDialog(
      context: context,
      title: '에세이 썸네일 제거',
      content: '에세이 썸네일 제거를 제거하시겠습니까?',
      onTabOk: () {
        setState(() {
          essayData.essayThumnailImage = ImageState.none();
        });
      },
    );
  }

  void _onPressEssayImageAdd(
    BuildContext context,
    EssayData essayData,
  ) async {
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

    essayData.images.add(
      ImageState.file(
        id: 0,
        fileName: filePick.name,
        bytes: filePick.bytes,
      ),
    );

    setState(() {});
  }

  void _onPressEassyThumbnailImageAdd(
    BuildContext context,
    EssayData essayData,
  ) async {
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

    essayData.essayThumnailImage = ImageState.file(
      id: 0,
      fileName: filePick.name,
      bytes: filePick.bytes,
    );

    setState(() {});
  }

  void _onPressUpload(BuildContext context) {
    DialogUtil.showOkCancelDialog(
      context: context,
      title: '에세이 업로드',
      content: '에세이를 업로드 하시겠습니까?',
      onTabOk: () async {
        bool isSuccess = false;
        if (widget.id != null) {
          isSuccess = await _requestEditEssay(context, widget.id!);
        } else {
          isSuccess = await _requestCreateEssay(context);
        }

        if (isSuccess == false) {
          return;
        }

        Navigator.pushReplacementNamed(
          context,
          '/edit/essay',
        );
      },
    );
  }

  void _onPressCancel(BuildContext context) {
    DialogUtil.showOkCancelDialog(
      context: context,
      title: '에세이 편집 취소',
      content: '에세이 편집을 취소하겠습니까?',
      onTabOk: () {
        Navigator.pop(context);
      },
    );
  }

  Future<bool> _requestCreateEssay(BuildContext context) async {
    if (_enableUpdate() == false) {
      return false;
    }

    final newEssayContent = _getZefryDocuemnt();

    final essayProvider = context.read<EssayProvider>();
    final result = await essayProvider.requestNewEssay(
      context,
      title: _essayData!.title,
      thumbnailImageState: _essayData!.essayThumnailImage,
      imageStates: _essayData!.images,
      essayContent: newEssayContent,
    );

    return true;
  }

  Future<bool> _requestEditEssay(BuildContext context, String id) async {
    if (_enableUpdate() == false) {
      return false;
    }

    if (_prevEssayData == null) {
      return false;
    }

    String? editTitle;
    ImageState? thumbnailImage;
    List<int> removeImageIds = [];
    List<ImageState> addImages = [];
    String? editEssayContent;

    // title 변경 되었나?
    if (_prevEssayData!.title != _essayData!.title) {
      editTitle = _essayData!.title;
    }

    // 썸네일이 변경 되었나??
    if (_essayData!.essayThumnailImage.isLocal &&
        _essayData!.essayThumnailImage.id == 0) {
      thumbnailImage = _essayData!.essayThumnailImage;
    }

    // 지워진 이미지 조사
    for (var prevImage in _prevEssayData!.images) {
      bool isExist = false;
      for (var editImage in _essayData!.images) {
        if (prevImage.id == editImage.id) {
          isExist = true;
          break;
        }
      }

      if (isExist == false) {
        removeImageIds.add(prevImage.id);
      }
    }

    // 추가 된 이미지 조사
    for (var editImage in _essayData!.images) {
      if (editImage.id == 0) {
        addImages.add(editImage);
      }
    }

    // essayContent 변경 되었나?
    final newEssayContent = _getZefryDocuemnt();
    if (_essayData!.essayText != newEssayContent) {
      editEssayContent = newEssayContent;
    }

    final essayProvider = context.read<EssayProvider>();
    final result = await essayProvider.requestEditEssay(
      context,
      id: id,
      title: editTitle,
      thumbnailImage: thumbnailImage,
      removeImageIds: removeImageIds.isNotEmpty ? removeImageIds : null,
      addImages: addImages.isNotEmpty ? addImages : null,
      essayContent: editEssayContent,
    );

    return true;
  }

  bool _enableUpdate() {
    if (_essayData == null) {
      return false;
    }

    if (_essayData!.title.isEmpty) {
      DialogUtil.showOkDialog(
        context: context,
        title: '경고',
        content: '제목이 없습니다.',
        onTabOk: () {
          Navigator.pop(context);
        },
      );
      return false;
    }

    if (_essayData!.essayThumnailImage.isEmpty) {
      DialogUtil.showOkDialog(
        context: context,
        title: '경고',
        content: '썸네일 이미지가 없습니다.',
        onTabOk: () {
          Navigator.pop(context);
        },
      );
      return false;
    }

    if (_essayData!.images.isEmpty) {
      DialogUtil.showOkDialog(
        context: context,
        title: '경고',
        content: '본문 이미지가 없습니다.',
        onTabOk: () {
          Navigator.pop(context);
        },
      );
      return false;
    }

    return true;
  }
}
