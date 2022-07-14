import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sushi_scouts/src/views/util/popups/RequiredContent.dart';
import '../../../../ScoutingLib/logic/data/ScoutingData.dart';
import '../../../../ScoutingLib/logic/size/ScreenSize.dart';
import 'Footer.dart';
import 'package:sushi_scouts/src/views/ui/QRScreen.dart';

class ScoutingFooter extends StatefulWidget {
  final ScoutingData? data;
  final void Function(bool submmit) newPage;
  final BuildContext popupContext;

  const ScoutingFooter({
    Key? key,
    required this.data,
    required this.newPage,
    required this.popupContext,
  }) : super(key: key);

  @override
  State<ScoutingFooter> createState() => _ScoutingFooterState();
}

class _ScoutingFooterState extends State<ScoutingFooter> {
  String footer = "";
  bool nextPage = false;
  bool prevPage = false;

  void moveToNextPage() {
    print("Next page");
    widget.data!.nextPage();
    widget.newPage(false);
    updateState();
  }

  void moveToPreviousPage() {
    widget.data!.prevPage();
    widget.newPage(false);
    updateState();
  }

  @override
  void initState() {
    super.initState();
    updateState();
  }

  void updateState() {
    setState(() {
      nextPage = widget.data!.canGoToNextPage();
      prevPage = widget.data!.canGoToPrevPage();
      footer = widget.data!.getCurrentPage()!.footer;
    });
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);

    return Container(
        height: ScreenSize.height * 0.165,
        padding: const EdgeInsets.all(0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: moveToPreviousPage,
                iconSize: ScreenSize.width / 6.0,
                icon: Icon(
                  Icons.arrow_left_rounded,
                  color: prevPage
                      ? colors.primaryColorDark
                      : colors.scaffoldBackgroundColor,
                  semanticLabel: 'Back Arrow',
                ),
              ),
              (nextPage
                  ? SizedBox(
                      width: ScreenSize.width / 10.0, //57
                      height: ScreenSize.width / 10.0, //59
                      child: SvgPicture.asset(
                        "./assets/images/${colors.scaffoldBackgroundColor == Colors.black ? "darknori" : "nori"}.svg",
                      ))
                  : Container(
                      width: 150 * ScreenSize.swu,
                      height: 55 * ScreenSize.swu,
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.primaryColorDark, width: 3.5),
                        color: colors.scaffoldBackgroundColor,
                        borderRadius:
                            BorderRadius.circular(10 * ScreenSize.swu),
                      ),
                      child: TextButton(
                        onPressed: () {
                          List<String> notFilled = widget.data!.notFilled();
                          if(notFilled.isEmpty) {
                            widget.newPage(true);
                          } else {
                            showDialog(
                              context: context, 
                              builder: (context) => RequiredContent(notFilled)
                            );
                          }
                        },
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(
                              fontSize: 29 * ScreenSize.swu,
                              fontFamily: "Sushi",
                              color: colors.primaryColorDark,
                              fontWeight: FontWeight.bold),
                        ),
                      ))),
              IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  List<String> notFilled = widget.data!.notFilled();
                  if(notFilled.isEmpty) {
                    moveToNextPage();
                  } else {
                    showDialog(
                      context: context, 
                      builder: (context) => RequiredContent(notFilled)
                    );
                  }
                },
                iconSize: ScreenSize.width / 6.0,
                icon: Icon(Icons.arrow_right_rounded,
                    color: nextPage
                        ? colors.primaryColorDark
                        : colors.scaffoldBackgroundColor,
                    semanticLabel: 'Forward Arrow'),
              ),
            ],
          ),
          Footer(pageTitle: footer)
        ]));
  }
}
