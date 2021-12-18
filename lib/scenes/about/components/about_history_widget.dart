import 'package:flutter/material.dart';
import 'package:flutter_portfolio_web/util/dialog.dart';
import 'package:flutter_portfolio_web/util/dialog_mixin.dart';
import '/providers/about_provider.dart';

class AboutHistoryWidget extends StatelessWidget {
  final List<HistoryData> histroyList;
  const AboutHistoryWidget({
    Key? key,
    required this.histroyList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rows = histroyList.map((element) {
      return _createHistoryElementWidget(element);
    });

    return Container(
      alignment: Alignment.topRight,
      child: Column(
        children: rows.toList(),
      ),
    );
  }

  Widget _createHistoryElementWidget(HistoryData historyData) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 240,
        maxWidth: 480,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                historyData.category,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Expanded(
              child: Text(
                historyData.duration,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                historyData.content,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutHistoryEditCtrlContainer {
  final HistoryData targetHistoryData;
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController termController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  _AboutHistoryEditCtrlContainer({
    required this.targetHistoryData,
  }) {
    categoryController.text = targetHistoryData.category;
    categoryController.addListener(() {
      targetHistoryData.category = categoryController.text;
    });

    termController.text = targetHistoryData.duration;
    termController.addListener(() {
      targetHistoryData.duration = termController.text;
    });

    contentController.text = targetHistoryData.content;
    contentController.addListener(() {
      targetHistoryData.content = contentController.text;
    });
  }

  void dispose() {
    categoryController.dispose();
    termController.dispose();
    contentController.dispose();
  }
}

class AboutHistoryEditWidget extends StatefulWidget {
  final AboutData aboutData;
  
  const AboutHistoryEditWidget({
    Key? key,
    required this.aboutData,
  }) : super(key: key);

  @override
  _AboutHistoryEditWidgetState createState() => _AboutHistoryEditWidgetState();
}

class _AboutHistoryEditWidgetState extends State<AboutHistoryEditWidget> {
  List<_AboutHistoryEditCtrlContainer> _aboutHistoryEditCtrlList = [];

  @override
  void initState() {
    super.initState();

    _aboutHistoryEditCtrlList = widget.aboutData.historyList.map((element) {
      return _AboutHistoryEditCtrlContainer(
        targetHistoryData: element,
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var container in _aboutHistoryEditCtrlList) {
      container.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> elementRows = [];
    for (var i = 0; i < _aboutHistoryEditCtrlList.length; i++) {
      elementRows.add(
        _createHistoryElementWidget(
          i,
          _aboutHistoryEditCtrlList[i],
        ),
      );
    }

    List<Widget> rows = [
      _createHistryTopWidget(),
      ...elementRows,
      _createHistoryAddElement(),
    ];

    return Container(
      alignment: Alignment.topRight,
      child: Column(
        children: rows,
      ),
    );

    /*
    return Container(
      alignment: Alignment.topRight,
      child: Column(
        children: rows,
      ),
    );
    */
  }

  Widget _createHistryTopWidget() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 320,
        maxWidth: 580,
      ),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Expanded(
              child: Text(
                '카테고리',
              ),
            ),
            Expanded(
              child: Text(
                '기간',
              ),
            ),
            Expanded(
              child: Text(
                '내용',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createHistoryElementWidget(
    int index,
    _AboutHistoryEditCtrlContainer ctrlConatiner,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 320,
        maxWidth: 580,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _craeteHistryCell(ctrlConatiner.categoryController),
            const SizedBox(width: 4),
            _craeteHistryCell(ctrlConatiner.termController),
            const SizedBox(width: 4),
            _craeteHistryCell(ctrlConatiner.contentController),
            const SizedBox(width: 4),
            _createHistoryRemoveWidget(index),
          ],
        ),
      ),
    );
  }

  Widget _craeteHistryCell(TextEditingController controller) {
    return Expanded(
      child: TextField(
        autofocus: false,
        controller: controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _createHistoryRemoveWidget(int index) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            _onHistoryRemove(
              index,
            );
          },
          icon: const Icon(
            Icons.remove_circle,
            color: Colors.red,
          ),
        )
      ],
    );
  }

  Widget _createHistoryAddElement() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 320,
        maxWidth: 580,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(),
            IconButton(
              onPressed: _onHistoryAdd,
              icon: const Icon(
                Icons.add_circle,
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onHistoryAdd() {
    final historyData = HistoryData(id: 0);
    widget.aboutData.historyList.add(historyData);

    _aboutHistoryEditCtrlList.add(
      _AboutHistoryEditCtrlContainer(
        targetHistoryData: historyData,
      ),
    );

    setState(() {});
  }

  void _onHistoryRemove(int index) {
    if (index >= widget.aboutData.historyList.length) {
      return;
    }
    
    DialogUtil.showOkCancelDialog(
      context: context,
      title: '제거',
      content: '제거 하시겠습니까?',
      onTabOk: () {
        widget.aboutData.historyList.removeAt(index);
        _aboutHistoryEditCtrlList.removeAt(index);

        setState(() {});
      },
    );
  }
}
