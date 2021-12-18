import 'package:flutter/material.dart';
import 'package:flutter_portfolio_web/providers/request_provider.dart';
import 'package:flutter_portfolio_web/util/route_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_portfolio_web/providers/authorize_provider.dart';
import '/core/noanimation_page_route.dart';
import '../scenes/potofolio/potofolio_scene.dart';

class TopTitleWidget extends StatelessWidget {
  const TopTitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 170,
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _createEditmode(context),
          _createMenu(context),
        ],
      ),
    );
  }

  Widget _createEditmode(BuildContext context) {
    final authroizeProvider = context.watch<AuthorizeProvider>();
    if (authroizeProvider.isAuthorized == false) {
      return Container();
    }

    final buttonTitle =
        authroizeProvider.isEditMode ? 'change normal mode' : 'edit mode';

    return Positioned(
        top: 4,
        child: Column(children: [
          ElevatedButton(
            child: Text(buttonTitle),
            onPressed: () {
              bool nextEditMode = !authroizeProvider.isEditMode;

              bool isSuccess = false;
              if (nextEditMode == true) {
                isSuccess = _onPressEditMode(context);
              } else {
                isSuccess = _onPressNormalMode(context);
              }

              if (isSuccess == true) {
                authroizeProvider.updateEditMode(
                  context,
                  editmode: nextEditMode,
                );
              }
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            child: const Text('Logout'),
            onPressed: () {
              _onPressLogout(context);
            },
          ),
        ]));
  }

  Widget _createMenu(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 44),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              _onPressMenu(context, RouteType.potofolio);
            },
            child: Text(
              'Cho Makers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.only(right: 44),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  _onPressMenu(context, RouteType.essay);
                },
                child: Text(
                  'Essay',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(
                width: 32,
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  _onPressMenu(context, RouteType.about);
                },
                child: Text(
                  'About',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _onPressMenu(BuildContext context, RouteType routeType) {
    final authrizeProvider = context.read<AuthorizeProvider>();

    final routeTrait = RouteTrait(
      routeType: routeType,
      isEdit: authrizeProvider.isEditMode,
    );

    Navigator.pushNamed(
      context,
      routeTrait.getRouteString(),
    );
  }

  bool _onPressEditMode(BuildContext context) {
    final modalRoute = ModalRoute.of(context);
    if (modalRoute == null) {
      return false;
    }

    final routeTrait =
        RouteHelper.parseRouteTraitFromRouteSettings(modalRoute.settings);
    if (routeTrait == null) {
      return false;
    }

    final editModeTrait = routeTrait.toEditModeTrait();

    Navigator.pushNamed(
      context,
      editModeTrait.getRouteString(),
    );

    return true;
  }

  bool _onPressNormalMode(BuildContext context) {
    final modalRoute = ModalRoute.of(context);
    if (modalRoute == null) {
      return false;
    }

    final routeTrait =
        RouteHelper.parseRouteTraitFromRouteSettings(modalRoute.settings);
    if (routeTrait == null) {
      return false;
    }

    final viewModeTrait = routeTrait.toViewModeTrait();

    Navigator.pushNamed(
      context,
      viewModeTrait.getRouteString(),
    );

    return true;
  }

  void _onPressLogout(BuildContext context) async {
    final modalRoute = ModalRoute.of(context);
    if (modalRoute == null) {
      return;
    }

    final routeTrait =
        RouteHelper.parseRouteTraitFromRouteSettings(modalRoute.settings);
    if (routeTrait == null) {
      return;
    }

    final requestProvider = context.read<RequestProvider>();
    await requestProvider.getMethod('/api/logout');

    final authroizeProvider = context.read<AuthorizeProvider>();
    authroizeProvider.onLogout();

    final viewModeTrait = routeTrait.toViewModeTrait();

    Navigator.pushNamed(
      context,
      viewModeTrait.getRouteString(),
    );
  }
}
