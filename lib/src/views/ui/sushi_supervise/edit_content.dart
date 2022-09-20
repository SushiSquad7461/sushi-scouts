import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/src/logic/models/scouting_data_models/scouting_data.dart';
import 'package:sushi_scouts/src/views/util/Footer/supervisefooter.dart';
import 'package:sushi_scouts/src/views/util/header/header_nav.dart';
import 'package:sushi_scouts/src/views/util/header/header_title/header_title.dart';
import 'package:sushi_scouts/src/views/util/scouting_layout.dart';

import '../../../logic/helpers/routing_helper.dart';
import '../../util/opacityfilter.dart';
import 'edit.dart';

class EditContent extends StatefulWidget {
  ScoutingData currentScoutingData;
  String title;
  Function editDB;
  late Size size;
  EditContent({Key? key, required this.currentScoutingData, required this.editDB, required this.title}) : super(key: key){
    size = Size(ScreenSize.width*1, ScreenSize.height*1);
  }

  @override
  EditContentState createState() => EditContentState();
}

class EditContentState extends State<EditContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const HeaderTitle( isSupervise: true,),
          HeaderNav(currentPage: "edit", isSupervise: true,),
          Column(
            children: [
              SizedBox(
                height: ScreenSize.height * 0.6,
                width: ScreenSize.width,
                child: ScoutingLayout(currentScoutingData: widget.currentScoutingData, error: (bool b) => b, size: widget.size)
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenSize.shu*50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () => setState(()=>widget.currentScoutingData.prevPage()),
                      iconSize: ScreenSize.width / 6.0,
                      icon: Center(
                        child: Icon(
                          Icons.arrow_left_rounded,
                          color: widget.currentScoutingData.canGoToPrevPage() ? Colors.black : Colors.white,
                          semanticLabel: 'Back Arrow',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.editDB();
                        RouteHelper.pushAndRemoveUntilToScreen(-1, 0, ctx: context, screen: const Edit());
                      }, 
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: ScreenSize.swu*5
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(ScreenSize.swu*10))
                        ),
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(
                              fontSize: 40 * ScreenSize.swu,
                              fontFamily: "Sushi",
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () => setState(()=>widget.currentScoutingData.nextPage()),
                      iconSize: ScreenSize.width / 6.0,
                      icon: Center(
                        child: Icon(
                          Icons.arrow_right_rounded,
                          color: widget.currentScoutingData.canGoToNextPage() ? Colors.black : Colors.white,
                          semanticLabel: 'Forward Arrow',
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ]
      )
    );
  }
}
