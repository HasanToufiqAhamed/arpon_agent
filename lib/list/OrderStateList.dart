import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/model/OrderState.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

Widget OrderStateList(OrderState state, BuildContext con) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 23),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  height: 10,
                  width: 1,
                  color: MyColors.text_color,
                ),
                Visibility(
                  visible: state.state == 4,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.text_color,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Icon(FeatherIcons.x, color: MyColors.main_color,),
                  ),
                ),
                Visibility(
                  visible: state.state == 1,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.text_color,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Icon(FeatherIcons.check),
                  ),
                ),
                Visibility(
                  visible: state.state == 2,
                  child: Container(
                    height: 40,
                    width: 40,
                    child: SpinKitDoubleBounce(
                      size: 25,
                      color: MyColors.main_color,
                      /*itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: MyColors.main_color,
                          ),
                        );
                      },*/
                    ),
                  ),
                ),
                Visibility(
                  visible: state.state == 3,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.text_color,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: SizedBox(
                      height: 0,
                    ),
                  ),
                ),
                Visibility(
                  visible: state.title != 'Received',
                  child: Container(
                    height: 10,
                    width: 1,
                    color: MyColors.text_color,
                  ),
                )
              ],
            ),
            SizedBox(width: 10,),
            Expanded(child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      state.title!,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.text_color),
                    ),
                    Expanded(child: SizedBox(width: 0,),),
                  ],
                ),
                Row(
                  children: [
                    Visibility(
                      visible: state.state==1,
                      child: Text(
                        DateFormat('dd MMM yyyy (hh:mm a)')
                            .format(state.time!.toDate()),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: MyColors.text_secondary_color),
                      ),
                    ),
                    Expanded(child: SizedBox(width: 0,),),
                  ],
                ),
              ],
            ),),
          ],
        ),
      )
    ],
  );
}
