//import 'package:flutter/foundation.dart';

enum RCStore { appleStore, googlePlay, amazonAppstore }

class RCStoreConfig {
  final RCStore store;
  final String apiKey;
  static late RCStoreConfig _instance;

  factory RCStoreConfig({required RCStore store, required String apiKey}) {
    //_instance ??= RCStoreConfig._internal(store, apiKey);
    _instance = RCStoreConfig._internal(store, apiKey);
    return _instance;
  }

  RCStoreConfig._internal(this.store, this.apiKey);

  static RCStoreConfig get instance {
    return _instance;
  }

  static bool isForAppleStore() => _instance.store == RCStore.appleStore;

  static bool isForGooglePlay() => _instance.store == RCStore.googlePlay;

  static bool isForAmazonAppstore() =>
      _instance.store == RCStore.amazonAppstore;
}
