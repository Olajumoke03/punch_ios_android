import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:punch_ios_android/privacy_policy/privacy_model.dart';
import 'package:punch_ios_android/privacy_policy/privacy_policy_bloc.dart';
import 'package:punch_ios_android/privacy_policy/privacy_policy_event.dart';
import 'package:punch_ios_android/privacy_policy/privacy_policy_state.dart';
import 'package:punch_ios_android/utility/colors.dart';
import 'package:punch_ios_android/utility/font_controller.dart';

class PrivacyScreen extends StatefulWidget {

  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  late PrivacyPolicyBloc privacyBloc;
  late FontSizeController _fontSizeController;


  @override
  void initState() {
    super.initState();
    _fontSizeController = Provider.of<FontSizeController>(context, listen: false);

    privacyBloc = BlocProvider.of<PrivacyPolicyBloc>(context);
    privacyBloc.add(FetchPrivacyPolicyEvent());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        appBar: AppBar (
        centerTitle: true ,
          leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyText1!.color,)
          ),
          title: Image.asset ( 'assets/punchLogo.png' , width: 100 , height: 40 ) ,
        actions: [
//          IconButton(
//              icon: Icon(Icons.refresh,size: 30,color: Colors.grey[400],),
//              padding: EdgeInsets.all(5),
//              onPressed: () async{
//                await FlutterFundingChoices.showConsentForm();
//                await refreshConsentInfo();
//                },
//
//            )
        ],
      ),

      body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                BlocListener<PrivacyPolicyBloc, PrivacyPolicyState>(
                  listener: (context, state){
                    if ( state is  PrivacyPolicyLoadedState  != null ) {
                      // a message will only come when it is updating the feed.
                      // Scaffold.of ( context ).showSnackBar ( SnackBar ( content: Text ( "Category List Updated" ) , ) );
                    }
                    else if ( state is  PrivacyPolicyLoadFailureState ) {
                      // Scaffold.of ( context ).showSnackBar ( SnackBar (
                      //   content: Text ( "Could not load data at this time" ) , ) );
                    }
                  },
                  child: BlocBuilder< PrivacyPolicyBloc,  PrivacyPolicyState>(
                    builder: (context, state) {
                      if ( state is  PrivacyPolicyInitialState ) {
                        return buildLoading ( );
                      } else if ( state is  PrivacyPolicyLoadingState ) {
                        return buildLoading ( );
                      } else if ( state is  PrivacyPolicyLoadedState ) {
                        return buildPrivacyPolicy ( state. privacyPolicy);
                      } else if ( state is  PrivacyPolicyLoadFailureState ) {
                        return buildErrorUi ( state.error );
                      }
                      else {
                        return buildErrorUi ( "Something went wrong!" );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget  buildPrivacyPolicy ( PrivacyPolicyModel  privacyPolicyModel){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child:  Column(
        children: [
          Text(
            "${ privacyPolicyModel.title!.rendered.toString()}",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7*_fontSizeController.value, color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),

         Html(
           data: "${ privacyPolicyModel.content!.rendered}" ,
            style: {
              "body": Style(
                  fontSize:  FontSize(6*_fontSizeController.value),
                  fontWeight: FontWeight.w400,
                  color:Theme.of(context).textTheme.bodyText1!.color,
                backgroundColor: Theme.of ( context ).backgroundColor
              ),
            },
          )
        ],
      ),
    );

  }


  Widget buildLoading ( ) {
    return Container(
      margin: EdgeInsets.only(top:50),
      child: Center (
        child: CircularProgressIndicator ( color: mainColor, ) ,
      ),
    );
  }

  Widget buildErrorUi ( String message ) {
    return Center (
      child: Text ( message , style: TextStyle ( color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20 ) ,
      ) ,
    );
  }




}



