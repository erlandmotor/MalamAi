import 'dart:async';

import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/define/mg_handy.dart';
import 'package:chat_playground/define/rc_store_config.dart';
import 'package:chat_playground/models/firebase_notifier.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:purchases_flutter/purchases_flutter.dart';

class RCPurchasesNotifier extends ChangeNotifier {
  FirebaseNotifier firebaseNotifier;
  StoreState storeState = StoreState.loading;

  bool entitlementIsActive = false;
  String appUserID = '';

  bool isLogining = false;

  Offering? offeringCurrent;
  List<Package>? productList;

  RCPurchasesNotifier(this.firebaseNotifier) {
    loadPurchases();
  }

  Future<void> loadPurchases() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;
    configuration = PurchasesConfiguration(RCStoreConfig.instance.apiKey)
      //..appUserID = firebaseNotifier.user?.uid
      ..appUserID = null
      ..observerMode = false;

    await Purchases.configure(configuration);

    appUserID = await Purchases.appUserID;

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      appUserID = await Purchases.appUserID;
      entitlementIsActive = await isEntitlementActive();
      mgLog(
          "login rc - success, appUserID - $appUserID, active - $entitlementIsActive");
      notifyListeners();
    });
  }

  Future<void> logIn() async {
    isLogining = true;
    notifyListeners();
    String? uid;
    try {
      await firebaseNotifier.login();
      uid = firebaseNotifier.user?.uid;

      if (uid != null) {
        await Purchases.logIn(uid);
        appUserID = await Purchases.appUserID;

        mgLog("login fb - success, appUserID - $appUserID");

        await loadPurchases();
      } else {
        throw Exception;
      }
    } on PlatformException catch (e) {
      // await showDialog(
      //     context: context,
      //     builder: (BuildContext context) => ShowDialogToDismiss(
      //         title: "Error", content: e.message, buttonText: 'OK'));
      mgLog("manage User error - $e");
    } catch (e) {
      mgLog("manage User error - $e");
    }

    isLogining = false;
    notifyListeners();
  }

  Future<void> logOut() async {
    isLogining = true;
    notifyListeners();

    try {
      await Purchases.logOut();
      appUserID = await Purchases.appUserID;
    } on PlatformException catch (e) {
      // await showDialog(
      //     context: context,
      //     builder: (BuildContext context) => ShowDialogToDismiss(
      //         title: "Error", content: e.message, buttonText: 'OK'));
      mgLog("manage User error - $e");
    }

    await firebaseNotifier.logout();

    isLogining = false;
    notifyListeners();
  }

  Future<void> restorePurchases() async {
    isLogining = true;
    notifyListeners();

    try {
      await Purchases.restorePurchases();
      appUserID = await Purchases.appUserID;
    } on PlatformException catch (e) {
      // await showDialog(
      //     context: context,
      //     builder: (BuildContext context) => ShowDialogToDismiss(
      //         title: "Error", content: e.message, buttonText: 'OK'));
      mgLog("manage User error - $e");
    }
    isLogining = false;
    notifyListeners();
  }

  Future<CustomerInfo> getCustomerInfo() async {
    return await Purchases.getCustomerInfo();
  }

  Future<bool> isEntitlementActive() async {
    var customerInfo = await getCustomerInfo();

    EntitlementInfo? entitlements =
        customerInfo.entitlements.all[entitlementID];
    if (entitlements != null && entitlements.isActive) {
      entitlementIsActive = true;
      return true;
    }
    entitlementIsActive = false;
    return false;
  }

  Future<Offerings?> getOfferings() async {
    var isEntilementActive = await isEntitlementActive();
    if (isEntilementActive == false) {
      Offerings offerings;
      try {
        offerings = await Purchases.getOfferings();
        return offerings;
      } catch (e) {
        // await showDialog(
        //     context: context,
        //     builder: (BuildContext context) => ShowDialogToDismiss(
        //         title: "Error", content: e.message, buttonText: 'OK'));
        mgLog("getOfferings error - $e");
        return null;
      }
    } else {
      mgLog("getOfferings isEntilementActive - true");
      return null;
    }
  }

  Future<Offering?> getOfferingCurrent() async {
    var isEntilementActive = await isEntitlementActive();
    if (isEntilementActive == false) {
      Offerings offerings;
      try {
        offerings = await Purchases.getOfferings();
        offeringCurrent = offerings.current;

        if (offeringCurrent == null) {
          mgLog("getOfferingCurrent null");
        } else {
          productList = offeringCurrent?.availablePackages;
        }

        return offeringCurrent;
      } catch (e) {
        // await showDialog(
        //     context: context,
        //     builder: (BuildContext context) => ShowDialogToDismiss(
        //         title: "Error", content: e.message, buttonText: 'OK'));
        mgLog("getOfferingCurrent error - $e");
        return null;
      }
    } else {
      mgLog("getOfferingCurrent isEntilementActive - true");
      return null;
    }
  }

  Future<void> purchase(int index) async {
    late CustomerInfo customInfo;
    try {
      if (productList == null) {
        throw Exception("productList is null");
      }
      CustomerInfo customInfo =
          await Purchases.purchasePackage(productList![index]);
    } catch (e) {
      mgLog("purchase error - $e");
    }
  }

  // Future<void> buy(PurchasableProduct product) async {
  //   // final purchaseParam = PurchaseParam(productDetails: product.productDetails);
  //   // switch (product.id) {
  //   //   case storeKeyConsumable:
  //   //     //await iapConnection.buyConsumable(purchaseParam: purchaseParam);
  //   //     break;
  //   //   case storeKeySubscription:
  //   //   case storeKeyUpgrade:
  //   //     //await iapConnection.buyNonConsumable(purchaseParam: purchaseParam);
  //   //     break;
  //   //   default:
  //   //     throw ArgumentError.value(
  //   //         product.productDetails, '${product.id} is not a known product');
  //   // }
  // }
}
