import 'package:flutter/material.dart';

class HoverEssayWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final String essayTitle;
  final String? hoverImageUri;
  final bool editMode;

  final VoidCallback? onTab;

  const HoverEssayWidget({
    Key? key,
    required this.essayTitle,
    this.hoverImageUri,
    this.width,
    this.height,
    this.onTab,
    this.editMode = false,
  }) : super(key: key);

  @override
  _HoverEssayWidgetState createState() => _HoverEssayWidgetState();
}

class _HoverEssayWidgetState extends State<HoverEssayWidget> {
  bool _isHover = false;

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
    if (widget.hoverImageUri != null) {
      _hoverImageProvider = NetworkImage(widget.hoverImageUri!);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadImage(),
      builder: (context, snapshot) {
        // progress view
        if (snapshot.hasData == false) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

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
          _getHorverImage(context),
          _getTitleWidget(context),
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
    if (_hoverImageProvider == null) {
      return 1.0;
    }

    if (_isHover == true) {
      return isNormalImage ? 0.0 : 1.0;
    }

    return isNormalImage ? 1.0 : 0.0;
  }

  Widget _getTitleWidget(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor = theme.scaffoldBackgroundColor;
    if (widget.editMode) {
      backgroundColor = Colors.grey;
    }

    return AnimatedOpacity(
      opacity: _getOpacity(true),
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        color: backgroundColor,
        child: Text(widget.essayTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            )),
      ),
    );
  }

  Widget _getHorverImage(BuildContext context) {
    if (widget.hoverImageUri == null) {
      return _getTitleWidget(context);
    }

    ColorFilter? colorFilter;
    if (widget.editMode) {
      colorFilter = const ColorFilter.mode(Colors.grey, BlendMode.multiply);
    }

    return AnimatedOpacity(
      opacity: _getOpacity(false),
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          //borderRadius: _getRaidus(),
          image: DecorationImage(
            image: _hoverImageProvider!,
            fit: BoxFit.fitHeight,
            colorFilter: colorFilter,
          ),
        ),
      ),
    );
  }
}
