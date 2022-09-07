import 'package:flutter/cupertino.dart';
import 'package:punch_ios_android/utility/colors.dart';

class BuildErrorUi extends StatefulWidget {
  final String message;
  const BuildErrorUi({Key? key, required this.message}) : super(key: key);

  @override
  _BuildErrorUiState createState() => _BuildErrorUiState();
}

class _BuildErrorUiState extends State<BuildErrorUi> {
  @override
  Widget build(BuildContext context) {
    return Center (
      child: Text ( widget.message , style: const TextStyle (
          color: blackColor,
          fontSize: 15 ) ,
      ) ,
    );  }
}
