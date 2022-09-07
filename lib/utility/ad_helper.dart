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
      // return 'ca-app-pub-7167863529667065/1621406884';
       return 'ca-app-pub-3940256099942544/2247696110'; //test native ad
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3986624511'; // test ad
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
    throw new UnsupportedError("Unsupported platform");
  }

}