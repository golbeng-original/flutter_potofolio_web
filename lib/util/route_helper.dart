import 'package:flutter/material.dart';

enum RouteType {
  none,
  potofolio,
  essay,
  about,
  manager,
}

class RouteTrait {
  final bool isNew;
  final bool isEditElement;
  final bool isEdit;
  final bool isView;
  final bool isViewElement;
  final RouteType routeType;
  final String? id;

  RouteTrait({
    this.isEditElement = false,
    this.isEdit = false,
    this.isNew = false,
    this.isView = false,
    this.isViewElement = false,
    required this.routeType,
    this.id,
  });

  bool isEnable() {
    if (isEditElement == true || isViewElement == true) {
      if (id == null || id!.isEmpty == true) {
        return false;
      }
    }

    return true;
  }

  bool isNeedCheckAuthroize() {
    if (isEditElement == true || isEdit == true || isNew == true) {
      return true;
    }

    return false;
  }

  RouteTrait toViewModeTrait() {
    if (isEditElement == true) {
      return RouteTrait(
        routeType: routeType,
        isViewElement: true,
        id: id,
      );
    }

    return RouteTrait(
      routeType: routeType,
      id: id,
    );
  }

  RouteTrait toEditModeTrait() {
    if (isViewElement == true) {
      return RouteTrait(
        routeType: routeType,
        isEditElement: true,
        id: id,
      );
    }

    return RouteTrait(
      isEdit: true,
      routeType: routeType,
      id: id,
    );
  }

  String getRouteString() {
    String route = '/';

    if (isEdit || isEditElement) {
      route += 'edit/';
    } else if (isNew) {
      route += 'new/';
    }

    switch (routeType) {
      case RouteType.potofolio:
        route += 'potofolio/';
        break;
      case RouteType.essay:
        route += 'essay/';
        break;
      case RouteType.about:
        route += 'about/';
        break;
      case RouteType.manager:
        route += 'manager/';
        break;
      default:
        break;
    }

    if (isEditElement || isViewElement) {
      route += '$id';
    }

    if (route != '/' && route[route.length - 1] == '/') {
      route = route.substring(0, route.length - 1);
    }

    return route;
  }
}

class RouteHelper {
  static RouteType _partRouteType(String routeStr) {
    switch (routeStr.toLowerCase()) {
      case 'potofolio':
        return RouteType.potofolio;
      case 'essay':
        return RouteType.essay;
      case 'about':
        return RouteType.about;
      case 'manager':
        return RouteType.manager;
      default:
        return RouteType.none;
    }
  }

  static RouteTrait? parseRouteTraitFromRouteSettings(RouteSettings settings) {
    return parseRouteTraitFromString(settings.name ?? '/');
  }

  static RouteTrait? parseRouteTraitFromString(String url) {
    final routeName = url;

    if (routeName == '/') {
      return RouteTrait(routeType: RouteType.potofolio);
    }

    // edit potofolio list, edit essay list, edit about
    final _editRouteWithIdRefex =
        RegExp(r'/edit/(?<routed>[^\s/\/]+)/(?<id>[0-9]+)/?');
    var matched = _editRouteWithIdRefex.firstMatch(routeName);
    if (matched != null) {
      final route = matched.namedGroup('routed') ?? '';
      final id = matched.namedGroup('id') ?? '';

      return RouteTrait(
        routeType: _partRouteType(route),
        isEditElement: true,
        id: id,
      );
    }

    // edit potofolio list, edit essay list, edit about
    final _editRouteRegex = RegExp(r'/edit/(?<routed>[^\s/\/]+)/?');
    matched = _editRouteRegex.firstMatch(routeName);
    if (matched != null) {
      final route = matched.namedGroup('routed') ?? '';
      return RouteTrait(
        routeType: _partRouteType(route),
        isEdit: true,
      );
    }

    // add potofolio, add essay
    final _newRouteWithIdRefex = RegExp(r'/new/(?<routed>[^\s/\/]+)/?');
    matched = _newRouteWithIdRefex.firstMatch(routeName);
    if (matched != null) {
      final route = matched.namedGroup('routed') ?? '';
      return RouteTrait(
        routeType: _partRouteType(route),
        isNew: true,
      );
    }

    // view potofolio default, essay default
    final _routeWithIdRegex = RegExp(r'/(?<routed>[^\s/\/]+)/(?<id>[0-9]+)/?');
    matched = _routeWithIdRegex.firstMatch(routeName);
    if (matched != null) {
      final route = matched.namedGroup('routed') ?? '';
      final id = matched.namedGroup('id') ?? '';

      return RouteTrait(
        routeType: _partRouteType(route),
        isViewElement: true,
        id: id,
      );
    }

    // view potofolio list, essay list, about
    final _routeRegex = RegExp(r'/(?<routed>[^\s/\/]+)/?');
    matched = _routeRegex.firstMatch(routeName);
    if (matched != null) {
      final route = matched.namedGroup('routed') ?? '';
      return RouteTrait(
        routeType: _partRouteType(route),
        isView: true,
      );
    }

    return null;
  }
}
