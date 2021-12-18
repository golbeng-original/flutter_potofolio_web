import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class AboutContentWidget extends StatelessWidget {
  final String content;

  const AboutContentWidget({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String divWarp = '<div style="font-weight:300">$content</div>';
    return Html(
      data: divWarp,
    );
  }
}

class AboutEditController {
  String _content = '';
  final HtmlEditorController htmlEditController = HtmlEditorController();

  AboutEditController({
    String? initContent,
  }) {
    _content = initContent ?? '';
  }

  void dispose() {}

  Future<String> get content async {
    return await htmlEditController.getText();
  }

  String getRecordContent() {
    return _content;
  }

  Future<void> recordHtmlText() async {
    try {
      _content = await content;
    } catch (e) {
      print(e);
    }
  }
}

class AboutContentEditWidget extends StatelessWidget {
  final AboutEditController controller;

  const AboutContentEditWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: const BorderRadius.all(
              Radius.circular(6.0),
            ),
          ),
          child: HtmlEditor(
            controller: controller.htmlEditController,
            htmlEditorOptions: HtmlEditorOptions(
              hint: '자기 소개글 작성',
              shouldEnsureVisible: false,
              autoAdjustHeight: true,
              initialText: controller.getRecordContent(),
              //initialText: initalizeContent,
            ),
            htmlToolbarOptions: const HtmlToolbarOptions(
              toolbarPosition: ToolbarPosition.aboveEditor,
              defaultToolbarButtons: [
                FontSettingButtons(
                  fontName: false,
                  fontSizeUnit: false,
                ),
                FontButtons(
                  subscript: false,
                  superscript: false,
                  clearAll: false,
                ),
                ParagraphButtons(
                  lineHeight: false,
                  caseConverter: false,
                  increaseIndent: false,
                  decreaseIndent: false,
                  textDirection: false,
                ),
                ColorButtons(),
              ],
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(10, -6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: theme.scaffoldBackgroundColor,
            child: const Text(
              '자기 소개글',
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }
}
