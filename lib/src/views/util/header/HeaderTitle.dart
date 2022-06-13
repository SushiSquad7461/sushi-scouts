import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "sushi scouts",
            style: TextStyle(
              fontFamily: "Sushi",
              fontSize: 70,
              fontWeight: FontWeight.w600,
            ),
          ),
          Image.asset("./assets/images/toprightlogo.png", scale: 6,),
        ],
      )
    );
  }
}