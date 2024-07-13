import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loan_admin_app/constants/app_constants.dart';
import 'package:loan_admin_app/helper/api/api_client_http.dart';
import 'package:loan_admin_app/shared-preference-manager/preference-manager.dart';

class WalletManagementProvider with ChangeNotifier {
  var _loanList;
  var _depositwalletlist;

  var _wallet;

  get depositwalletlist => _depositwalletlist;
  get wallet => _wallet;

  Future<void> getWallet() async {
    var sharedPref = SharedPreferencesManager();

    var user = jsonDecode(await sharedPref.getString(AppConstants.user));

    var res = await ApiClientHttp(
            headers: <String, String>{'Content-type': 'application/json'})
        .getRequest("${AppConstants.getWalletUrl}?id=${user['id']}");

    if (res == null) {
      print("Res Null :: $res");
    } else {
      var body = res;
      _wallet = body['data'];
      // var sharedPref = SharedPreferencesManager();
      sharedPref.saveString(AppConstants.wallet, json.encode(body['data']));
      print("BODY-WALLET saved:: ${AppConstants.wallet}");
      // print("BODY-WALLET USer:: ${wallet}");

      print("BODY-WALLET :: ${json.encode(body['data'])}}");
      // print("BODY-WALLET decode:: ${json.encode(body['data'])}");

      notifyListeners();
    }
  }

  Future<bool> getWalletDepositList() async {
    try {
      var sharedPref = SharedPreferencesManager();
      var user = jsonDecode(await sharedPref.getString(AppConstants.user));
      var wallet = jsonDecode(await sharedPref.getString(AppConstants.wallet));

      var res = await ApiClientHttp(headers: <String, String>{
        'Content-Type': 'application/json',
      }).getRequest("${AppConstants.getWalletDepositUrl}?id=${user['id']}&q=a");
      print("res :: $res");
      if (res == null) {
        print("RES NULL :: $res");
        return false;
      } else {
        var body = res;
        if (body["error"] == false) {
          _depositwalletlist = body['data'];
          print("BODY OF DEPOSIT LIST :: ${depositwalletlist}");

          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
