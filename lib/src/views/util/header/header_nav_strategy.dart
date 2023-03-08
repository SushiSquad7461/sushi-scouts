// Flutter imports:
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

// Project imports:
import "../../../logic/Constants.dart";
import '../../../logic/helpers/color/hex_color.dart';
import "../../../logic/helpers/routing_helper.dart";
import "../../../logic/helpers/size/screen_size.dart";

class HeaderNavStrategy extends StatefulWidget {
  final String currPage;
  final TextEditingController? val;
  const HeaderNavStrategy({Key? key, required this.currPage, this.val}) : super(key: key);

  @override
  State<HeaderNavStrategy> createState() => _HeaderNavStrategyState();
}

class _HeaderNavStrategyState extends State<HeaderNavStrategy> {
  bool select = false;

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    final TextStyle textStyle = TextStyle(
      fontFamily: "Mohave",
      color: colors.primaryColor,
      fontSize: ScreenSize.height * 0.025,
    );

    List<Widget> text = [];

    stratPages.forEach((key, value) {
      text.add(GestureDetector(
        onTap: () => RouteHelper.pushAndRemoveUntilToScreen(0, 0,
            ctx: context, screen: value),
        child: Text(
          key.toUpperCase(),
          style: textStyle,
        ),
      ));
    });

    return select
        ? Container(
            height: ScreenSize.height * 0.25,
            width: ScreenSize.width,
            decoration: BoxDecoration(
                color: colors.primaryColorDark,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25 * ScreenSize.swu),
                    bottomLeft: Radius.circular(25 * ScreenSize.swu))),
            child: Padding(
              padding: EdgeInsets.only(
                  top: ScreenSize.height * 0.015,
                  bottom: ScreenSize.height * 0.015,
                  left: ScreenSize.width * 0.02),
              child: SizedBox(
                height: ScreenSize.height * 0.22,
                width: ScreenSize.width * 0.98,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: text),
              ),
            ),
          )
        : Container(
            height: ScreenSize.height * 0.06,
            width: ScreenSize.width,
            decoration: BoxDecoration(
                color: colors.primaryColorDark,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15 * ScreenSize.swu),
                    bottomLeft: Radius.circular(15 * ScreenSize.swu))),
            child: Padding(
              padding: EdgeInsets.only(left: ScreenSize.width * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: ScreenSize.width * 0.3,
                    height: ScreenSize.height * 0.04,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          select = !select;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.currPage.toUpperCase(),
                            style: textStyle,
                          ),
                          SizedBox(
                            child: SizedBox(
                              height: ScreenSize.height * 0.028,
                              width: ScreenSize.width * 0.045,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Divider(
                                      height: ScreenSize.height * 0.007,
                                      color: colors.primaryColor,
                                      thickness: ScreenSize.height * 0.003,
                                    ),
                                    Divider(
                                      height: ScreenSize.height * 0.007,
                                      color: colors.primaryColor,
                                      thickness: ScreenSize.height * 0.003,
                                    ),
                                    Divider(
                                      height: ScreenSize.height * 0.007,
                                      color: colors.primaryColor,
                                      thickness: ScreenSize.height * 0.003,
                                    ),
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (widget.val != null) SizedBox(
                    height: ScreenSize.height * 0.03,
                    width: ScreenSize.width * 0.4,
                    child: Center(
                      child: SizedBox(
                        width: ScreenSize.width * 0.3,
                        height: ScreenSize.height * 0.024,
                        child: TextFormField(
                          controller: widget.val,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: ScreenSize.height * 0.003,
                                  color: colors.scaffoldBackgroundColor == Colors.black ? Colors.black : HexColor("#4F4F4F")),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: ScreenSize.height * 0.003,
                                color: colors.scaffoldBackgroundColor == Colors.black ? Colors.black : HexColor("#4F4F4F")),
                          ),
                          hintText: "SEARCH",
                          hintStyle: TextStyle(color: colors.scaffoldBackgroundColor == Colors.black ? Colors.black : HexColor("#4F4F4F")),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: ScreenSize.height * 0.005),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Mohave",
                          fontSize: ScreenSize.width * 0.04,
                          color: colors.scaffoldBackgroundColor == Colors.black ? Colors.black : HexColor("#4F4F4F"),
                          ),
                      ),
                    ),
                  ),
                  ),
                ],
              ),
            )
          );
  }
}
