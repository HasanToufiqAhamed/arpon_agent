import 'dart:math';

import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/helper/ConfirmationSlider.dart';
import 'package:arpon_agent/helper/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPostDialog extends StatefulWidget {
  BuildContext contextPostActivity;
  int operator;
  double price;
  int validity;
  int internet;
  int talkTime;
  int sMS;
  int available;
  bool unlimited;
  String title;
  String description;
  bool check;

  AddPostDialog(
      this.contextPostActivity,
      this.operator,
      this.price,
      this.validity,
      this.internet,
      this.talkTime,
      this.sMS,
      this.available,
      this.unlimited,
      this.title,
      this.description,
      this.check);

  @override
  AddPostDialogState createState() => new AddPostDialogState();
}

class AddPostDialogState extends State<AddPostDialog> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String ? uniqueCode;

  @override
  void initState() {
    makeAndCheckUniqueCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm post',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: MyColors.text_color),
                      ),
                      Text('Please check ypur offer for final',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: MyColors.text_third_color)),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 0,
                    ),
                  ),
                  IconButton(
                    icon: Icon(FeatherIcons.x),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: MyColors.layout_divider_color,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.white,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: appBar.preferredSize.height,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            child: Text(
                                              widget.title,
                                              maxLines: 1,
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(width: 15),
                                                  Text(
                                                    '৳' +
                                                        widget.price.toString(),
                                                    style: TextStyle(
                                                      fontSize: 34,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(width: 15),
                                                  Text(
                                                    'Bundle offer',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Container(width: 20),
                                                  Icon(
                                                    FeatherIcons.globe,
                                                    color: Colors.redAccent,
                                                  ),
                                                  Container(width: 10),
                                                  Text(
                                                    widget.internet.toString() +
                                                        ' GB',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Container(width: 20),
                                                  Container(
                                                      child: Icon(
                                                    FeatherIcons.phone,
                                                    color: Colors.redAccent,
                                                  )),
                                                  Container(width: 10),
                                                  Text(
                                                    widget.talkTime.toString() +
                                                        ' Minutes',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Container(width: 20),
                                                  Container(
                                                      child: Icon(
                                                    FeatherIcons.messageSquare,
                                                    color: Colors.redAccent,
                                                  )),
                                                  Container(width: 10),
                                                  Text(
                                                    widget.sMS.toString() +
                                                        ' SMS',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            margin: EdgeInsets.all(5),
                                            child: Container(
                                                child: SvgPicture.asset(
                                                    getOperatorImage(1))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(height: 10),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Text(
                                                'Validity',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Container(
                                                height: 5,
                                              ),
                                              Text(
                                                widget.validity.toString(),
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Container(
                                                height: 5,
                                              ),
                                              Text(
                                                'Days',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Text(
                                                'Available',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Container(
                                                height: 5,
                                              ),
                                              Text(
                                                getAvailabelText(
                                                    widget.unlimited,
                                                    widget.available),
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Container(
                                                height: 5,
                                              ),
                                              Text(
                                                'Packages',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(height: 15),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Description',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 20,
                                                color: Colors.black)),
                                        SizedBox(height: 10),
                                        Text(
                                          widget.description,
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: MyColors.text_color,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ConfirmationSlider(
                height: 64,
                text: 'SWIPE TO POST',
                onConfirmation: () {
                  firestore
                      .collection('ProductUniqueCode')
                      .doc(uniqueCode)
                      .set({
                    'productCode': uniqueCode,
                    'uId': auth.currentUser!.uid,
                    'time': FieldValue.serverTimestamp(),
                  }).then(
                    (value) {
                      firestore
                          .collection('WaitingProduct')
                          .doc(uniqueCode)
                          .set({
                        'operator': widget.operator,
                        'price': widget.price,
                        'validity': widget.validity,
                        'internet': widget.internet,
                        'talkTime': widget.talkTime,
                        'sms': widget.sMS,
                        'available': widget.available,
                        'unlimited': widget.unlimited,
                        'title': widget.title,
                        'description': widget.description,
                        'checkBeforeBuy': widget.check,
                        'uId': auth.currentUser!.uid,
                        'productCode': uniqueCode,
                        'activeStatus': false,
                        'time': FieldValue.serverTimestamp(),
                      }).then((value) {
                        Navigator.pop(context);
                        Navigator.pop(widget.contextPostActivity);
                        showDialog(
                            context: context,
                            builder: (_) => SuccessDialogue());
                      }).catchError(
                        (onError) {
                          Fluttertoast.showToast(msg: '4d7ipg ' + onError.toString());
                        },
                      );
                    },
                  ).catchError(
                    (onError) {
                      Fluttertoast.showToast(msg: '2f85gb ' + onError.toString());
                    },
                  );
                },
                backgroundColor: Color(0xFFECECEC),
                backgroundShape: BorderRadius.circular(10),
                icon: FeatherIcons.arrowRight,
                foregroundColor: MyColors.main_color,
                foregroundShape: BorderRadius.circular(10),
                shadow: BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getOperatorImage(int a) {
    if (a == 1)
      return 'assets/icons/airtel_colorful_without_name.svg';
    else if (a == 2)
      return 'assets/icons/banglalink_colorful_without_name.svg';
    else if (a == 3)
      return 'assets/icons/grameenphone_colorful_without_name.svg';
    else if (a == 4)
      return 'assets/icons/robi_colorful_without_name.svg';
    else
      return 'assets/icons/teletalk_colorful_without_name.svg';
  }

  String getAvailabelText(bool unlimited, int available) {
    if (unlimited)
      return 'Unlimited';
    else
      return available.toString();
  }

  String? makeAndCheckUniqueCode() {
    var r = Random();
    const _chars = '1234567890';
    uniqueCode = 'ARP' +
        List.generate(10, (index) => _chars[r.nextInt(_chars.length)]).join();

    firestore
        .collection('ProductUniqueCode')
        .doc(uniqueCode)
        .get()
        .then((value) {
      if (value.exists) {
        makeAndCheckUniqueCode();
      }
    });
  }
}

class SuccessDialogue extends StatefulWidget {
  SuccessDialogue();

  @override
  _SuccessDialogueState createState() => new _SuccessDialogueState();
}

class _SuccessDialogueState extends State<SuccessDialogue> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Thank You!',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MyColors.text_color),
                        ),
                        Text(
                          'Offer submitted successfully',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: MyColors.text_third_color),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MySeparator(color: Colors.grey),
                        SizedBox(
                          height: 15,
                        ),
                        Icon(
                          FeatherIcons.checkCircle,
                          size: 100,
                          color: MyColors.main_color,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        MySeparator(color: Colors.grey),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Thank you for yor submit your offer. We response to your offer as soon as possible.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: MyColors.text_color),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      'OK',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  color: MyColors.main_color,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
