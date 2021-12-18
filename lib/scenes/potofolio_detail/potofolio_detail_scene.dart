import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/top_title.dart';
import '/components/paginate_image_widget.dart';
import '/providers/potofolio_provider.dart';

class PotofolioDetailScene extends StatefulWidget {
  final String id;

  const PotofolioDetailScene({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _PotofolioDetailSceneState createState() => _PotofolioDetailSceneState();
}

class _PotofolioDetailSceneState extends State<PotofolioDetailScene> {
  bool _isResponse = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {

      var potofolioProvder = context.read<PotofolioProvider>();
      await potofolioProvder.requestPotofolioElement(context, id: widget.id);

      setState(() {
        _isResponse = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var potofolioProvider = context.read<PotofolioProvider>();
    var potofolioData = potofolioProvider.getPotofolioData(widget.id);

    return Scaffold(
      body: Column(
        children: [
          const TopTitleWidget(),
          _createBody(potofolioData),
        ],
      ),
    );
  }

  Widget _createBody(PotofolioData? potofolioData) {
    if (_isResponse == false) {
      return Expanded(
        child: Container(),
      );
    }

    if (potofolioData == null) {
      return Expanded(
        child: Container(),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: PaginateImageWidget(
          initalizePage: potofolioData.initDetailPotofolioIndex,
          images: potofolioData.images,
        ),
      ),
    );
  }
}
