import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_portfolio_web/providers/authorize_provider.dart';
import 'package:flutter_portfolio_web/util/route_helper.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart' as crypto;

import '/providers/request_provider.dart';

import '/packet/packet.dart' as packet;

class LoginScene extends StatefulWidget {
  final String nextRouteUrl;

  const LoginScene({
    Key? key,
    required this.nextRouteUrl,
  }) : super(key: key);

  @override
  _LoginSceneState createState() => _LoginSceneState();
}

class _LoginSceneState extends State<LoginScene> {
  final TextEditingController _idEditinController = TextEditingController();
  final TextEditingController _passwordEditinController =
      TextEditingController();

  bool _isStatusError = false;

  bool _isIdEmpty = false;
  bool _isPasswordEmpty = false;

  bool _isIdError = false;
  bool _isPasswordError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _idEditinController.dispose();
    _passwordEditinController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _checkAuentication(context),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Container();
          }

          bool? isAuentication = snapshot.data as bool? ?? false;
          if (isAuentication) {
            return loginedWidget(context);
          }

          return notLoginWidget(context);
        });
  }

  Widget notLoginWidget(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: SizedBox(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        child: Center(
          child: Container(
            width: 320,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('관리자 모드 로그인'),
                const SizedBox(height: 16),
                TextField(
                  autofocus: false,
                  controller: _idEditinController,
                  decoration: InputDecoration(
                    labelText: 'ID',
                    errorText: _getIdErrorText(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  autofocus: false,
                  controller: _passwordEditinController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'PASSWORD',
                    errorText: getPasswordErrorText(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),
                _createLoginController(context),
                const SizedBox(height: 16),
                _createBackController(context, title: '취소'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginedWidget(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: SizedBox(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        child: Center(
          child: Container(
            width: 320,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('관리자 모드 로그인'),
                const Text('로그인 중입니다.'),
                const SizedBox(height: 32),
                _createLogoutController(context),
                const SizedBox(height: 16),
                _createBackController(context, title: '뒤로'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createLoginController(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _onPressLogin(context);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
      ),
      child: const Text('Login'),
    );
  }

  Widget _createLogoutController(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _onPressLogout(context);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
      ),
      child: const Text('Logout'),
    );
  }

  Widget _createBackController(
    BuildContext context, {
    required String title,
  }) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
      ),
      child: Text(title),
    );
  }

  String? _getIdErrorText() {
    if (_isIdEmpty) {
      return 'id를 입력해주세요.';
    }

    if (_isIdError) {
      return 'id가 틀렸습니다.';
    }

    if (_isStatusError) {
      return '서버 오류 입니다.';
    }

    return null;
  }

  String? getPasswordErrorText() {
    if (_isPasswordEmpty) {
      return 'pasword를 입력해주세요.';
    }

    if (_isPasswordError) {
      return 'password가 틀렸습니다.';
    }

    return null;
  }

  //
  Future<bool> _checkAuentication(BuildContext context) async {
    final requestProvider = context.read<RequestProvider>();
    final isAuentication = await requestProvider.checkAuentication(context);

    return isAuentication;
  }
  //

  void _onPressLogin(BuildContext context) async {
    _isStatusError = false;

    _isIdEmpty = false;
    _isPasswordEmpty = false;
    _isIdError = false;
    _isPasswordError = false;

    // id
    final id = _idEditinController.text;
    final password = _passwordEditinController.text;

    if (id.isEmpty || password.isEmpty) {
      setState(() {
        _isIdEmpty = id.isEmpty;
        _isPasswordEmpty = password.isEmpty;
      });
      return;
    }

    final bytes = utf8.encode(password);
    final md5Digest = crypto.md5.convert(bytes);

    final md5Password = md5Digest.toString();

    final requestProvider = context.read<RequestProvider>();

    final requestLogin = packet.RequestLogin(
      userName: id,
      password: md5Password,
    );

    final responseData =
        await requestProvider.postMethod('/api/login', requestLogin);
    if (responseData.statusCode != 200) {
      setState(() {
        _isStatusError = true;
      });
      return;
    }

    final responsePacket =
        responseData.getResponsePacket<packet.ResonseLogin>();

    if (responsePacket == null) {
      setState(() {
        _isStatusError = true;
      });
      return;
    }

    switch (responsePacket.loginResult) {
      case 1:
        setState(() {
          _isIdError = true;
        });
        return;
      case 2:
        setState(() {
          _isPasswordError = true;
        });
        return;
    }

    final authroizeProvider = context.read<AuthorizeProvider>();
    authroizeProvider.onLogin();

    var nextRouteUrl = '/';
    if (widget.nextRouteUrl.isNotEmpty) {
      nextRouteUrl = widget.nextRouteUrl;
    }

    final routeTrait = RouteHelper.parseRouteTraitFromString(nextRouteUrl);
    if (routeTrait != null) {
      nextRouteUrl = routeTrait.toEditModeTrait().getRouteString();
    }

    // 성공
    Navigator.pushNamed(
      context,
      nextRouteUrl,
    );
  }

  void _onPressLogout(BuildContext context) async {
    final requestProvider = context.read<RequestProvider>();

    final responseData = await requestProvider.getMethod('/api/logout');
    print(responseData.statusCode);

    final authroizeProvider = context.read<AuthorizeProvider>();
    authroizeProvider.onLogout();

    Navigator.pushNamed(
      context,
      '/',
    );
  }
}
