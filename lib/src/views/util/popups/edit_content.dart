import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/src/logic/models/scouting_data_models/scouting_data.dart';
import 'package:sushi_scouts/src/views/util/scouting_layout.dart';

class EditContent extends StatefulWidget {
  ScoutingData currentScoutingData;
  late Size size;
  EditContent({Key? key, required this.currentScoutingData}) : super(key: key){
    size = Size(ScreenSize.width*0.8, ScreenSize.height*0.8);
  }

  @override
  EditContentState createState() => EditContentState();
}

class EditContentState extends State<EditContent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: Column(
        children: [
          ScoutingLayout(currentScoutingData: widget.currentScoutingData, error: (bool b) => b, size: widget.size)
        ],
      ),
    );
  }
}
