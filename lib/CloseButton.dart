import 'package:flutter/cupertino.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.all(25),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: Center(
            child: Text('X', style: TextStyle(color: Color(0xFF000000)),),
          ),
        ),
      ),
    );
  }
}