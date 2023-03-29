enum FirebaseState {
  loading,
  available,
  notAvailable,
}

enum StoreState {
  loading,
  available,
  notAvailable,
}

class GlobalDefine {
  //static bool USE_ADS = false;
  static const String routeNameRoot = '/';
  static const String routeChatPage = '/chat';
  static const String routeNameOption = '/option';

  static const String logoImage = 'assets/icons/robot5.png';
  static const String ver = "1.06.1";
  static const String cloudRegion = 'europe-west1';
  static const String storeKeyConsumable = 'dash_consumable_2k';
  static const String storeKeyUpgrade = 'dash_upgrade_3d';
  static const String storeKeySubscription = 'dash_subscription_doubler';
}
