import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/model/Balance.dart';
import 'package:arpon_agent/model/Bank.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CashOutDialogue extends StatefulWidget {
  Balance balance;
  BuildContext con;
  CashOutDialogue(this.balance, this.con);

  @override
  _CashOutDialogueState createState() => _CashOutDialogueState();
}

class _CashOutDialogueState extends State<CashOutDialogue> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int isSelectedMethod = 2;
  int isSelectedWay = 1;
  String isSelectedMethodText = 'Nagad'.tr();
  String isSelectedWayText = 'Agent number'.tr();
  TextEditingController number = new TextEditingController();
  FocusNode fNameFocus = new FocusNode();
  Color? color;
  bool? errorWithNumber = false;
  String? errorWithNumberText = '';
  bool? _loading = false;
  bool? selectBank = false;
  bool? selectBkash = false;
  bool? haveBankAccount = false;

  @override
  Widget build(BuildContext context) {
    fNameFocus.addListener(() {
      setState(() {
        color = fNameFocus.hasFocus ? Colors.black : MyColors.text_third_color;
      });
    });
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: [
            SizedBox(height: 20),
            Text(
              'Cash out',
              style: TextStyle(
                  color: MyColors.text_color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20),
                Expanded(child: method(1, 'assets/icons/bkash.svg')),
                SizedBox(width: 30),
                Expanded(child: method(2, 'assets/icons/nagad.svg')),
                SizedBox(width: 30),
                Expanded(child: method(3, 'assets/icons/upay.svg')),/*
                SizedBox(width: 30),
                Expanded(child: method(4, 'assets/icons/bank.svg')),*/
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 20),
            selectBank!
                ? FutureBuilder<DocumentSnapshot>(
                    future: firestore
                        .collection('UserAgentSecretInformation')
                        .doc(auth.currentUser!.uid)
                        .collection('BankDetails')
                        .doc('Account')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Container(
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: CircularProgressIndicator(
                              color: MyColors.text_color,
                              strokeWidth: 1,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: MyColors.layout_divider_color,
                            borderRadius: BorderRadius.circular(120),
                          ),
                        );
                      }

                      if (!snapshot.data!.exists) {
                        return InkWell(
                          highlightColor: MyColors.veryLightWhit,
                          borderRadius: BorderRadius.all(Radius.circular(1000)),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Icon(
                                FeatherIcons.plus,
                                color: MyColors.main_color,
                                size: 36,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: MyColors.layout_divider_color,
                              borderRadius: BorderRadius.circular(120),
                            ),
                          ),
                        );
                      } else {
                        /*setState(() {
                          haveBankAccount=true;
                        });*/

                        Bank bank = Bank.fromFirestore(snapshot.data);

                        return Text('${bank.accountNumber}');
                      }
                    },
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.all(Radius.circular(11)),
                          ),
                          child: selectBkash!
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: MyColors.main_color),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            'Payment'.tr(),
                                            style: TextStyle(
                                              color:  Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(child: way(1, 'Payment'.tr())),
                                    Expanded(child: way(2, 'Send money'.tr())),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13),
                        child: TextField(
                          controller: number,
                          focusNode: fNameFocus,
                          keyboardType: TextInputType.number,
                          maxLength: 11,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                            errorText:
                                errorWithNumber! ? errorWithNumberText : null,
                            border: OutlineInputBorder(),
                            labelText:
                                '${isSelectedMethodText} ${isSelectedWayText}',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyColors.layout_divider_color,
                                  width: 2.0),
                            ),
                            labelStyle: TextStyle(color: color),
                          ),
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 15),
            //LoadingButton(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Fluttertoast.showToast(msg: 'Tap and hold confirm button'.tr()),
                      onLongPress: _loading!
                          ? null
                          : () async {
                              String num = number.text.toString();

                              if (selectBank!) {
                                if (haveBankAccount!) {
                                  Fluttertoast.showToast(
                                      msg: 'have bank account');
                                } else
                                  Fluttertoast.showToast(
                                      msg: 'Please add bank account first');
                              } else {
                                if (num.isEmpty) {
                                  //showErrorSnackbar(context, 'Enter recipient number');
                                  setState(() {
                                    errorWithNumberText =
                                        'Enter recipient number'.tr();
                                    errorWithNumber = true;
                                  });
                                } else if (num.length != 11) {
                                  //showErrorSnackbar(context, 'Enter correct number');
                                  setState(() {
                                    errorWithNumberText =
                                        'Enter correct number'.tr();
                                    errorWithNumber = true;
                                  });
                                } else if (!validPhoneNumber(num)) {
                                  //showErrorSnackbar(context, 'Enter valid Airtel number, started with 016');
                                  setState(() {
                                    errorWithNumberText =
                                        'Enter correct number'.tr();
                                    errorWithNumber = true;
                                  });
                                } else if (isSelectedWay == 0) {
                                  Fluttertoast.showToast(
                                      msg: 'select a way'.tr());
                                } else {
                                  FocusScope.of(context).unfocus();
                                  setState(() =>
                                  _loading = false
                                  );
                                  firestore.collection('admin').doc('waiting').collection('cashOut').doc(auth.currentUser!.uid).set({
                                    'amount': widget.balance.balance,
                                    'time': FieldValue.serverTimestamp(),
                                    'uId': auth.currentUser!.uid,
                                    'method': isSelectedMethod,
                                    'way': isSelectedWay,
                                    'number': num
                                  }).then((value) {
                                    setState(() {
                                      _loading = false;
                                    });
                                    Navigator.pop(widget.con);
                                    Navigator.pop(context);
                                  }).onError((error, stackTrace) {
                                    setState(() =>
                                      _loading = false
                                    );
                                    Fluttertoast.showToast(msg: 'dd45as ${error.toString()}');
                                  });
                                }
                              }
                            },
                      child: _loading!
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1,
                                ),
                              ),
                            )
                          : Text(
                              'Confirm',
                              style: TextStyle(color: Colors.white),
                            ).tr(),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(MyColors.main_color),
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => MyColors.ripple_effect_color),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1000),
                                    side: BorderSide(
                                        width: 2, color: MyColors.main_color))),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget way(int pos, String icon) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      highlightColor: MyColors.veryLightWhit,
      onTap: _loading!
          ? null
          : () {
              if (isSelectedWay != pos) {
                setState(() {
                  isSelectedWay = pos;
                  isSelectedWayText =
                      pos == 1 ? 'Agent number'.tr() : 'Personal number'.tr();
                });
              }
            },
      child: Container(
        alignment: Alignment.center,
        decoration: isSelectedWay == pos
            ? BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: pos == 1
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))
                    : BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10)),
                color: MyColors.main_color)
            : BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            icon,
            style: TextStyle(
              color: isSelectedWay == pos
                  ? Colors.white
                  : MyColors.edit_text_tint_color,
              fontWeight:
                  isSelectedWay == pos ? FontWeight.bold : FontWeight.normal,
              fontSize: isSelectedWay == pos ? 18 : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget method(int pos, String icon) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      highlightColor: MyColors.veryLightWhit,
      onTap: _loading!
          ? null
          : () {
              if (isSelectedMethod != pos) {
                setState(() {
                  isSelectedMethod = pos;
                  isSelectedMethodText = pos == 1
                      ? 'bKash'.tr()
                      : pos == 2
                          ? 'Nagad'.tr()
                          : pos == 3
                              ? 'Upay'.tr()
                              : 'bank';
                  pos == 4 ? selectBank = true : selectBank = false;
                  pos == 1 ? selectBkash = true : selectBkash = false;
                  if(pos==1)
                    isSelectedWayText='Agent number'.tr();
                  else
                    isSelectedWayText = isSelectedWay == 1 ? 'Agent number'.tr() : 'Personal number'.tr();
                });
              }
            },
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          width: double.infinity,
          decoration: isSelectedMethod == pos
              ? BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: MyColors.main_color_40_percent)
              : BoxDecoration(),
          child: Stack(
            children: [
              //Container(padding: EdgeInsets.only(left: 5, top: 5), child: SvgPicture.asset(pos==1?'icons/home.svg':pos==2?'icons/heart.svg':pos==3?'icons/bell.svg':'icons/user.svg', color: isSelected == pos ? MyColors.edit_text_tint_color : Colors.white),),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(icon,
                    color: isSelectedMethod == pos
                        ? null
                        : MyColors.edit_text_tint_color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validPhoneNumber(String p) {
    if (p.length != 11)
      return false;
    else if (!p.startsWith('017') &&
        !p.startsWith('013') &&
        !p.startsWith('019') &&
        !p.startsWith('014') &&
        !p.startsWith('016') &&
        !p.startsWith('018') &&
        !p.startsWith('015'))
      return false;
    else
      return true;
  }
}

class LoadingButton extends StatefulWidget {
  @override
  LoadingButtonState createState() => LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  bool? complete = false;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    controller!.addListener(() {
      setState(() {
        controller!.value == 1 ? complete = true : complete = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (_) {
        controller!.forward();
      },
      onTap: () {
        if (controller!.status == AnimationStatus.forward) {
          controller!.reverse();
        }
        //Fluttertoast.showToast(msg: controller!.value.toString());
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 4,
              valueColor:
                  AlwaysStoppedAnimation<Color>(MyColors.layout_divider_color),
            ),
          ),
          Container(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              value: controller!.value,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
          Icon(complete! ? Icons.done : Icons.add)
        ],
      ),
    );
  }
}
