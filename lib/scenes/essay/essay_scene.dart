import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/components/hover_essay_widget.dart';
import '/providers/essay_provider.dart';
import '/providers/web_config.dart';

import '/components/top_title.dart';

class EssayScene extends StatefulWidget {
  const EssayScene({Key? key}) : super(key: key);

  @override
  _EssaySceneState createState() => _EssaySceneState();
}

class _EssaySceneState extends State<EssayScene> {
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
                  spacing: 60,
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
    var essayProvder = context.watch<EssayProvider>();

    return List.generate(
      essayProvder.essayLength,
      (index) {
        final essayData = essayProvder.getEssayDataFromIndex(index);

        return HoverEssayWidget(
          width: 200.0,
          height: 200.0,
          essayTitle: essayData!.title,
          hoverImageUri: essayData.essayThumbnailImageUrl,
          onTab: () {
            Navigator.pushNamed(
              context,
              '/essay/${essayData.id}',
            );
          },
        );
      },
    );
  }
}
