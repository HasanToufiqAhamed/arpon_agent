import 'package:arpon_agent/helper/flutter_statusbarcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeleton_text/skeleton_text.dart';

const kAppId='ecf7e9bd-fec9-4b80-a4ba-ab498cfc9a33';

void showErrorSnackbar(BuildContext context, String message){
  /*Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    duration: Duration(milliseconds: 2000),
    message: message,
    backgroundColor: MyColors.main_color,
  ).show(context);*/
  Fluttertoast.showToast(msg: message);
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 3.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

/*
class LoadingCard extends StatelessWidget {
  final double height;
  const LoadingCard({Key key, @required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: SkeletonAnimation(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(3)),
          height: height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}*/

class LoadingCard extends StatelessWidget {
  final double? height;
  const LoadingCard({Key? key, @required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: SkeletonAnimation(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(3)),
          height: height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}

changeStatusColor(Color color, {bool isWhite = true}) async {
  try {
    await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  } on Exception catch (e) {
    print(e);
  }
}
