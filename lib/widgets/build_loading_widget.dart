import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punch_ios_android/utility/colors.dart';

class BuildLoadingWidget extends StatefulWidget {
  const BuildLoadingWidget({Key? key}) : super(key: key);

  @override
  _BuildLoadingWidgetState createState() => _BuildLoadingWidgetState();
}

class _BuildLoadingWidgetState extends State<BuildLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return  Center (
      child: CircularProgressIndicator ( strokeWidth: 2, color: Theme.of(context).primaryColor,) ,
    );  }
}
