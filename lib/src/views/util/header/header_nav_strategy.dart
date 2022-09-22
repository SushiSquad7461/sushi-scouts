// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

// Project imports:
import '../../../logic/helpers/size/screen_size.dart';

class HeaderNavStrategy extends StatefulWidget {
  const HeaderNavStrategy({Key? key}) : super(key: key);

  @override
  State<HeaderNavStrategy> createState() => _HeaderNavStrategyState();
}

class _HeaderNavStrategyState extends State<HeaderNavStrategy> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.height * 0.06,
      width: ScreenSize.width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15 * ScreenSize.swu),
            bottomLeft: Radius.circular(15 * ScreenSize.swu)
        )
      ),
      child: Row(
          children: [
            Text(
              "CHILD",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ]
      ),
    );
  }
}
