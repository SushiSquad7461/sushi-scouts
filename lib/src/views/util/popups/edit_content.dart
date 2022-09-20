import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/src/logic/models/scouting_data_models/scouting_data.dart';
import 'package:sushi_scouts/src/views/util/scouting_layout.dart';

class EditContent extends StatefulWidget {
  ScoutingData currentScoutingData;
  String title;
  Function editDB;
  late Size size;
  EditContent({Key? key, required this.currentScoutingData, required this.editDB, required this.title}) : super(key: key){
    size = Size(ScreenSize.width*0.8, ScreenSize.height*0.8);
    print(title);
  }

  @override
  EditContentState createState() => EditContentState();
}

class EditContentState extends State<EditContent> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: widget.size.width,
            height: widget.size.height,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 45 * ScreenSize.swu,
                      fontFamily: "Sushi",
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: ScoutingLayout(currentScoutingData: widget.currentScoutingData, error: (bool b) => b, size: widget.size)
                ),
                Expanded(
                  flex: 1,
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
                          Navigator.pop(context);
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
          ),
        ),
      ),
    );
  }
}
