import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/dialogue/TransactionDetails.dart';
import 'package:arpon_agent/model/Transaction.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

Widget TransactionList(Transactions object, BuildContext con) {
  return Container(
    color: Colors.transparent,
    child: InkWell(
      splashColor: MyColors.layout_divider_color,
      child: Container(
        padding: EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          children: [
            Icon(
              object.category == 1
                  ? FeatherIcons.arrowUpCircle
                  : FeatherIcons.arrowDownCircle,
              color: object.category == 1 ? Colors.green : Colors.red,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        object.id.toString(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: MyColors.text_color),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${DateFormat('dd MMM hh:mm a').format(object.time!.toDate())}',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: MyColors.text_secondary_color),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              '${object.category == 1 ? '+' : '-'} ৳${object.amount!.toStringAsFixed(object.amount!.truncateToDouble() == object.amount ? 0 : 2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: object.category == 1 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        showDialog(
          context: con,
          builder: (BuildContext context) => TransactionDetails(object),
        );
      },
    ),
  );
}
