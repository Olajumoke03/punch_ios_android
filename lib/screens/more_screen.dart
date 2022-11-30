import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:punch_ios_android/about_us/about_screen.dart';
import 'package:punch_ios_android/about_us/about_us_bloc.dart';
import 'package:punch_ios_android/about_us/contact_us.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/screens/font_test.dart';
import 'package:punch_ios_android/screens/home_page.dart';
import 'package:punch_ios_android/utility/app_provider.dart';
import 'package:punch_ios_android/utility/constants.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:punch_ios_android/utility/shared_pref.dart';
import 'package:punch_ios_android/utility/subcribe_to_newsletter_provider.dart';
import 'package:punch_ios_android/widgets/custom_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  late SharedPref sharedPref = SharedPref();
 late String _name;
  late String isLogin;
  late String _profile;
  late SubscribeToNewsLetterProvider _subscribeProvider;

  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _subscribeProvider = Provider.of<SubscribeToNewsLetterProvider>(context, listen: false);
  }
  _MoreScreenState() {
    loadSharedPrefs();
  }

  subscribeDialog(BuildContext context,bool isSubscribing) {
    _subscribeProvider.setDialogOpen(true);

    if(_subscribeProvider.isDialogOpen==true) {
      showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        child:   Consumer<SubscribeToNewsLetterProvider>(
            builder: ( context,  deepProvider, child) {
              return Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text( Constants.appName, style: const TextStyle( fontWeight: FontWeight.bold, fontSize: 18,
                    )),
                    SizedBox(height: 10),
                    Visibility(
                      visible:!_subscribeProvider.isDialogOpen,
                      child: const Text( "Subscription Successful.",
                        style: TextStyle( fontWeight: FontWeight.w500, fontSize: 16,
                        ),
                      ),
                    ),
                    Visibility(
                      visible:_subscribeProvider.isDialogOpen,
                      child: Text( "Subscribe to our newsletter",
                        style: TextStyle( fontWeight: FontWeight.w500, fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Visibility(
                      visible:_subscribeProvider.isDialogOpen,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5, top: 5, bottom: 5, left: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),

                          ),
                          child: Padding(
                            padding: const EdgeInsets.only( left: 15, right: 15, top: 3, bottom: 3),
                            child: TextField(
                              autofocus: true,
//                          controller: emailController,
                              onChanged: (String txt) {
                                _subscribeProvider.setEmail(txt);
                              },
                              style: TextStyle( fontSize: 15,

                              ),
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter your email here',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Visibility(
                      visible:_subscribeProvider.isDialogOpen,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left:5),
                              height: 40,
                              child: OutlinedButton(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(5.0),
                                // ),
                                // borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                                child: Text( "  Close  ", style: TextStyle( color: Theme.of(context).primaryColor, fontSize: 16,
                                ),
                                ),
                                onPressed: ()=>Navigator.pop(context),
                                // color: Colors.white,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left:5),
                              height: 40,
                              child: OutlinedButton(
                                      onPressed: () {
                                      debugPrint('Received click');
                                         },
                                      child: Text('Subscribe', style: TextStyle(color: Theme.of(context).primaryColor),),
                                      ),

                              // RaisedButton(
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(5.0),
                              //   ),
                              //   child:_subscribeProvider.loading==true ? const SizedBox(
                              //     height: 16,
                              //     width: 16,
                              //     child: Center ( child: CircularProgressIndicator ( strokeWidth: 2,
                              //         valueColor:  AlwaysStoppedAnimation<Color>(Colors.white)
                              //     ) ,
                              //     ),
                              //   ): const Text( "Subscribe",
                              //     style: TextStyle( color: Colors.white, fontSize: 16,
                              //     ),
                              //   ),
                              //   onPressed: (){
                              //     // _subscribeProvider.setEmail(emailController.text);
                              //     _subscribeProvider.subscribe();
                              //   },
                              //   color: Theme.of(context).colorScheme.secondary,
                              // ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Visibility(
                      visible:!_subscribeProvider.isDialogOpen,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left:5),
                              height: 40,
                              child: OutlinedButton(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(5.0),
                                // ),
                                // borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                                child: Text( "  Close  ", style: TextStyle( color: Theme.of(context).colorScheme.secondary, fontSize: 16,
                                ),
                                ),
                                onPressed: ()=>Navigator.pop(context),
                                // color: Colors.white,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );}
        ),
      ),
    );
    }
  }

  fontDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        child:   ChangeTextSizeWithSeekBar()
      ),
    );
  }

  loadSharedPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        isLogin = (prefs.getString("isLogin") == null
            ? "0"
            : prefs.getString("isLogin"))!;
        _name = (prefs.getString("name") == null
            ? "Please LogIn"
            : prefs.getString("name"))!;
        _profile = (prefs.getString("profile") == null
            ? null
            : prefs.getString("profile"))!;
      });
    } catch (e) {}
  }



  // _launchhURL() async {
  //   const url = 'https://punchng.com/advertise-with-us';
  //   if (await canLaunch(url)) {
  //     await launch(
  //       url,
  //       forceSafariVC: false,
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // launchAdvertise(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url, forceWebView: true);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }


  List items = [

    {
      "icon": Icons.notification_important_outlined,
      "title": "Notifications",
    },

    {
      SvgPicture: SvgPicture.asset( 'assets/icons/about.svg', height: 35.0, width: 35.0),
      "title": "AboutUs",
      // "page": BlocProvider<AboutUsBloc>(
      //     create: (context) => AboutUsBloc(aboutUsRepository: NewsRepository()),
      //     child: AboutScreen()
      // ),
    },

    {
      SvgPicture: SvgPicture.asset( 'assets/icons/contact.svg', height: 35.0, width: 35.0, ),
      "title": "Contact Us",
      // "page": BlocProvider<AboutUsBloc>(
      //     create: (context) => AboutUsBloc(aboutUsRepository: NewsRepository()),
      //     child: ContactUs()
      // ),
    },

    {
      SvgPicture: SvgPicture.asset( 'assets/icons/privacy.svg', height: 35.0, width: 35.0, ),
      "title": "Privacy Policy",
      // "page": BlocProvider<PrivacyPolicyBloc>(
      //     create: (context) => PrivacyPolicyBloc(privacyPolicyRepository: NewsRepository()),
      //     child: PrivacyScreen()
      // ),
    },

    {
      SvgPicture: SvgPicture.asset( 'assets/icons/advertise.svg', height: 35.0, width: 35.0),
      "title": "Advertise with us",
      // "page": "https://punchng.com/advertise-with-us/",
    },

    {
      SvgPicture: SvgPicture.asset( 'assets/icons/rate.svg', height: 35.0, width: 35.0),
      "title": "Video",
      // "page": VideoScreen(),
    },
  ];


  @override
  Widget build(BuildContext context) {
    return   Consumer<FontSizeController>(builder: ( context,  fontScale, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Container(
          ),
          title:  Text("More", style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color,
              fontWeight: FontWeight.w500),),
        ),
        body: ListView(
            children: <Widget>[
              SwitchListTile(
                activeColor: Colors.red,
                secondary: SvgPicture.asset(
                    'assets/icons/notification.svg',
                       height: 22,
                  width: 22,
                   color: Theme.of(context).textTheme.bodyText1!.color,
        ),
                title: Text(
                    "Notifications",
                    style: TextStyle(fontSize: 9*fontScale.value, fontWeight: FontWeight.normal)),

                value: Provider.of<AppProvider>(context).isNotificationOn == "0"
                    ? false
                    : true,
                onChanged: (v) {
                  if (v==true) {
                    Provider.of<AppProvider>(context, listen: false).setNotificationEnabled("1");
                  } else {
                    Provider.of<AppProvider>(context, listen: false).setNotificationEnabled("0");
                  }
                },
              ),

              SwitchListTile(
                activeColor: Colors.red,
                secondary: SvgPicture.asset(
                  'assets/icons/setting.svg',
                  height: 24,
                  width: 24,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
                title: Text(
                    "Dark Theme",
                    style: TextStyle( fontSize: 9*fontScale.value, fontWeight: FontWeight.normal)),

                value: Provider.of<AppProvider>(context).theme == Constants.lightTheme
                    ? false
                    : true,
                onChanged: (v) {
                  if (v) {
                    Provider.of<AppProvider>(context, listen: false)
                        .setTheme(Constants.darkTheme, "dark");
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context)=>
                        HomePage(),
                    ));

                  } else {
                    Provider.of<AppProvider>(context, listen: false)
                        .setTheme(Constants.lightTheme, "light");
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context)=>
                        HomePage(),
                    ));

                  }
                },

              ),

              InkWell(
                child: MoreItems(name: "Font Size", image: "font.svg"),
                onTap: () {
                  fontDialog();
                },
              ),

              InkWell(
                child: MoreItems( name: "About Us", image: "aboutus.svg",),
                onTap: () {
                  Navigator.push( context, MaterialPageRoute( builder: (context) =>   BlocProvider<AboutUsBloc>(
                      create: (context) => AboutUsBloc(repository: Repository()),
                      child: AboutScreen()
                  )),
                  );
                },
              ),

              InkWell(
                child: MoreItems( name: "Contact Us", image: "contactus.svg"),
                onTap: () {
                  Navigator.push( context, MaterialPageRoute( builder: (context) => ContactUs()), );
                },
              ),

              InkWell(
                child: MoreItems( name: "Newsletter", image: "newsletter.svg"),
                onTap: () {
                  subscribeDialog(context,false);
                },
              ),

              InkWell(
                child: MoreItems(name: "Privacy Policy", image: "policy.svg"),
                onTap: () {
                  // Navigator.push( context, MaterialPageRoute(builder: (context) => BlocProvider<PrivacyPolicyBloc>(
                  //     create: (context) => PrivacyPolicyBloc(privacyPolicyRepository: NewsRepository()),
                  //     child: PrivacyScreen()
                  // ),), );
                },
              ),

              InkWell( child: MoreItems(name: "Rate Us", image: "rate.svg"),
                onTap: () {
                  // launchRate() async {
                  //   const url = 'https://apps.apple.com/ng/app/punch-news/id1416286632';
                  //   if (await canLaunch(url)) {
                  //     await launch(url, forceSafariVC: false,);
                  //   } else {
                  //     throw 'Could not launch $url';
                  //   }
                  // }
                  // launchRate();
                },
              ),

              InkWell(
                child:
                MoreItems(name: "Share App", image: "share.svg"),
                onTap: () {
                  // Share.share (
                  //   "Seen the Punch News App? \n\n Download App @ https://apps.apple.com/ng/app/punch-news/id1416286632",
                  // );
                },
              ),

              InkWell(
                child: MoreItems( name: "Advertise with us", image: "advertise.svg"),
                onTap: () {
                  // launchAdvertise() async {
                  //   const url = 'https://punchng.com/advertise-with-us';
                  //   if (await canLaunch(url)) {
                  //     await launch(url, forceWebView: true, forceSafariVC: true, );
                  //   } else {
                  //     throw 'Could not launch $url';
                  //   }
                  // }
                  // launchAdvertise();
                },
              ),

              SizedBox(height: 20),
              Column(
                children: [
                  Center(
                    child: Text("Follow us",
                      textAlign: TextAlign.center,
                      style: TextStyle( color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 9*fontScale.value,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                        child:   Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            InkWell(
                              onTap: (){
                                // launchLinkedIn() async {
                                //   const url = 'httpsA star topology is a topology for a Local Area Network (LAN) in which all nodes are individually connected to a central connection point, like a hub or a switch. A star takes more cable than e.g. a bus, but the benefit is that if a cable fails, only one node will be brought down. Star topology.://www.linkedin.com/company/punchnewspapers/mycompany/';
                                //   if (await canLaunch(url)) {
                                //     await launch(url);
                                //   } else {
                                //     throw 'Could not launch $url';
                                //   }
                                // }
                                // launchLinkedIn();
                              },

                              child: Container(
                                child: SvgPicture.asset(
                                  'assets/social_media/linkedin.svg',
                                  height: 35.0,
                                  width: 35.0,
                                ),
                              ),
                            ),

                            InkWell(
                              onTap: (){
                                // launchInstagram() async {
                                //   const url = 'https://www.instagram.com/punchnewspapers/';
                                //   if (await canLaunch(url)) {
                                //     await launch(url);
                                //   } else {
                                //     throw 'Could not launch $url';
                                //   }
                                // }
                                // launchInstagram();
                              },
                              child: Container(
                                child: SvgPicture.asset(
                                  'assets/social_media/instagram.svg',
                                  height: 35.0,
                                  width: 35.0,
                                ),
                              ),
                            ),

                            InkWell(
                              onTap: (){
                                // launchTelegram() async {
                                //   const url = 'https://t.me/PunchNewspaper';
                                //   if (await canLaunch(url)) {
                                //     await launch(url);
                                //   } else {
                                //     throw 'Could not launch $url';
                                //   }
                                // }
                                // launchTelegram();
                              },
                              child: Container(
                                child: SvgPicture.asset(
                                  'assets/social_media/telegram.svg',
                                  height: 35.0,
                                  width: 35.0,
                                ),
                              ),
                            ),

                            InkWell(
                              onTap: (){
                                // launchFacebook() async {
                                //   const url = 'https://www.facebook.com/punchnewspaper/';
                                //   if (await canLaunch(url)) {
                                //     await launch(url);
                                //   } else {
                                //     throw 'Could not launch $url';
                                //   }
                                // }
                                // launchFacebook();
                              },
                              child: Container(
                                child: SvgPicture.asset(
                                  'assets/social_media/facebook.svg',
                                  height: 35.0,
                                  width: 35.0,
                                ),
                              ),
                            ),

                            InkWell(
                              onTap: (){
                                // launchYouTube() async {
                                //   const url = 'https://www.youtube.com/channel/UCKBMh5v6VrB0t75ryyiVsBg';
                                //   if (await canLaunch(url)) {
                                //     await launch(url);
                                //   } else {
                                //     throw 'Could not launch $url';
                                //   }
                                // }
                                // launchYouTube();
                              },

                              child: Container(
                                child: SvgPicture.asset(
                                  'assets/social_media/youtube.svg',
                                  height: 35.0,
                                  width: 35.0,
                                ),
                              ),
                            ),

                            InkWell(
                              onTap: (){
                                // launchTwitter() async {
                                //   const url = 'https://twitter.com/MobilePunch';
                                //   if (await canLaunch(url)) {
                                //     await launch(url);
                                //   } else {
                                //     throw 'Could not launch $url';
                                //   }
                                // }
                                // launchTwitter();
                              },

                              child: Container(
                                child: SvgPicture.asset(
                                  'assets/social_media/twitter.svg',
                                  height: 35.0,
                                  width: 35.0,
                                ),
                              ),
                            ),

                          ],
                        )
                    ),
                  ),
                ],
              ),
            ]
        ) ,
      );}
    );
  }
}


class MoreItems extends StatefulWidget {
  final String name;
  final String image;
   String? icon;

  MoreItems({Key? key, required this.name, required this.image, this.icon}) : super(key: key);

  @override
  _MoreItemsState createState() => _MoreItemsState();
}

class _MoreItemsState extends State<MoreItems> {
  Widget build(BuildContext context) {
    return Consumer<FontSizeController>(
        builder: ( context,  fontScale, child) {
          return Container (
            padding: EdgeInsets.all ( 2.0 ),
            // height: 60,
            child: Row ( crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding (
                    padding: EdgeInsets.only ( left: 15, right: 15 ),
                    child: SvgPicture.asset (
                      "assets/icons/" + this.widget.image,
                      height: 22.0,
                      width: 22.0,
                      color: Theme.of ( context ).iconTheme.color,
                    ),
                  ),
                  Padding (
                    padding: const EdgeInsets.fromLTRB( 20.0, 10.0, 0.0, 10.0 ),
                    child: Container (
                      child: Text ( this.widget.name,
                          style: TextStyle (
                            color: Theme.of(context).textTheme.bodyText1!.color,
                              fontSize: 9 * fontScale.value,
                              fontWeight: FontWeight.normal ) ),
                    ),
                  ),
                ] ),
          );
        });
  }
}

