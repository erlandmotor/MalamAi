import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MgAdWidget extends StatefulWidget {
  const MgAdWidget({Key? key}) : super(key: key);

  @override
  MgAdWidgetState createState() => MgAdWidgetState();
}

class MgAdWidgetState extends State<MgAdWidget> {
  BannerAd? _bannerAd;
  //NativeAd? _bannerAd2;

  final String _adUnitId =
      'ca-app-pub-1457387674173388/7156563927'; // metalgeni

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();

    super.dispose();
  }

  void _loadAd() async {
    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      //size: AdSize.largeBanner,
      //size: AdSize.mediumRectangle,

      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null) {
      return Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          child: SafeArea(
            child: SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              // width: 100,
              // height: 64,

              child: AdWidget(ad: _bannerAd!),
            ),
          ));
    } else {
      return Container(
        height: 50, // banner height
      );
    }
  }
}
