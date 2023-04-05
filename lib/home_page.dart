import 'package:flutter/material.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

class HomePage extends StatefulWidget {
  final String idfa;

  const HomePage({Key? key, this.idfa = ''}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;

  Widget _currentAd = const SizedBox(
    width: 0.0,
    height: 0.0,
  );

  @override
  void initState() {
    super.initState();
    FacebookAudienceNetwork.init(
      testingId: "a77955ee-3304-4635-be65-81029b0f5201",
      iOSAdvertiserTrackingEnabled: true,
    );
    _loadInterstitialAd();
    _loadRewardedVideoAd();
  }

  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED) {
          _isInterstitialAdLoaded = true;
        }

        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    );
  }

  void _loadRewardedVideoAd() {
    FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: "YOUR_PLACEMENT_ID",
      listener: (result, value) {
        print("Rewarded Ad: $result --> $value");
        if (result == RewardedVideoAdResult.LOADED) _isRewardedAdLoaded = true;
        if (result == RewardedVideoAdResult.VIDEO_COMPLETE &&
            result == RewardedVideoAdResult.VIDEO_CLOSED &&
            (value == true || value["invalidated"] == true)) {
          _isRewardedAdLoaded = false;
          _loadRewardedVideoAd();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Facebook ads")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: Align(
              alignment: const Alignment(0, -1.0),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _getAllButtons(),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 3,
            child: Align(
              alignment: const Alignment(0, 1.0),
              child: _currentAd,
            ),
          )
        ],
      ),
    );
  }

  Widget _getAllButtons() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 3,
      children: <Widget>[
        _getRaisedButton(title: "Banner Ad", onPressed: _showBannerAd),
        _getRaisedButton(
            title: "Intestitial Ad",
            onPressed: () {
              _showInterstitialAd();
            }),
        _getRaisedButton(title: "Rewarded Ad", onPressed: _showRewardedAd),
      ],
    );
  }

  Widget _getRaisedButton({required String title, void Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  _showInterstitialAd() {
    if (_isInterstitialAdLoaded == true) {
      FacebookInterstitialAd.showInterstitialAd();
    } else {
      print("Interstial Ad not yet loaded!");
    }
  }

  _showRewardedAd() {
    if (_isRewardedAdLoaded == true) {
      FacebookRewardedVideoAd.showRewardedVideoAd();
    } else {
      print("Rewarded Ad not yet loaded!");
    }
  }

  _showBannerAd() {
    setState(() {
      _currentAd = FacebookBannerAd(
        // placementId: "YOUR_PLACEMENT_ID",
        placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047",
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          print("Banner Ad: $result -->  $value");
        },
      );
    });
  }
}
