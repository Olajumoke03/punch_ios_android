import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:punch_ios_android/about_us/about_model.dart';
import 'package:punch_ios_android/about_us/about_us_bloc.dart';
import 'package:punch_ios_android/about_us/about_us_event.dart';
import 'package:punch_ios_android/about_us/about_us_state.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:punch_ios_android/widgets/build_error_ui.dart';
import 'package:punch_ios_android/widgets/build_loading_widget.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  AboutUsBloc? aboutUsBloc;
  FontSizeController? _fontSizeController;


  @override
  void initState() {
    super.initState();
    _fontSizeController = Provider.of<FontSizeController>(context, listen: false);

    aboutUsBloc = BlocProvider.of<AboutUsBloc>(context);
    aboutUsBloc!.add(FetchAboutUsEvent());
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

        body: SingleChildScrollView(
          child: Column(
            children: [
              BlocListener<AboutUsBloc, AboutUsState>(
                listener: (context, state){
                  if ( state is AboutUsLoadedState) {
                    // a message will only come when it is updating the feed.
                    // Scaffold.of ( context ).showSnackBar ( SnackBar ( content: Text ( "Category List Updated" ) , ) );
                  }
                  else if ( state is AboutUsLoadFailureState ) {
                    // Scaffold.of ( context ).showSnackBar ( SnackBar (
                    //   content: Text ( "Could not load data at this time" ) , ) );
                  }
                },
                child: BlocBuilder<AboutUsBloc, AboutUsState>(
                  builder: (context, state) {
                    if ( state is AboutUsInitialState ) {
                      return const BuildLoadingWidget ( );
                    } else if ( state is AboutUsLoadingState ) {
                      return const BuildLoadingWidget ( );
                    } else if ( state is AboutUsLoadedState ) {
                      return buildAboutUs ( state.aboutUs);
                    } else if ( state is AboutUsLoadFailureState ) {
                      return BuildErrorUi (message: state.error! );
                    }
                    else {
                      return const BuildErrorUi (message: "Something went wrong!" );
                    }
                  },
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget buildAboutUs (AboutUsModel? aboutUsModel){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child:  Column(
        children: [
          Text(
            aboutUsModel!.title!.rendered.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7*_fontSizeController!.value, color: Theme.of(context).textTheme.bodyText1!.color),
          ),

          Html(
            data:  '${aboutUsModel.content!.rendered}',
            style: {
              "body": Style(
                  fontSize:  FontSize(9*_fontSizeController!.value),
                  fontWeight: FontWeight.w400,
                  color:Theme.of(context).textTheme.bodyText1!.color,
                backgroundColor: Theme.of ( context ).backgroundColor,
              ),
            },
          )
        ],
      ),
    );

  }
}



