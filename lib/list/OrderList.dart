import 'package:arpon_agent/activity/OrderActivity.dart';
import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/model/Order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget OrderList(Order order, BuildContext con) {

  return Column(
    children: [
      InkWell(
        child: Container(
          padding: EdgeInsets.fromLTRB(18, 15, 18, 15),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('#'+order.orderId!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent[200]),),
                  SizedBox(height: 5,),
                  Text(DateFormat('dd MMM yyyy (hh:mm a)').format(order.time!.toDate()),  style: TextStyle(fontSize: 14, color: MyColors.text_secondary_color),)
                ],
              ),
              Expanded(child: SizedBox(width: 0,), flex: 1,),
              Text('৳'+order.paymentAmount!.toStringAsFixed(order.paymentAmount!.truncateToDouble() == order.paymentAmount ? 0 : 1), style: TextStyle(fontSize: 20, color: MyColors.text_color, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            con,
            MaterialPageRoute(
              builder: (context) => OrderActivity(order.orderId!, order.productId!),
            ),
          );
        },
      ),
      Container(
        height: 1,
        color: MyColors.layout_divider_color,
        margin: EdgeInsets.symmetric(horizontal: 25),
      )
    ],
  );
}
