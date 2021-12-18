import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_portfolio_web/util/dialog_mixin.dart';

import '/providers/potofolio_provider.dart';

import '/components/edit_image_state_widget.dart';
import '/components/top_title.dart';
import '/components/edit_confirm_control_wdiget.dart';

import '/core/image_state.dart';

import '/util/dialog.dart';

class PotofolioDetailEditScene extends StatefulWidget {
  // id가 null이면 새로 생성 중인 화면
  final String? id;

  const PotofolioDetailEditScene._({
    Key? key,
    this.id,
  }) : super(key: key);

  factory PotofolioDetailEditScene.newScene({Key? key}) {
    return PotofolioDetailEditScene._(key: key);
  }

  factory PotofolioDetailEditScene.editScene({Key? key, required String id}) {
    return PotofolioDetailEditScene._(key: key, id: id);
  }

  @override
  _PotofolioDetailEditSceneState createState() =>
      _PotofolioDetailEditSceneState();
}

class _PotofolioDetailEditSceneState extends State<PotofolioDetailEditScene> {
  final TextEditingController _textEditingController = TextEditingController();

  PotofolioData? _prevPotofolioData;
  PotofolioData? _potofolioData;

  @override
  void initState() {
    super.initState();

    _textEditingController.addListener(() {
      _potofolioData?.title = _textEditingController.text;
    });

    if (widget.id == null) {
      _potofolioData = PotofolioData.empty();
    }
    //
    else {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {

        var potofolioProvder = context.read<PotofolioProvider>();
        final result = await potofolioProvder.requestPotofolioElement(
          context,
          id: widget.id!,
        );

        if (result.isSuccess == true) {
          _potofolioData = potofolioProvder.getPotofolioData(widget.id!);
          _prevPotofolioData = _potofolioData?.copy();

          _textEditingController.text = _potofolioData?.title ?? "";

          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TopTitleWidget(),
          _confirmControlls(),
          _createBody(),
        ],
      ),
    );
  }

  Widget _createBody() {
    if (_potofolioData == null) {
      return Expanded(
        child: Container(),
      );
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _createtitleEditWidget(),
            _createPotofolioWarpWidget(),
          ],
        ),
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

  Widget _createtitleEditWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextField(
        autofocus: false,
        controller: _textEditingController,
        decoration: const InputDecoration(
          labelText: '포토폴리오 제목',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _createPotofolioWarpWidget() {
    if (_potofolioData == null) {
      return Container();
    }

    return Wrap(
      children: List.generate(
        _potofolioData!.images.length + 1,
        (index) {
          if (index == _potofolioData!.images.length) {
            return _createAddButton(context, _potofolioData!);
          }

          return _createNormalPotofolioImage(
            context,
            _potofolioData!,
            index,
          );
        },
      ),
    );
  }

  Widget _createNormalPotofolioImage(
    BuildContext context,
    PotofolioData potofolioData,
    int imageIndexindex,
  ) {
    var imageState = potofolioData.images[imageIndexindex];

    return Container(
      margin: const EdgeInsets.all(32),
      width: 300.0,
      height: 300.0,
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
                  image: imageState.getImagePovider()),
            ),
          ),
          Center(
            child: EditImageStateWidget(
              imageState: imageState,
              onTabRemove: () {
                _onPressPotofolioRemove(
                    context, potofolioData, imageIndexindex);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _createAddButton(
    BuildContext context,
    PotofolioData potofolioData,
  ) {
    return Container(
      width: 300.0,
      height: 300.0,
      margin: const EdgeInsets.all(32),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.black,
        ),
        child: const Icon(
          Icons.add,
          size: 88,
          color: Colors.black,
        ),
        onPressed: () {
          _onPressPotofolioAdd(context, potofolioData);
        },
      ),
    );
  }

  void _onPressPotofolioRemove(
    BuildContext context,
    PotofolioData potofolioData,
    int imageIndexindex,
  ) {
    DialogUtil.showOkDialog(
      context: context,
      title: '포토폴리오 이미지 제거',
      content: '포토폴리오 이미지 제거를 제거하시겠습니까?',
      onTabOk: () {
        setState(() {
          potofolioData.images.removeAt(imageIndexindex);
        });
      },
    );
  }

  void _onPressPotofolioAdd(
    BuildContext context,
    PotofolioData potofolioData,
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

    potofolioData.images.add(
      ImageState.file(
        id: 0,
        fileName: filePick.name,
        bytes: filePick.bytes,
      ),
    );

    setState(() {});
  }

  void _onPressUpload(BuildContext context) {
    DialogUtil.showOkCancelDialog(
      context: context,
      title: '포토폴리오 업로드',
      content: '포토폴리오 업로드를 업로드 하시겠습니까?',
      onTabOk: () async {
        if (widget.id != null) {
          await _requestEditPotofolio(context, widget.id!);
        } else {
          await _requestCreatePotofolio(context);
        }

        Navigator.pushReplacementNamed(
          context,
          '/edit/potofolio',
        );
      },
    );
  }

  void _onPressCancel(BuildContext context) {
    DialogUtil.showOkCancelDialog(
      context: context,
      title: '포토폴리오 편집 취소',
      content: '포토폴리오 편집을 취소하겠습니까?',
      onTabOk: () {
        Navigator.pop(context);
      },
    );
  }

  Future<void> _requestCreatePotofolio(BuildContext context) async {
    if (_enableUpdate() == false) {
      return;
    }

    final potofolioProvider = context.read<PotofolioProvider>();
    final result = await potofolioProvider.requestNewPotofolio(
      context,
      title: _potofolioData!.title,
      imageStates: _potofolioData!.images,
    );
  }

  Future<void> _requestEditPotofolio(BuildContext context, String id) async {
    if (_enableUpdate() == false) {
      return;
    }

    if (_prevPotofolioData == null) {
      return;
    }

    String? editTitle;
    List<int> removeImageIds = [];
    List<ImageState> addImages = [];

    // title 변경 되었나?
    if (_prevPotofolioData!.title != _potofolioData!.title) {
      editTitle = _potofolioData!.title;
    }

    // 지워진 이미지 조사
    for (var prevImage in _prevPotofolioData!.images) {
      bool isExist = false;
      for (var editImage in _potofolioData!.images) {
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
    for (var editImage in _potofolioData!.images) {
      if (editImage.id == 0) {
        addImages.add(editImage);
      }
    }

    final potofolioProvider = context.read<PotofolioProvider>();
    final result = await potofolioProvider.requestEditPotofolio(
      context,
      id: id,
      title: editTitle,
      removeImageIds: removeImageIds.isNotEmpty ? removeImageIds : null,
      addImages: addImages.isNotEmpty ? addImages : null,
    );
  }

  bool _enableUpdate() {
    if (_potofolioData == null) {
      return false;
    }

    if (_potofolioData!.title.isEmpty) {
      DialogUtil.showOkCancelDialog(
        context: context,
        title: '경고',
        content: '제목이 없습니다.',
        onTabOk: () {
          Navigator.pop(context);
        },
      );
      return false;
    }

    if (_potofolioData!.images.isEmpty) {
      DialogUtil.showOkCancelDialog(
        context: context,
        title: '경고',
        content: '이미지가 없습니다.',
        onTabOk: () {
          Navigator.pop(context);
        },
      );
      return false;
    }

    return true;
  }
}
