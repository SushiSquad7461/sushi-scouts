// Flutter imports:
import "package:flutter/material.dart";

// Project imports:
import "../../../logic/helpers/routing_helper.dart";
import "../../../logic/helpers/size/screen_size.dart";
import '../../../logic/login_type.dart';
import "../../../logic/models/scouting_data_models/scouting_data.dart";
import "../../util/header/header_nav.dart";
import "../../util/header/header_title/header_title.dart";
import "../../util/scouting_layout.dart";
import "edit.dart";

class EditContent extends StatefulWidget {
  final ScoutingData currentScoutingData;
  final String title;
  final Function editDB;
  late final Size size;
  EditContent(
      {Key? key,
      required this.currentScoutingData,
      required this.editDB,
      required this.title})
      : super(key: key) {
    size = Size(ScreenSize.width * 1, ScreenSize.height * 1);
  }

  @override
  EditContentState createState() => EditContentState();
}

class EditContentState extends State<EditContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const HeaderTitle(
            type: LoginType.supervise,
          ),
          HeaderNav(
            currentPage: "edit",
            isSupervise: true,
          ),
          Column(
            children: [
              SizedBox(
                  height: ScreenSize.height * 0.6,
                  width: ScreenSize.width,
                  child: ScoutingLayout(
                      currentScoutingData: widget.currentScoutingData,
                      error: (bool b) => b,
                      size: widget.size)),
              Padding(
                padding: EdgeInsets.only(top: ScreenSize.shu * 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () =>
                          setState(() => widget.currentScoutingData.prevPage()),
                      iconSize: ScreenSize.width / 6.0,
                      icon: Center(
                        child: Icon(
                          Icons.arrow_left_rounded,
                          color: widget.currentScoutingData.canGoToPrevPage()
                              ? Colors.black
                              : Colors.white,
                          semanticLabel: "Back Arrow",
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.editDB();
                        RouteHelper.pushAndRemoveUntilToScreen(-1, 0,
                            ctx: context, screen: const Edit());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black, width: ScreenSize.swu * 5),
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenSize.swu * 10))),
                        child: Text(
                          "SUBMIT",
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
                      onPressed: () =>
                          setState(() => widget.currentScoutingData.nextPage()),
                      iconSize: ScreenSize.width / 6.0,
                      icon: Center(
                        child: Icon(
                          Icons.arrow_right_rounded,
                          color: widget.currentScoutingData.canGoToNextPage()
                              ? Colors.black
                              : Colors.white,
                          semanticLabel: "Forward Arrow",
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ]));
  }
}
