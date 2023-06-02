// import 'dart:io';
//
// class AdHelper {
//
//   static String get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-7167863529667065/4627662417';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-7167863529667065/1703233137';
//     }
//     throw new UnsupportedError("Unsupported platform");
//   }
//
//   static String get mediumAdUnitId {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-7167863529667065/6202382741';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-7167863529667065/7740849215';
//     }
//     throw new UnsupportedError("Unsupported platform");
//   }
//
//   static String get nativeAdUnitId {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-7167863529667065/1621406884';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-7167863529667065/6314725127';
//     }
//     throw new UnsupportedError("Unsupported platform");
//   }
// }



import 'dart:io';

class AdHelper {

  int numOfAttemptLoad = 0;


  static String get nativeHomeAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7167863529667065/1621406884';
      //  return 'ca-app-pub-3940256099942544/2247696110'; //test native ad
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7167863529667065/2421810980';

      // return 'ca-app-pub-3940256099942544/3986624511'; // test ad
    }
    throw  UnsupportedError("Unsupported platform");
  }


  static String get adManagerBannerUnitId {
    if (Platform.isAndroid) {
      return '/31989200/mk_punch_mobileapp';
      // return '/6499/example/banner';

    } else if (Platform.isIOS) {
      // return '/6499/example/banner';
      return '/31989200/mk_punch_mobileapp';
    }
    throw  UnsupportedError("Unsupported platform");
  }

  static String get articleMedium {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7167863529667065/7963339325';
      //  return 'ca-app-pub-3940256099942544/2247696110'; test native ad
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7167863529667065/1645777752';
    }
    throw new UnsupportedError("Unsupported platform");
  }

  static String get articleMedium2 {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7167863529667065/7963339325';
      //  return 'ca-app-pub-3940256099942544/2247696110'; test native ad
    } else if (Platform.isIOS) {
      return '  ca-app-pub-7167863529667065/5749801962';
    }
    throw new UnsupportedError("Unsupported platform");
  }

  static String get interstitialAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7167863529667065/3759929490';
      // return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }
    throw new UnsupportedError("Unsupported platform");
  }

  static String get homeBanner {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7167863529667065/1090906571';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7167863529667065/1810744262';

    }
    throw new UnsupportedError("Unsupported platform");
  }

  static String get homeBanner2 {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7167863529667065/9852885816';
      //  return 'ca-app-pub-3940256099942544/2247696110'; test native ad
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7167863529667065/4732421076';
    }
    throw new UnsupportedError("Unsupported platform");
  }

}