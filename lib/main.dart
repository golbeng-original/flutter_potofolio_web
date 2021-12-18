import 'package:flutter/material.dart';
import 'package:flutter_portfolio_web/scenes/about/about_edit_scene.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'core/noanimation_page_route.dart';
import 'providers/about_provider.dart';

import 'providers/authorize_provider.dart';
import 'scenes/about/about_scene.dart';
import 'scenes/essay/essay_edit_scene.dart';
import 'scenes/essay_detail/essay_detail_edit_scene.dart';
import 'scenes/essay_detail/essay_detail_scene.dart';
import 'scenes/essay/essay_scene.dart';
import 'scenes/login/login.dart';
import 'scenes/potofolio/potofolio_edit_scene.dart';
import 'scenes/potofolio_detail/potofolio_detail_edit_scene.dart';
import 'scenes/potofolio_detail/potofolio_detail_scene.dart';
import 'scenes/potofolio/potofolio_scene.dart';

import 'providers/essay_provider.dart';
import 'providers/potofolio_provider.dart';
import 'providers/request_provider.dart';
import 'providers/web_config.dart';

import 'util/route_helper.dart';

void main() {
  //setUrlStrategy(PathUrlStrategy());
  setPathUrlStrategy();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthorizeProvider()),
        Provider(create: (context) {
          var requestProvider = RequestProvider();
          //requestProvider.initalize();

          return requestProvider;
        }),
        ChangeNotifierProvider(create: (_) {
          var potofolioProvider = PotofolioProvider();

          // Test 코드 포함
          //potofolioProvider.initialize();

          return potofolioProvider;
        }),
        ChangeNotifierProvider(create: (_) {
          var essayProvider = EssayProvider();

          // Test 코드 포함
          //essayProvider.initialize();

          return essayProvider;
        }),
        ChangeNotifierProvider(create: (_) {
          var aboutProvider = AboutProvider();

          // Test 코드 포함
          //aboutProvider.initialize();

          return aboutProvider;
        }),
        Provider(create: (_) => WebConfig()),
      ],
      child: const PortfolioWebApp(),
      //child: TestZefyrkaApp(),
    ),
  );
}

class PortfolioWebApp extends StatelessWidget {
  const PortfolioWebApp({Key? key}) : super(key: key);

  Future<Widget> _findScene(
    BuildContext context,
    RouteSettings settings,
  ) async {
    final requestPovider = context.read<RequestProvider>();
    await requestPovider.initalize();

    final routeName = settings.name!;
    final argument = settings.arguments as String? ?? '';

    final routeTrait = RouteHelper.parseRouteTraitFromRouteSettings(settings);
    if (routeTrait == null) {
      return Container();
    }

    // 인증이 필요한 경우
    if (routeTrait.isNeedCheckAuthroize() == true) {
      // 인증 되어 있는가 체크
      if (await requestPovider.checkAuentication(context) == false) {
        Navigator.pushNamed(
          context,
          '/manager',
          arguments: routeName,
        );

        return Container();
      }
    }

    // 항목 수정
    if (routeTrait.isEditElement == true) {
      if (routeTrait.isEnable() == false) {
        return Container();
      }

      switch (routeTrait.routeType) {
        case RouteType.potofolio:
          return PotofolioDetailEditScene.editScene(id: routeTrait.id!);
        case RouteType.essay:
          return EssayDetailEditScene.editScene(id: routeTrait.id!);
        default:
          return Container();
      }
    }

    // 항목 추가
    if (routeTrait.isNew == true) {
      switch (routeTrait.routeType) {
        case RouteType.potofolio:
          return PotofolioDetailEditScene.newScene();
        case RouteType.essay:
          return EssayDetailEditScene.newScene();
        default:
          return Container();
      }
    }

    // 리스트 편집 및 최상위 편집
    if (routeTrait.isEdit == true) {
      switch (routeTrait.routeType) {
        case RouteType.potofolio:
          return const PotofolioEditScene();
        case RouteType.essay:
          return const EssayEditScene();
        case RouteType.about:
          return const AboutEditScene();
        default:
          return Container();
      }
    }

    // 보기
    if (routeTrait.isView == true) {
      switch (routeTrait.routeType) {
        case RouteType.potofolio:
          return const PotofolioScene();
        case RouteType.essay:
          return const EssayScene();
        case RouteType.about:
          return const AboutScene();
        case RouteType.manager:
          return LoginScene(
            nextRouteUrl: argument,
          );
        default:
          return Container();
      }
    }

    // 항목 보기
    if (routeTrait.isViewElement == true) {
      if (routeTrait.isEnable() == false) {
        return Container();
      }

      switch (routeTrait.routeType) {
        case RouteType.potofolio:
          return PotofolioDetailScene(id: routeTrait.id!);
        case RouteType.essay:
          return EssayDetailScene(id: routeTrait.id!);
        default:
          return Container();
      }
    }

    return Container();
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    return NoAnimationMaterialPageRoute(
      settings: settings,
      builder: (context) {
        return FutureBuilder(
          future: _findScene(context, settings),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return Container();
            }

            return snapshot.data as Widget? ?? Container();
          },
        );
      },
    );
  }

  Future<bool> _initaliseWeb(BuildContext context) async {
    var requestProvider = context.read<RequestProvider>();
    await requestProvider.initalize();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: _generateRoute,
      title: 'CHOMAKERS',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const PotofolioScene(),
    );
  }
}
