// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'dart:io' show Platform;
//
// class AppOpenAdManager {
//
//   String adUnitId = Platform.isAndroid
//       ? 'ca-app-pub-3940256099942544/3419835294'
//       : 'ca-app-pub-3940256099942544/5662855259';
//
//   AppOpenAd? _appOpenAd;
//   bool _isShowingAd = false;
//
//   /// Maximum duration allowed between loading and showing the ad.
//   final Duration maxCacheDuration = Duration(hours: 4);
//
//   /// Keep track of load time so we don't show an expired ad.
//   DateTime? _appOpenLoadTime;
//
//   // /// Load an AppOpenAd.
//   // void loadAd() {
//   //   AppOpenAd.load(
//   //     adUnitId: adUnitId,
//   //     orientation: AppOpenAd.orientationPortrait,
//   //     request: AdRequest(),
//   //     adLoadCallback: AppOpenAdLoadCallback(
//   //       onAdLoaded: (ad) {
//   //         _appOpenAd = ad;
//   //       },
//   //       onAdFailedToLoad: (error) {
//   //         print('AppOpenAd failed to load: $error');
//   //         // Handle the error.
//   //       },
//   //     ),
//   //   );
//   // }
//   //
//   //  void showAdIfAvailable() {
//   //   if (!isAdAvailable) {
//   //     print('Tried to show ad before available.');
//   //     loadAd();
//   //     return;
//   //   }
//   //   if (_isShowingAd) {
//   //     print('Tried to show ad while already showing an ad.');
//   //     return;
//   //   }
//   //   // Set the fullScreenContentCallback and show the ad.
//   //   _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
//   //     onAdShowedFullScreenContent: (ad) {
//   //       _isShowingAd = true;
//   //       print('$ad onAdShowedFullScreenContent');
//   //     },
//   //     onAdFailedToShowFullScreenContent: (ad, error) {
//   //       print('$ad onAdFailedToShowFullScreenContent: $error');
//   //       _isShowingAd = false;
//   //       ad.dispose();
//   //       _appOpenAd = null;
//   //     },
//   //     onAdDismissedFullScreenContent: (ad) {
//   //       print('$ad onAdDismissedFullScreenContent');
//   //       _isShowingAd = false;
//   //       ad.dispose();
//   //       _appOpenAd = null;
//   //       loadAd();
//   //     },
//   //   );
//   // }
//
//   /// Load an AppOpenAd.
//   void loadAd() {
//     AppOpenAd.load(
//       adUnitId: adUnitId,
//       orientation: AppOpenAd.orientationPortrait,
//       request: AdRequest(),
//       adLoadCallback: AppOpenAdLoadCallback(
//         onAdLoaded: (ad) {
//           print('$ad loaded');
//           _appOpenLoadTime = DateTime.now();
//           _appOpenAd = ad;
//         },
//         onAdFailedToLoad: (error) {
//           print('AppOpenAd failed to load: $error');
//         },
//       ),
//     );
//   }
//
//   /// Shows the ad, if one exists and is not already being shown.
//   ///
//   /// If the previously cached ad has expired, this just loads and caches a
//   /// new ad.
//   void showAdIfAvailable() {
//     if (!isAdAvailable) {
//       print('Tried to show ad before available.');
//       loadAd();
//       return;
//     }
//     if (_isShowingAd) {
//       print('Tried to show ad while already showing an ad.');
//       return;
//     }
//     if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
//       print('Maximum cache duration exceeded. Loading another ad.');
//       _appOpenAd!.dispose();
//       _appOpenAd = null;
//       loadAd();
//       return;
//     }
//     // Set the fullScreenContentCallback and show the ad.
//     _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback();
//     _appOpenAd!.show();
//   }
//
//   /// Whether an ad is available to be shown.
//   bool get isAdAvailable {
//     return _appOpenAd != null;
//   }
// }


import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

class AppOpenAdManager {

  // String adUnitId = '/6499/example/app-open';
  String adUnitId = '/31989200/mk_punch_mobileapp';

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  /// Load an AppOpenAd.
  void loadAd() {
    AppOpenAd.loadWithAdManagerAdRequest(
      adUnitId: adUnitId,
      orientation: AppOpenAd.orientationPortrait,
      adManagerAdRequest: AdManagerAdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print('$ad loaded');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  /// Shows the ad, if one exists and is not already being shown.
  ///
  /// If the previously cached ad has expired, this just loads and caches a
  /// new ad.
  void showAdIfAvailable() {
    if (!isAdAvailable) {
      print('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      print('Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      print('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback();
    _appOpenAd!.show();
  }


}

