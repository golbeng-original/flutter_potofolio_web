import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'request_provider.dart';

class AuthorizeProvider extends ChangeNotifier {
  bool isAuthorized = false;
  bool isEditMode = false;

  void onLogin({
    bool editMode = true,
  }) {
    bool isDirty = false;

    if (isAuthorized == false) {
      isDirty = true;
    }

    if (isEditMode != editMode) {
      isDirty = true;
    }

    isAuthorized = true;
    isEditMode = editMode;

    if (isDirty == true) {
      notifyListeners();
    }
  }

  void onLogout() {
    bool isDirty = false;
    if (isAuthorized == true) {
      isDirty = true;
    }

    isAuthorized = false;
    isEditMode = false;

    if (isDirty == true) {
      notifyListeners();
    }
  }

  void updateEditMode(
    BuildContext context, {
    required bool editmode,
  }) async {
    bool isDirty = false;

    if (isAuthorized == false) {
      editmode = false;
    }

    // editmode == true 이면 auth 체크
    if (editmode == true) {
      final requestProvider = context.read<RequestProvider>();
      final isAuentication = await requestProvider.checkAuentication(context);
      if (isAuentication == false) {
        editmode = false;
      }
    }

    if (isEditMode != editmode) {
      isDirty = true;
    }

    isEditMode = editmode;

    // route 변경하기
    /*
    Navigator.pushReplacementNamed(
      context,
      '/edit/essay',
    );
    */

    if (isDirty == true) {
      notifyListeners();
    }
  }
}
