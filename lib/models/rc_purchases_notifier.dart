import 'dart:async';

import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/define/mg_handy.dart';
import 'package:chat_playground/define/rc_store_config.dart';
import 'package:chat_playground/models/firebase_notifier.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:purchases_flutter/purchases_flutter.dart';

// identifier "subscription1"
// subscriptionPeriod "P1W"
// "month1"
// "P1M"
// "month1 (com.studiomotorway.chat_playground (unreviewed))"

class ProductUIDesc {
  String title;
  String desc;
  String priceString;
  double price;
  ProductUIDesc(
      {this.title = 'null',
      this.desc = 'null',
      this.priceString = 'null',
      this.price = 10000});
}

class RCPurchasesNotifier extends ChangeNotifier {
  FirebaseNotifier firebaseNotifier;
  StoreState storeState = StoreState.loading;

  bool entitlementIsActive = false;
  String appUserID = '';

  bool isLogining = false;

  Offering? offeringCurrent;
  List<Package> productList = [];
  late CustomerInfo customerInfo;

  Map<String, ProductUIDesc> productDescs = <String, ProductUIDesc>{};

  RCPurchasesNotifier(this.firebaseNotifier) {
    mgLog('RCPurchasesNotifier notifier init.......');

    if (kIsWeb == false) {
      loadPurchases();
    }
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

      await loadOfferingCurrent();

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

  Future<bool> isEntitlementActive() async {
    customerInfo = await Purchases.getCustomerInfo();

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

  Future<Offering?> loadOfferingCurrent() async {
    // var isEntilementActive = await isEntitlementActive();
    // if (isEntilementActive == false) {
    Offerings offerings;
    try {
      offerings = await Purchases.getOfferings();
      offeringCurrent = offerings.current;

      //List<String> productIDs = ['subscription1', 'month1'];
      //List<StoreProduct> products = await Purchases.getProducts(productIDs);
      if (offeringCurrent == null) {
        mgLog("getOfferingCurrent null");
      } else {
        productList = offeringCurrent?.availablePackages ?? [];

        for (Package item in productList) {
          switch (item.storeProduct.identifier) {
            case 'subscription1':
              productDescs[item.storeProduct.identifier] = ProductUIDesc(
                  title: '주간',
                  desc: 'desc1',
                  priceString: item.storeProduct.priceString,
                  price: item.storeProduct.price);
              break;

            case 'month1':
              productDescs[item.storeProduct.identifier] = ProductUIDesc(
                  title: '월간',
                  desc: 'desc1',
                  priceString: item.storeProduct.priceString,
                  price: item.storeProduct.price);
              break;

            case 'year1':
              productDescs[item.storeProduct.identifier] = ProductUIDesc(
                  title: '연간',
                  desc: 'desc1',
                  priceString: item.storeProduct.priceString,
                  price: item.storeProduct.price);
              break;
          }
        }
      }

      return offeringCurrent;
    } catch (e) {
      mgLog("getOfferingCurrent error - $e");
      return null;
    }
    // } else {
    //   mgLog("getOfferingCurrent isEntilementActive - true");
    //   return null;
    // }
  }

  Offering? getOfferingCurrent() {
    return offeringCurrent;
  }

  Future<void> purchase(int index) async {
    try {
      // if (productList == null) {
      //   throw Exception("productList is null");
      // }
      customerInfo = await Purchases.purchasePackage(productList[index]);
    } catch (e) {
      mgLog("purchase error - $e");
    }
  }

  Future<void> purchasePackage(Package package) async {
    try {
      customerInfo = await Purchases.purchasePackage(package);
    } catch (e) {
      mgLog("purchase error - $e");
    }
  }
}
