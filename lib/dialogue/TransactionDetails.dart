import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/model/Transaction.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionDetails extends StatelessWidget {
  Transactions transactions;

  TransactionDetails(this.transactions);

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
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
                color: MyColors.main_color,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: transactions.category == 1
                    ? Icon(
                        FeatherIcons.plusCircle,
                        color: Colors.white,
                        size: 50,
                      )
                    : SvgPicture.asset(
                        transactions.medium == 1
                            ? 'assets/icons/bkash.svg'
                            : transactions.medium == 2
                                ? 'assets/icons/nagad.svg'
                                : 'assets/icons/upay.svg',
                        width: 50,
                        height: 50,
                        color: Colors.white,
                      ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'AMOUNT'.tr(),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: MyColors.text_third_color),
            ),
            SizedBox(height: 10),
            Text(
              '৳${transactions.amount!.toStringAsFixed(transactions.amount!.truncateToDouble() == transactions.amount ? 0 : 2)}',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MyColors.text_color),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              transactions.category == 1
                  ? 'Order ID'.tr()
                  : 'Transaction ID'.tr(),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: MyColors.text_third_color),
            ),
            SizedBox(height: 10),
            SelectableText(
              '${transactions.id}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MyColors.text_color),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'DATE & TIME'.tr(),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: MyColors.text_third_color),
            ),
            SizedBox(height: 10),
            Text(
              '${DateFormat('dd MMM yyyy, hh:mm a').format(transactions.time!.toDate())}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MyColors.text_color),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 1,
              color: MyColors.layout_divider_color,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          'Ok',
                          style: TextStyle(
                              fontSize: 18, color: MyColors.text_color),
                        ).tr(),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
