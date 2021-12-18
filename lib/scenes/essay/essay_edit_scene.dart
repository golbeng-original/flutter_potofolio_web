import 'package:flutter/material.dart';
import 'package:flutter_portfolio_web/util/dialog_mixin.dart';

import 'package:provider/provider.dart';

import '/components/element_add_button.dart';
import '/components/radius_icon_button.dart';
import '/components/hover_essay_widget.dart';
import '/components/top_title.dart';

import '/providers/essay_provider.dart';
import '/providers/web_config.dart';

import '/util/dialog.dart';

class EssayEditScene extends StatefulWidget {
  const EssayEditScene({Key? key}) : super(key: key);

  @override
  _EssayEditSceneState createState() => _EssayEditSceneState();
}

class _EssayEditSceneState extends State<EssayEditScene> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      var essayProvider = context.read<EssayProvider>();
      await essayProvider.requestEssayList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var webConfig = context.read<WebConfig>();
    var essayProvder = context.watch<EssayProvider>();
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Column(
        children: [
          const TopTitleWidget(),
          Expanded(
            child: Container(
              margin: webConfig.warpMargin,
              width: mediaQuery.size.width,
              child: _createEssayWarpWidget(context, essayProvder),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createEssayWarpWidget(
    BuildContext context,
    EssayProvider essayProvider,
  ) {
    var editEssayList = List.generate(
      essayProvider.essayLength + 1,
      (index) {
        if (index == essayProvider.essayLength) {
          return _createAddPotofolioWidget(context);
        }
        return _createEssayWidget(context, essayProvider, index);
      },
    );

    return SingleChildScrollView(
      child: Wrap(
        spacing: 30,
        runSpacing: 30,
        children: editEssayList,
      ),
    );
  }

  Widget _createEssayWidget(
    BuildContext context,
    EssayProvider essayProvider,
    int index,
  ) {
    final essayData = essayProvider.getEssayDataFromIndex(index);

    return SizedBox(
      width: 200.0,
      height: 200.0,
      child: Stack(
        children: [
          HoverEssayWidget(
            width: 200.0,
            height: 200.0,
            essayTitle: essayData!.title,
            hoverImageUri: essayData.essayThumbnailImageUrl,
            editMode: true,
            onTab: () {
              _onPressEdit(context, essayData.id);
            },
          ),
          Positioned(
            top: 0,
            right: 0,
            child: RadiusIconButton(
              iconData: Icons.delete,
              tooltip: '제거',
              onPressed: () {
                _onPressDelete(context, essayData.id);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _createAddPotofolioWidget(BuildContext context) {
    return ElementAddButton(
      width: 200.0,
      height: 200.0,
      padding: const EdgeInsets.all(12),
      onPressed: () {
        _onPressAdd(context);
      },
    );
  }

  void _onPressDelete(
    BuildContext context,
    String essayId,
  ) {
    DialogUtil.showOkCancelDialog(
      context: context,
      title: '에세이 제거',
      content: '에세이를 제거 하시겠습니까?',
      onTabOk: () {
        _requestEssayDelete(context, essayId);
      },
    );
  }

  void _onPressAdd(
    BuildContext context,
  ) {
    DialogUtil.showOkCancelDialog(
      context: context,
      title: '에세이 추가',
      content: '에세이를 추가 하시겠습니까?',
      onTabOk: () {
        Navigator.pushNamed(
          context,
          '/new/essay/',
        );
      },
    );
  }

  void _onPressEdit(
    BuildContext context,
    String essayId,
  ) {
    DialogUtil.showOkCancelDialog(
      context: context,
      title: '에세이 편집',
      content: '에세이를 편집 하시겠습니까?',
      onTabOk: () {
        Navigator.pushNamed(
          context,
          '/edit/essay/$essayId',
        );
      },
    );
  }

  void _requestEssayDelete(BuildContext context, String id) async {
    final essayProvider = context.read<EssayProvider>();
    final result = await essayProvider.requestDeleteEssay(
      context,
      id: id,
    );
  }
}
