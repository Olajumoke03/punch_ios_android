import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:punch_ios_android/utility/constants.dart';
import 'package:punch_ios_android/utility/font_controller.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> with TickerProviderStateMixin {
  FontSizeController? _fontSizeController;
  @override
  void initState() {
    super.initState();
    _fontSizeController = Provider.of<FontSizeController>(context, listen: false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar (
        centerTitle: true ,
        title: Image.asset ( 'assets/punchLogo.png' , width: 100 , height: 40 ) ,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyText1!.color,)
        ),
      ),

      body:  Container(
        padding:const EdgeInsets.all(10.0),
        child: Html(
            data:  Constants.appAbout,
            style: {
              "body": Style(
                fontSize:  FontSize(9*_fontSizeController!.value),
                fontWeight: FontWeight.w400,
                color:Theme.of(context).textTheme.bodyText1!.color,
                backgroundColor: Theme.of ( context ).backgroundColor,
              ),
            },
          )
      ),
    );
  }
}
