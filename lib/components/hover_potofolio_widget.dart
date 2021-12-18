import 'package:flutter/material.dart';
import '/core/image_state.dart';

class HoverPotofolioWidget extends StatefulWidget {
  final String uniqueKey;
  final double? width;
  final double? height;
  final ImageState normalImage;
  final ImageState? hoverImage;
  final String title;
  final bool editMode;

  final VoidCallback? onTab;

  const HoverPotofolioWidget({
    Key? key,
    required this.uniqueKey,
    required this.normalImage,
    required this.title,
    this.hoverImage,
    this.width,
    this.height,
    this.onTab,
    this.editMode = false,
  }) : super(key: key);

  @override
  _HoverPotofolioWidgetState createState() => _HoverPotofolioWidgetState();
}

class _HoverPotofolioWidgetState extends State<HoverPotofolioWidget> {
  bool _isHover = false;

  late ImageProvider _normalImageProvider;
  ImageProvider? _hoverImageProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _loadImage() async {
    _normalImageProvider = widget.normalImage.getImagePovider();

    if (widget.hoverImage != null) {
      _hoverImageProvider = widget.hoverImage!.getImagePovider();
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadImage(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        //
        return MouseRegion(
          onEnter: (event) {
            setState(() {
              _isHover = true;
            });
          },
          onExit: (event) {
            setState(() {
              _isHover = false;
            });
          },
          child: GestureDetector(
            onTap: widget.onTab,
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: _animateBody(),
            ),
          ),
        );
      },
    );
  }

  Widget _animateBody() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      padding: _getPadding(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _getImageConatiner(false),
          _getImageConatiner(true),
          Positioned(
            bottom: 8,
            child: AnimatedOpacity(
              opacity: _getOpacity(false),
              duration: const Duration(milliseconds: 100),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(3.0),
                  ),
                ),
                child: Text(
                  widget.title,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  EdgeInsets _getPadding() {
    if (_isHover == true) {
      return const EdgeInsets.all(0.0);
    }

    return const EdgeInsets.all(15.0);
  }

  BorderRadiusGeometry _getRaidus() {
    if (_isHover == true) {
      return const BorderRadius.all(
        Radius.circular(0.0),
      );
    }

    return const BorderRadius.all(
      Radius.circular(40.0),
    );
  }

  double _getOpacity(bool isNormalImage) {
    if (_isHover == true) {
      return isNormalImage ? 0.0 : 1.0;
    }

    return isNormalImage ? 1.0 : 0.0;
  }

  Widget _getImageConatiner(bool isNormalImage) {
    ImageProvider? targetImageProvider;
    if (isNormalImage == false) {
      targetImageProvider = _hoverImageProvider;
    }

    targetImageProvider ??= _normalImageProvider;

    ColorFilter? colorFilter;
    if (widget.editMode) {
      colorFilter = const ColorFilter.mode(Colors.grey, BlendMode.multiply);
    }

    BoxDecoration? decoration;
    if (targetImageProvider != null) {
      decoration = BoxDecoration(
        //borderRadius: _getRaidus(),

        image: DecorationImage(
          image: targetImageProvider,
          fit: BoxFit.fitHeight,
          colorFilter: colorFilter,
        ),
      );
    }

    final contentWidget = AnimatedOpacity(
      opacity: _getOpacity(isNormalImage),
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: Container(
        decoration: decoration,
      ),
    );

    return contentWidget;
  }
}
