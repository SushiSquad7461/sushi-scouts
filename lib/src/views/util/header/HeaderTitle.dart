import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HeaderTitle extends StatelessWidget {
  final Size size;
  HeaderTitle({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double swu = size.width/600.0; //standardized width unit
    double shu = size.width/900.0; //standard height unit
    return Padding(
      padding: EdgeInsets.only(left: 20*swu, right: 20*swu, top: 0, bottom: 0),
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "sushi scouts",
            style: TextStyle(
              fontFamily: "Sushi",
              fontSize: 70*swu,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Image.asset("./assets/images/toprightlogo.png", scale: 6.0/swu,),
        ],
      )
    );
  }
}