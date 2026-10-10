

import 'dart:io';

class Helper {
  static String get bannerUnitId{
    if(Platform.isAndroid){
      return 'ca-app-pub-3940256099942544/6300978111';
    }else{
      throw UnsupportedError('UnSupported Platform');
    }
  }
  static String get getInterstitialAdUnitId{
    if(Platform.isAndroid){
      return 'a-app-pub-3152663691471360/8558106276';
    }else{
      throw UnsupportedError('UnSupported Platform');
    }
  }
}