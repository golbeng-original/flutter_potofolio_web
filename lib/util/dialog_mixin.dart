import 'package:flutter/material.dart';

class DialogMixin<T extends State> {
  bool _showDialog = false;

  String _title = '';
  String _content = '';

  VoidCallback? onTabOk;
  VoidCallback? onTabCancel;

  State? _state;

  void registerDialogState(State state) {
    _state = state;
  }

  Widget dialogWithWidget(
    BuildContext context, {
    required Widget body,
  }) {
    List<Widget> _children = [body];
    if (_showDialog == true) {
      _children.add(
        _createDialog(context),
      );
    }

    return Stack(
      children: _children,
    );
  }

  Widget _createDialog(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (_showDialog == false) {
      return Container();
    }

    List<Widget> buttonWidgets = [];
    buttonWidgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          onPressed: () {
            _closeDialog();
            this.onTabOk?.call();
          },
          child: const Text('확인'),
        ),
      ),
    );

    if (onTabCancel != null) {
      buttonWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton(
            onPressed: () {
              _closeDialog();
              this.onTabCancel?.call();
            },
            child: const Text('취소'),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        _closeDialog();
      },
      child: Container(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        color: Colors.black.withOpacity(0.7),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _content,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: buttonWidgets,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDialog({
    required String title,
    required String content,
    required VoidCallback? onTabOk,
    VoidCallback? onTabCancel,
  }) {
    this.onTabOk = onTabOk;
    this.onTabCancel = onTabCancel;

    _state?.setState(() {
      _title = title;
      _content = content;
      _showDialog = true;
    });
  }

  void _closeDialog() {
    _state?.setState(() {
      _showDialog = false;
    });
  }
}
