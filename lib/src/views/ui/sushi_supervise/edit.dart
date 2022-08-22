import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sushi_scouts/src/logic/models/match_schedule.dart';

import '../../../logic/helpers/size/ScreenSize.dart';
import '../../util/footer/supervisefooter.dart';
import '../../util/header/header_nav.dart';
import '../../util/header/header_title/header_title.dart';

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const HeaderTitle(
            isSupervise: true,
          ),
          HeaderNav(
            currentPage: "edit",
            isSupervise: true,
          ),
          SizedBox(
            height: ScreenSize.height * 0.65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: ScreenSize.height * 0.07,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("ALL"),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenSize.height * 0.58,
                  width: ScreenSize.width * 0.82,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ScreenSize.width * 0.03),
                      border: Border.all(
                        color: Colors.black,
                        width: ScreenSize.width * 0.01,
                      )
                    ),
                    child: ListView(

                    ),
                  ),
                )
              ],
            ), 
          ),
          const SuperviseFooter(),
        ],
      ),
    ); 
  }
}