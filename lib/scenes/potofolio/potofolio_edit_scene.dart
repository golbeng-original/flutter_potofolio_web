import 'package:flutter/material.dart';
import 'package:flutter_portfolio_web/util/dialog_mixin.dart';

import 'package:provider/provider.dart';

import '/components/element_add_button.dart';
import '/components/hover_potofolio_widget.dart';
import '/components/top_title.dart';
import '/components/radius_icon_button.dart';

import '/providers/potofolio_provider.dart';
import '/providers/web_config.dart';

import '/util/dialog.dart';

class PotofolioEditScene extends StatefulWidget {
  const PotofolioEditScene({Key? key}) : super(key: key);

  @override
  _PotofolioEditSceneState createState() => _PotofolioEditSceneState();
}

class _PotofolioEditSceneState extends State<PotofolioEditScene> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {

      var potofolioProvder = context.read<PotofolioProvider>();
      await potofolioProvder.requestPotofolioList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var webConfig = context.read<WebConfig>();
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 120,
            color: Colors.blue,
            child: const TopTitleWidget(),
          ),
          Expanded(
            child: Container(
              margin: webConfig.warpMargin,
              width: mediaQuery.size.width,
              child: _createPotofolioWarpWidget(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createPotofolioWarpWidget(BuildContext context) {
    //
    return Builder(builder: (context) {
      //
      var potofolioProvder = context.watch<PotofolioProvider>();

      final editPotofolioList = List.generate(
        potofolioProvder.potofolioLength + 1,
        (index) {
          if (index == potofolioProvder.potofolioLength) {
            return ElementAddButton(
              width: 200.0,
              height: 200.0,
              padding: const EdgeInsets.all(12),
              onPressed: () {
                _onPressAdd(context);
              },
            );
          }

          return _createPotofolioWidget(context, potofolioProvder, index);
        },
      );

      return SingleChildScrollView(
        child: Wrap(
          spacing: 30,
          runSpacing: 30,
          children: editPotofolioList,
        ),
      );
    });
  }

  Widget _createPotofolioWidget(
    BuildContext context,
    PotofolioProvider potofolioProvder,
    int index,
  ) {
    final potofolioData = potofolioProvder.getPotofolioDataFromIndex(index)!;

    return SizedBox(
      width: 200.0,
      height: 200.0,
      child: Stack(
        children: [
          HoverPotofolioWidget(
            uniqueKey: PotofolioProvider.potofolioHeroKey(potofolioData.id),
            width: 200.0,
            height: 200.0,
            normalImage: potofolioData.normalImageState,
            hoverImage: potofolioData.hoverImageState,
            title: potofolioData.title,
            editMode: true,
            onTab: () {
              _onPressEdit(context, potofolioData.id);
            },
          ),
          Positioned(
            top: 0,
            right: 0,
            child: RadiusIconButton(
              iconData: Icons.delete,
              tooltip: '제거',
              onPressed: () {
                _onPressDelete(context, potofolioData.id);
              },
            ),
          )
        ],
      ),
    );
  }

  void _onPressDelete(
    BuildContext context,
    String potofolioId,
  ) {
    DialogUtil.showOkCancelDialog(
      context: context,
      title: '포토폴리오 제거',
      content: '포토폴리오를 제거 하시겠습니까?',
      onTabOk: () {
        _requestPotofolioDelete(context, potofolioId);
      },
    );
  }

  void _onPressAdd(
    BuildContext context,
  ) {
    DialogUtil.showOkCancelDialog(
      context: context,
      title: '포토폴리오 추가',
      content: '포토폴리오를 추가 하시겠습니까?',
      onTabOk: () {
        Navigator.pushNamed(
          context,
          '/new/potofolio',
        );
      },
    );
  }

  void _onPressEdit(
    BuildContext context,
    String potofolioId,
  ) {
    DialogUtil.showOkCancelDialog(
      context: context,
      title: '포토폴리오 편집',
      content: '포토폴리오를 편집 하시겠습니까?',
      onTabOk: () {
        Navigator.pushNamed(
          context,
          '/edit/potofolio/$potofolioId',
        );
      },
    );
  }

  void _requestPotofolioDelete(BuildContext context, String id) async {
    final potofolioProvider = context.read<PotofolioProvider>();
    final result = await potofolioProvider.requestDeletePotofolio(
      context,
      id: id,
    );
  }
}
