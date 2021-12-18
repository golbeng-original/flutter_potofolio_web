import 'package:flutter/material.dart';
import 'package:flutter_portfolio_web/core/image_state.dart';

class PaginateImageWidget extends StatefulWidget {
  final int initalizePage;
  final List<ImageState> images;

  const PaginateImageWidget({
    Key? key,
    required this.images,
    this.initalizePage = 0,
  }) : super(key: key);

  @override
  _PaginateImageWidgetState createState() => _PaginateImageWidgetState();
}

class _PaginateImageWidgetState extends State<PaginateImageWidget>
    with TickerProviderStateMixin {
  late int _currentPage;
  late List<Animation<Offset>> _positions;
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();

    _currentPage = widget.initalizePage;

    _controllers = List.generate(
      widget.images.length,
      (index) {
        final controller = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
          lowerBound: 0,
          upperBound: 1,
          value: _getControllerValue(index),
        );

        return controller;
      },
    );

    _positions = _controllers.map((controller) {
      return Tween(
        begin: const Offset(-1, 0),
        end: const Offset(1, 0),
      ).animate(controller);
    }).toList();
  }

  @override
  void dispose() {
    for (var element in _controllers) {
      element.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      /*
      borderRadius: const BorderRadius.all(
        Radius.circular(20.0),
      ),
      */
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: [
          ..._makePage(),
          ..._makePageButtons(),
        ],
      ),
    );
  }

  List<Widget> _makePage() {
    final List<Widget> pages = [];

    for (var i = 0; i < widget.images.length; i++) {
      pages.add(
        SlideTransition(
          position: _positions[i],
          child: AspectRatio(
            aspectRatio: 1.33,
            child: Container(
              decoration: BoxDecoration(
                /*
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
                */
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: widget.images[i].getImagePovider(),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return pages;
  }

  List<Widget> _makePageButtons() {
    if (_controllers.length < 2) {
      return [Container()];
    }

    return [
      Positioned(
        left: 5,
        child: GestureDetector(
          onTap: () {
            _incrementPage();
          },
          child: Container(
            padding: const EdgeInsets.only(left: 14),
            child: const Icon(
              Icons.arrow_back_ios,
              size: 60,
            ),
          ),
        ),
      ),
      Positioned(
        right: 5,
        child: GestureDetector(
          onTap: () {
            _decrementPage();
          },
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 60,
          ),
        ),
      ),
    ];
  }

  double _getControllerValue(int index) {
    if (_currentPage == index) {
      return 0.5;
    }

    return _currentPage < index ? 0.0 : 1.0;
  }

  void _incrementPage() {
    final curr = _currentPage;
    _currentPage++;

    if (_currentPage >= _controllers.length) {
      _currentPage = 0;
    }

    final next = _currentPage;

    _controllers[curr].animateTo(1.0);

    _controllers[next].value = 0.0;
    _controllers[next].animateTo(0.5);
  }

  void _decrementPage() {
    final curr = _currentPage;
    _currentPage--;

    if (_currentPage < 0) {
      _currentPage = _controllers.length - 1;
    }

    final next = _currentPage;

    _controllers[curr].animateTo(0);

    _controllers[next].value = 1.0;
    _controllers[next].animateTo(0.5);
  }
}
