import 'package:arpon_agent/activity/ProductActive.dart';
import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/model/Product.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget ProductList(Product? object, BuildContext? con) {
  String getAvailable() {
    if (object!.unlimited!)
      return 'Unlimited';
    else
      return object.available.toString() + ' left';
  }

  String getOperatorImage() {
    if (object!.operator! == 1)
      return 'assets/icons/airtel_colorful_without_name.svg';
    else if (object.operator == 2)
      return 'assets/icons/banglalink_colorful_without_name.svg';
    else if (object.operator == 3)
      return 'assets/icons/grameenphone_colorful_without_name.svg';
    else if (object.operator == 4)
      return 'assets/icons/robi_colorful_without_name.svg';
    else
      return 'assets/icons/teletalk_colorful_without_name.svg';
  }

  return InkWell(
    onTap: () => Navigator.push(
      con!,
      MaterialPageRoute(
        builder: (context) => ProductActive(object!.productCode!),
      ),
    ),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(8, 13, 15, 13),
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  height: 85,
                  width: 85,
                  padding: EdgeInsets.fromLTRB(10, 15, 15, 15),
                  child: SvgPicture.asset(getOperatorImage()),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    FeatherIcons.globe,
                                    color: MyColors.edit_text_tint_color,
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  Text(
                                    object!.internet.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: MyColors.text_color,
                                    ),
                                  ),
                                  Text(
                                    ' GB',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: MyColors.text_color,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 9,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    FeatherIcons.phone,
                                    color: MyColors.edit_text_tint_color,
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  Text(
                                    object.talkTime.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: MyColors.text_color,
                                    ),
                                  ),
                                  Text(
                                    ' Minutes',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: MyColors.text_color,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 9,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    FeatherIcons.messageSquare,
                                    color: MyColors.edit_text_tint_color,
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  Text(
                                    object.sms.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: MyColors.text_color,
                                    ),
                                  ),
                                  Text(
                                    ' SMS',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: MyColors.text_color,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 50,
                          color: MyColors.layout_divider_color,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  child: Text(
                                    '৳' +
                                        object.price!.toStringAsFixed(
                                            object.price!.truncateToDouble() ==
                                                object.price
                                                ? 0
                                                : 2),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: MyColors.text_color,
                                    ),
                                  ),
                                ),
                                Text(
                                  getAvailable(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                    color: MyColors.text_color,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Divider(height: 0),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color: MyColors.layout_divider_color,
          margin: EdgeInsets.symmetric(horizontal: 25),
        )
      ],
    ),
  );
}
