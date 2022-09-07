import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:punch_ios_android/model/responses/net_core_response.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/utility/colors.dart';



class SubscribeToNewsLetterProvider extends ChangeNotifier {
  late String message;
  bool loading = false;
  bool faved = false;
 late String email;
  bool isDialogOpen=false;
  late NetCoreResponse response;

  Repository repository = Repository();

   subscribe() async {
     setLoading(true);
     if(email.isNotEmpty){
     repository.subscribeToNewsLetter(email)
         .then((wow) {
           setResponse(wow);
           setLoading(false);
           setMessage(response.message);
           setDialogOpen(false);
           setEmail('');
     })
         .catchError((e) {
       setLoading(false);
       throw (e);
     });
     }else{
       setMessage("please enter a valid email");
     }
   }


  void setLoading(value) {
    loading = value;
    notifyListeners();
  }
  void setDialogOpen(value) {
    isDialogOpen = value;
    notifyListeners();
  }
  bool isLoading() {
    return loading;
  }

  void setMessage(value) {
    message = value;
    // Fluttertoast.showToast(
    //   msg: value,
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.TOP,
    //   timeInSecForIosWeb: 1,
    //   backgroundColor:  Colors.green,
    //   textColor: Colors.white,
    // );

    // Flushbar(
    //   duration: const Duration(seconds: 3),
    //   backgroundColor: mainColor,
    //   messageColor: whiteColor,
    //   // title: "This is simple flushbar",
    //   message: value,
    // );
    notifyListeners();
  }
   String? setEmail(String slug) {
  email = slug;
  }


  String getMessage() {
    return response.message;
  }

  void setResponse(value) {
    response = value;
    notifyListeners();
  }

}
