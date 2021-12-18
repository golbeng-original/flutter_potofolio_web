import 'package:flutter/material.dart';
import 'package:flutter_portfolio_web/providers/potofolio_provider.dart';
import 'package:flutter_portfolio_web/providers/web_config.dart';
import 'package:provider/provider.dart';
import '../../components/hover_potofolio_widget.dart';

import '/components/top_title.dart';

class PotofolioScene extends StatefulWidget {
  const PotofolioScene({Key? key}) : super(key: key);

  @override
  _PotofolioSceneState createState() => _PotofolioSceneState();
}

class _PotofolioSceneState extends State<PotofolioScene> {
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
    var webConfig = Provider.of<WebConfig>(context);
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Column(
        children: [
          const TopTitleWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: webConfig.warpMargin,
                width: mediaQuery.size.width,
                alignment: mediaQuery.size.width < 430
                    ? Alignment.topCenter
                    : Alignment.topLeft,
                child: Wrap(
                  spacing: 30,
                  runSpacing: 30,
                  children: _makeChild(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _makeChild(BuildContext context) {
    var potofolioProvder = context.watch<PotofolioProvider>();

    return List.generate(
      potofolioProvder.potofolioLength,
      (index) {
        final potofolioData =
            potofolioProvder.getPotofolioDataFromIndex(index)!;

        return HoverPotofolioWidget(
          uniqueKey: PotofolioProvider.potofolioHeroKey(potofolioData.id),
          width: 200.0,
          height: 200.0,
          normalImage: potofolioData.normalImageState,
          hoverImage: potofolioData.hoverImageState,
          title: potofolioData.title,
          onTab: () {
            Navigator.pushNamed(
              context,
              '/potofolio/${potofolioData.id}',
            );
          },
        );
      },
    );
  }
}
