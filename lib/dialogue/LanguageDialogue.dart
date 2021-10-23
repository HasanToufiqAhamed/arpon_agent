import 'package:arpon_agent/activity/HomeActivity.dart';
import 'package:arpon_agent/data/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageDialogue extends StatelessWidget {

  LanguageDialogue();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                'ভাষা - Language',
                style: TextStyle(
                    color: MyColors.text_color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                highlightColor: MyColors.veryLightWhit,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'English',
                        style:
                        TextStyle(fontSize: 18, color: MyColors.text_color),
                      ),
                      Container(height: 24, width: 24,child: SvgPicture.asset('assets/icons/united-kingdom.svg')),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder:
                              (context) =>
                              HomeActivity()),
                          (Route<dynamic> route) =>
                      false);
                  context.locale = Locale('en');
                },
              ),
              InkWell(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                highlightColor: MyColors.veryLightWhit,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'বাংলা',
                        style:
                        TextStyle(fontSize: 18, color: MyColors.text_color),
                      ),
                      Container(height: 24, width: 24,child: SvgPicture.asset('assets/icons/bangladesh.svg')),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder:
                              (context) =>
                              HomeActivity()),
                          (Route<dynamic> route) =>
                      false);
                  context.locale = Locale('bn');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
