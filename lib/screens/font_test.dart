import 'package:flutter/material.dart';
import 'package:punch_ios_android/utility/colors.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:provider/provider.dart';


class ChangeTextSizeWithSeekBar extends StatefulWidget {
  const ChangeTextSizeWithSeekBar({Key? key}) : super(key: key);

  @override
  _ChangeTextSizeWithSeekBarState createState() => _ChangeTextSizeWithSeekBarState();
}

class _ChangeTextSizeWithSeekBarState extends State<ChangeTextSizeWithSeekBar> {
  late FontSizeController _fontSizeController;

  double _value=2.6;
  @override
  void initState() {
    super.initState();
    _fontSizeController = Provider.of<FontSizeController>(context, listen: false);
    setState(() {
      _value = _fontSizeController.value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: Theme.of(context).textTheme.button!.color,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text( "Text Size",
              style: TextStyle( fontSize: 10* _value, color:Theme.of(context).textTheme.bodyText1!.color ),
            ),

            Slider(
              divisions: 5,
              activeColor: mainColor,
              inactiveColor: Colors.white,
              onChanged: (value){
                setState(() {
                  _value = value;
                });

                _fontSizeController.updateFontSize(_value);
              },
              max: 3,
              min: 2,
              value: _value,
            )
          ],
        ),
      ),
    );
  }
}



