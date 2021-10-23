import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/dialogue/AddPostDialog.dart';
import 'package:arpon_agent/helper/helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PostActivity extends StatefulWidget {
  int operator;

  PostActivity(this.operator);

  _PostActivityState createState() => _PostActivityState();
}

class _PostActivityState extends State<PostActivity> {
  AppBar appBar = AppBar();
  TextEditingController priceText = new TextEditingController();
  TextEditingController validityText = new TextEditingController();
  TextEditingController internetText = new TextEditingController();
  TextEditingController talkTimeText = new TextEditingController();
  TextEditingController smsText = new TextEditingController();
  TextEditingController availableText = new TextEditingController();
  TextEditingController titleText = new TextEditingController();
  TextEditingController descriptionText = new TextEditingController();
  FocusNode focusNode = new FocusNode();
  String totalPriceString = '৳0';
  TextEditingController totalPrice = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            SizedBox(height: statusBarHeight),
            Container(
              height: appBar.preferredSize.height,
              child: Row(
                children: [
                  Container(
                    height: appBar.preferredSize.height,
                    width: appBar.preferredSize.height,
                    child: IconButton(
                        icon: Icon(FeatherIcons.arrowLeft),
                        onPressed: () => Navigator.pop(context)),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        operatorName().toString().tr(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: appBar.preferredSize.height,
                    width: appBar.preferredSize.height,
                    child: IconButton(
                      icon: Icon(FeatherIcons.check),
                      onPressed: () {
                        if (priceText.text.isEmpty) {
                          showErrorSnackbar(context, 'Enter offer price');
                        } else if (validityText.text.isEmpty) {
                          showErrorSnackbar(context, 'Enter validity');
                        } else if (titleText.text.isEmpty) {
                          showErrorSnackbar(context, 'Enter offer title');
                        } else if (descriptionText.text.isEmpty) {
                          showErrorSnackbar(context, 'Enter offer description');
                        } else if (internetText.text.isEmpty &&
                            talkTimeText.text.isEmpty &&
                            smsText.text.isEmpty) {
                          showErrorSnackbar(context,
                              'You must need to add internet or talk-time or sms');
                        } else {
                          double price;
                          int validity;
                          int internet;
                          int talkTime;
                          int sms;
                          int available;
                          String title;
                          String description;

                          price = double.parse(priceText.text);
                          validity = int.parse(validityText.text.toString());
                          if (internetText.text.isEmpty)
                            internet = 0;
                          else
                            internet = int.parse(internetText.text.toString());

                          if (talkTimeText.text.isEmpty)
                            talkTime = 0;
                          else
                            talkTime = int.parse(talkTimeText.text.toString());

                          if (smsText.text.isEmpty)
                            sms = 0;
                          else
                            sms = int.parse(smsText.text.toString());

                          if (availableText.text.isEmpty)
                            available = 0;
                          else
                            available =
                                int.parse(availableText.text.toString());

                          title = titleText.text.toString();
                          description = descriptionText.text.toString();

                          firstStep(context, price, validity, internet,
                              talkTime, sms, available, title, description);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                            color: MyColors.layout_divider_color, width: 1),
                      )),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: MyColors.text_third_color),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: priceText,
                                    onChanged: (text) {
                                      if (text.startsWith('0')) {
                                        priceText.clear();
                                      } else {
                                        setState(() {
                                          /*totalPriceString = 'You got ৳' + (int.parse(text) + (5 * int.parse(text) / 100)).toStringAsFixed(int.parse(text) + (5 * int.parse(text) / 100).truncateToDouble() == int.parse(text) + (5 * int.parse(text) / 100)
                                                  ? 0
                                                  : 2);*/
                                          priceText.text.isEmpty
                                              ? totalPriceString = '৳0'
                                              : totalPriceString =
                                                  '৳${(int.parse(text) - ((int.parse(text) * 5) / 100)).toStringAsFixed((int.parse(text) - ((int.parse(text) * 5) / 100)).truncateToDouble() == (int.parse(text) - ((int.parse(text) * 5) / 100)) ? 0 : 2)}';
                                        });
                                      }
                                    },
                                    maxLength: 4,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    cursorColor: Colors.black,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'),
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '৳0',
                                      counterText: '',
                                      hintStyle: TextStyle(
                                          color: MyColors.edit_text_tint_color),
                                    ),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.text_color,
                                        fontSize: 50),
                                    onEditingComplete: () {
                                      node.nextFocus();
                                    },
                                    //controller: ctr2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'You got ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: MyColors.text_third_color),
                                ),
                                Text(
                                  totalPriceString,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.main_color),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  color: MyColors.layout_divider_color,
                                  width: 1),
                              right: BorderSide(
                                  color: MyColors.layout_divider_color,
                                  width: 1),
                            )),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    'Validity',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: MyColors.text_third_color),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: validityText,
                                          maxLength: 3,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          cursorColor: Colors.black,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]'),
                                            ),
                                          ],
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '0',
                                            counterText: '',
                                            hintStyle: TextStyle(
                                                color: MyColors
                                                    .edit_text_tint_color),
                                          ),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: MyColors.text_color,
                                              fontSize: 40),
                                          onEditingComplete: () {
                                            node.nextFocus();
                                          },
                                          //controller: ctr2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Day',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: MyColors.text_third_color),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  color: MyColors.layout_divider_color,
                                  width: 1),
                            )),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    'Internet',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: MyColors.text_third_color),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: internetText,
                                          maxLength: 4,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          cursorColor: Colors.black,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]'),
                                            ),
                                          ],
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '0',
                                            counterText: '',
                                            hintStyle: TextStyle(
                                                color: MyColors
                                                    .edit_text_tint_color),
                                          ),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: MyColors.text_color,
                                              fontSize: 40),
                                          onEditingComplete: () {
                                            node.nextFocus();
                                          },
                                          //controller: ctr2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'GB',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: MyColors.text_third_color),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  color: MyColors.layout_divider_color,
                                  width: 1),
                              right: BorderSide(
                                  color: MyColors.layout_divider_color,
                                  width: 1),
                            )),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    'Talk-time',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: MyColors.text_third_color),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: talkTimeText,
                                          maxLength: 4,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          cursorColor: Colors.black,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]'),
                                            ),
                                          ],
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '0',
                                            counterText: '',
                                            hintStyle: TextStyle(
                                                color: MyColors
                                                    .edit_text_tint_color),
                                          ),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: MyColors.text_color,
                                              fontSize: 40),
                                          onEditingComplete: () {
                                            node.nextFocus();
                                          },
                                          //controller: ctr2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Minute',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: MyColors.text_third_color),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  color: MyColors.layout_divider_color,
                                  width: 1),
                            )),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    'SMS',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: MyColors.text_third_color),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: smsText,
                                          maxLength: 4,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          cursorColor: Colors.black,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]'),
                                            ),
                                          ],
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '0',
                                            counterText: '',
                                            hintStyle: TextStyle(
                                                color: MyColors
                                                    .edit_text_tint_color),
                                          ),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: MyColors.text_color,
                                              fontSize: 40),
                                          onEditingComplete: () {
                                            node.nextFocus();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: MyColors.text_third_color),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Available offer',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: MyColors.text_third_color),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: availableText,
                                        maxLength: 4,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        cursorColor: Colors.black,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]'),
                                          ),
                                        ],
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '0',
                                          counterText: '',
                                          hintStyle: TextStyle(
                                              color: MyColors
                                                  .edit_text_tint_color),
                                        ),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.text_color,
                                            fontSize: 40),
                                        onEditingComplete: () {
                                          node.nextFocus();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: MyColors.text_third_color),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: MyColors.layout_divider_color,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: titleText,
                                  maxLength: 100,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Title',
                                    counterText: '',
                                    hintStyle: TextStyle(
                                        color: MyColors.edit_text_tint_color),
                                  ),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.text_color,
                                      fontSize: 16),
                                  onEditingComplete: () {
                                    node.nextFocus();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: MyColors.layout_divider_color,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: IntrinsicWidth(
                                  child: TextField(
                                    controller: descriptionText,
                                    keyboardType: TextInputType.multiline,
                                    cursorColor: Colors.black,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Description',
                                      counterText: '',
                                      hintStyle: TextStyle(
                                          color: MyColors.edit_text_tint_color),
                                    ),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: MyColors.text_color,
                                        fontSize: 16),
                                    onEditingComplete: () {
                                      node.unfocus();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? operatorName() {
    if (widget.operator == 1) {
      return 'Airtel';
    } else if (widget.operator == 2) {
      return 'Banglalink';
    } else if (widget.operator == 3) {
      return 'Grameenphone';
    } else if (widget.operator == 4) {
      return 'Robi';
    } else if (widget.operator == 5) {
      return 'Teletalk';
    }
  }

  void firstStep(
      BuildContext contextPostActivity,
      double price,
      int validity,
      int internet,
      int talkTime,
      int sms,
      int available,
      String title,
      String description) {
    showDialog(
      context: contextPostActivity,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text(
              'আপনার অফার টি ক্রয়ের আগে কি ক্রয়কারীর নাম্বারে আফার টি চেক করা প্রয়োজন?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                bool unlimited;
                if (available == 0)
                  unlimited = true;
                else
                  unlimited = false;
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (_) => AddPostDialog(
                      contextPostActivity,
                      widget.operator,
                      price,
                      validity,
                      internet,
                      talkTime,
                      sms,
                      available,
                      unlimited,
                      title,
                      description,
                      true),
                );
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                bool unlimited;
                if (available == 0)
                  unlimited = true;
                else
                  unlimited = false;
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (_) => AddPostDialog(
                      contextPostActivity,
                      widget.operator,
                      price,
                      validity,
                      internet,
                      talkTime,
                      sms,
                      available,
                      unlimited,
                      title,
                      description,
                      false),
                );
              },
            )
          ],
        );
      },
    );
  }
}
