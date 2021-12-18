import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:zefyrka/zefyrka.dart';

import '/components/top_title.dart';
import '/components/paginate_image_widget.dart';
import '/providers/essay_provider.dart';

class EssayDetailScene extends StatefulWidget {
  final String id;

  const EssayDetailScene({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _EssayDetailSceneState createState() => _EssayDetailSceneState();
}

class _EssayDetailSceneState extends State<EssayDetailScene> {
  bool _isResponse = false;

  ZefyrController? _zefyrController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      var essayProvider = context.read<EssayProvider>();
      await essayProvider.requestEssayElement(context, id: widget.id);

      var essayData = essayProvider.getEssayData(widget.id);
      _initZefryController(essayData?.essayText ?? "");

      setState(() {
        _isResponse = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var essayProvider = context.read<EssayProvider>();
    var essayData = essayProvider.getEssayData(widget.id);

    return Scaffold(
      body: Column(
        children: [
          const TopTitleWidget(),
          _createBody(essayData),
        ],
      ),
    );
  }

  Widget _createBody(EssayData? essayData) {
    if (_isResponse == false) {
      return Expanded(
        child: Container(),
      );
    }

    if (essayData == null) {
      return Expanded(
        child: Container(),
      );
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 32,
                horizontal: 32,
              ),
              child: PaginateImageWidget(
                initalizePage: 0,
                images: essayData.images,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: _createEssayContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createEssayContent() {
    if (_zefyrController == null) {
      return Container();
    }

    return ZefyrEditor(
      controller: _zefyrController!,
      autofocus: true,
      readOnly: true,
      showCursor: false,
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
}
