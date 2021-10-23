import 'package:arpon_agent/activity/ProductActive.dart';
import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/helper/SendNotification.dart';
import 'package:arpon_agent/helper/flutter_statusbarcolor.dart';
import 'package:arpon_agent/list/OrderStateList.dart';
import 'package:arpon_agent/model/Order.dart';
import 'package:arpon_agent/model/OrderState.dart';
import 'package:arpon_agent/model/Product.dart';
import 'package:arpon_agent/model/UserInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:arpon_agent/activity/HomeActivity.dart';

import 'HomeActivity.dart';
import 'UserInfoPrivetActivity.dart';

class OrderActivity extends StatefulWidget {
  String orderId;
  String productId;

  OrderActivity(this.orderId, this.productId);

  _OrderState createState() => _OrderState();
}

class _OrderState extends State<OrderActivity> {
  int reviewCount = 0;
  int reviewTotal = 0;
  int count = 0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Order? order;
  TextEditingController number = new TextEditingController();
  bool emptyNumber = false;
  int vatPercent = 0;
  double totalVat = 0;
  String? uniqueCode;
  int stateOne = 0;
  int stateTwo = 0;
  int stateThree = 0;
  int stateFour = 0;
  List<OrderState?>? list = [];
  Product? product;
  String? userToken;

  void onItemClick(int index, OrderState obj) {
    Fluttertoast.showToast(msg: "News " + index.toString() + "clicked");
  }

  @override
  void initState() {
    super.initState();
    readProductInfo();
  }

  void readProductInfo() {
    firestore.collection('Product').doc(widget.productId).get().then((value) {
      setState(() {
        product = Product.fromFirestore(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: statusBarHeight),
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: firestore.collection('Order').doc(widget.orderId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                order = Order.fromFirestore(snapshot.data);

                if (order!.status == 0 ||
                    order!.status == 1 ||
                    order!.status == 2 ||
                    order!.status == 3) {
                  if (!order!.confirm! &&
                      !order!.payment! &&
                      !order!.send! &&
                      !order!.received!) {
                    stateOne = 2;
                    stateTwo = 3;
                    stateThree = 3;
                    stateFour = 3;
                  } else if (order!.confirm! &&
                      !order!.payment! &&
                      !order!.send! &&
                      !order!.received!) {
                    stateOne = 1;
                    stateTwo = 2;
                    stateThree = 3;
                    stateFour = 3;
                  } else if (order!.confirm! &&
                      order!.payment! &&
                      !order!.send! &&
                      !order!.received!) {
                    stateOne = 1;
                    stateTwo = 1;
                    stateThree = 2;
                    stateFour = 3;
                  } else if (order!.confirm! &&
                      order!.payment! &&
                      order!.send! &&
                      !order!.received!) {
                    stateOne = 1;
                    stateTwo = 1;
                    stateThree = 1;
                    stateFour = 2;
                  } else if (order!.confirm! &&
                      order!.payment! &&
                      order!.send! &&
                      order!.received!) {
                    stateOne = 1;
                    stateTwo = 1;
                    stateThree = 1;
                    stateFour = 1;
                  }
                } else {
                  stateOne = 4;
                  stateTwo = 4;
                  stateThree = 4;
                  stateFour = 4;
                }

                String? title;
                if (order!.payment!) {
                  if (order!.paymentFrom == 1) {
                    title = 'Payment by BKash';
                  } else if (order!.paymentFrom == 2) {
                    title = 'Payment by Nagad';
                  } else if (order!.paymentFrom == 3) {
                    title = 'Payment by SSLCommerz';
                  }
                } else {
                  title = 'Make payment';
                }

                list!.insert(
                    0,
                    new OrderState(
                        stateOne,
                        'Order confirm',
                        order!.confirmDate == null
                            ? order!.time
                            : order!.confirmDate));
                list!.insert(
                    1,
                    new OrderState(
                        stateTwo,
                        title!,
                        order!.paymentDate == null
                            ? order!.confirmDate
                            : order!.paymentDate));
                list!.insert(
                    2,
                    new OrderState(
                        stateThree,
                        'Send by seller',
                        order!.sendDate == null
                            ? order!.paymentDate
                            : order!.sendDate));
                list!.insert(
                    3,
                    new OrderState(
                        stateFour,
                        'Received',
                        order!.receiveDate == null
                            ? order!.sendDate
                            : order!.receiveDate));

                return Column(
                  children: [
                    //title bar
                    Container(
                      height: appBar.preferredSize.height,
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(FeatherIcons.arrowLeft),
                              onPressed: () => Navigator.pop(context)),
                          Text(
                            'Order Details',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 0,
                            ),
                          ),
                          IconButton(
                              icon: Icon(FeatherIcons.moreVertical),
                              onPressed: () {}),
                        ],
                      ),
                    ),

                    //body
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.white,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              //order id & date
                              Container(
                                padding: EdgeInsets.fromLTRB(13, 10, 10, 13),
                                child: Row(
                                  children: [
                                    Text(
                                      'Id',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: MyColors.text_color),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SelectableText(
                                      '#' + widget.orderId,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent[200]),
                                    ),
                                    Expanded(
                                        child: SizedBox(
                                      width: 0,
                                    )),
                                    Text(
                                      DateFormat('dd MMM yyyy')
                                          .format(order!.time!.toDate()),
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: MyColors.text_third_color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              product == null
                                  ? Padding(
                                      padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: MyColors.veryLightWhit,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(8, 13, 15, 13),
                                          child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  height: 85,
                                                  width: 85,
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 15, 15, 15),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(20),
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: MyColors.text_color,
                                                      strokeWidth: 1,
                                                    ),
                                                  ),
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
                                                                    FeatherIcons
                                                                        .globe,
                                                                    color: MyColors
                                                                        .edit_text_tint_color,
                                                                  ),
                                                                  Container(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    '0',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize: 16,
                                                                      color: MyColors
                                                                          .text_color,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    ' GB',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize: 16,
                                                                      color: MyColors
                                                                          .text_color,
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
                                                                    FeatherIcons
                                                                        .phone,
                                                                    color: MyColors
                                                                        .edit_text_tint_color,
                                                                  ),
                                                                  Container(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    '0',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize: 16,
                                                                      color: MyColors
                                                                          .text_color,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    ' Minutes',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize: 16,
                                                                      color: MyColors
                                                                          .text_color,
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
                                                                    FeatherIcons
                                                                        .messageSquare,
                                                                    color: MyColors
                                                                        .edit_text_tint_color,
                                                                  ),
                                                                  Container(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    '0',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize: 16,
                                                                      color: MyColors
                                                                          .text_color,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    ' SMS',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize: 16,
                                                                      color: MyColors
                                                                          .text_color,
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
                                                          color: Colors.white,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  child: Text(
                                                                    '৳0',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize: 20,
                                                                      color: MyColors
                                                                          .text_color,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  getAvailable(
                                                                      false, 0),
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize: 12,
                                                                    color: MyColors
                                                                        .text_color,
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
                                      ),
                                    )
                                  : InkWell(
                                    child: Padding(
                                        padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: MyColors.veryLightWhit,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(8, 13, 15, 13),
                                            child: Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    height: 85,
                                                    width: 85,
                                                    padding: EdgeInsets.fromLTRB(
                                                        10, 15, 15, 15),
                                                    child: SvgPicture.asset(
                                                        getOperatorImage(
                                                            product!.operator!)),
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
                                                                      FeatherIcons
                                                                          .globe,
                                                                      color: MyColors
                                                                          .edit_text_tint_color,
                                                                    ),
                                                                    Container(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      product!
                                                                          .internet
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize: 16,
                                                                        color: MyColors
                                                                            .text_color,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ' GB',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize: 16,
                                                                        color: MyColors
                                                                            .text_color,
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
                                                                      FeatherIcons
                                                                          .phone,
                                                                      color: MyColors
                                                                          .edit_text_tint_color,
                                                                    ),
                                                                    Container(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      product!
                                                                          .talkTime
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize: 16,
                                                                        color: MyColors
                                                                            .text_color,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ' Minutes',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize: 16,
                                                                        color: MyColors
                                                                            .text_color,
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
                                                                      FeatherIcons
                                                                          .messageSquare,
                                                                      color: MyColors
                                                                          .edit_text_tint_color,
                                                                    ),
                                                                    Container(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      product!.sms
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize: 16,
                                                                        color: MyColors
                                                                            .text_color,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ' SMS',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize: 16,
                                                                        color: MyColors
                                                                            .text_color,
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
                                                            color: Colors.white,
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    '৳${product!.price}',
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize: 20,
                                                                      color: MyColors
                                                                          .text_color,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    getAvailable(
                                                                        product!
                                                                            .unlimited!,
                                                                        product!
                                                                            .available!),
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontSize: 12,
                                                                      color: MyColors
                                                                          .text_color,
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
                                        ),
                                      ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductActive(product!.productCode!),
                                  ),
                                ),
                                  ),

                              SizedBox(
                                height: 15,
                              ),

                              //order timeline
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Order Timeline',
                                style: TextStyle(
                                    color: MyColors.text_secondary_color,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),

                              SizedBox(
                                height: 18,
                              ),

                              Row(
                                children: [
                                  SizedBox(
                                    width: 13,
                                  ),
                                  Container(
                                    width: 60,
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color: MyColors.text_color,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                    ),
                                    child: Center(
                                        child: Text(
                                      'Order',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: 0,
                                    ),
                                  ),
                                ],
                              ),

                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  OrderState state = list!.elementAt(index)!;
                                  return OrderStateList(state, context);
                                },
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              Visibility(
                                visible: order!.status == 0 && !order!.confirm!,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 13,
                                    ),
                                    Text(
                                      'Confirm?',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: MyColors.text_color,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        width: 0,
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        //TODO payment option
                                        firestore
                                            .collection('Order')
                                            .doc(order!.orderId)
                                            .update({
                                          'status': 4,
                                          'confirm': false,
                                          'confirmDate':
                                              FieldValue.serverTimestamp(),
                                        }).then((value) {
                                          sendNotification([
                                            userToken!
                                          ], 'Your number is not eligible for this offer. Please try another offer',
                                              'Order cancel #' + widget.orderId);
                                        }).catchError((onError) {
                                          Fluttertoast.showToast(
                                              msg: 'qqu47p ' + onError.toString());
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        'No',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: MyColors.text_color,
                                      disabledColor: MyColors.layout_divider_color,
                                      disabledTextColor: MyColors.main_color,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        //TODO payment option
                                        firestore
                                            .collection('Order')
                                            .doc(order!.orderId)
                                            .update({
                                          'status': 1,
                                          'confirm': true,
                                          'confirmDate':
                                              FieldValue.serverTimestamp(),
                                        }).whenComplete(() {
                                          sendNotification([
                                            userToken!
                                          ], 'You number is eligible for this offer. Please make payment for confirm',
                                              'Order ready #' + widget.orderId);
                                        }).catchError((onError) {
                                          Fluttertoast.showToast(
                                              msg: 'qqu47p ' + onError.toString());
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: MyColors.text_color,
                                      disabledColor: MyColors.layout_divider_color,
                                      disabledTextColor: MyColors.main_color,
                                    ),
                                    SizedBox(
                                      width: 13,
                                    ),
                                  ],
                                ),
                              ),

                              Visibility(
                                visible: order!.status == 1 || order!.status == 2,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 13,
                                    ),
                                    Text(
                                      'Order deliver?',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: MyColors.text_color,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        width: 0,
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: confirmButtonPress(),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: MyColors.text_color,
                                      disabledColor: MyColors.layout_divider_color,
                                      disabledTextColor: MyColors.main_color,
                                    ),
                                    SizedBox(
                                      width: 13,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              //order details
                              Column(
                                children: [
                                  Container(
                                    color: MyColors.layout_divider_color,
                                    padding: EdgeInsets.fromLTRB(13, 20, 13, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: new BorderRadius.only(
                                              topLeft: const Radius.circular(10.0),
                                              topRight:
                                                  const Radius.circular(10.0))),
                                      padding: EdgeInsets.all(13),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Customer and order details',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: MyColors.text_color),
                                              ),
                                              Expanded(
                                                  child: SizedBox(
                                                width: 0,
                                              )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                color: MyColors.main_color,
                                                height: 2,
                                                width: 150,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Order id:',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: MyColors
                                                        .text_secondary_color),
                                              ),
                                              Expanded(
                                                  child: SizedBox(
                                                width: 0,
                                              )),
                                              Text(
                                                '#' + order!.orderId!,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: MyColors.text_color,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'You got:',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: MyColors
                                                        .text_secondary_color),
                                              ),
                                              Expanded(
                                                  child: SizedBox(
                                                width: 0,
                                              )),
                                              Text(
                                                product == null
                                                    ? '৳0'
                                                    : '৳${product!.price! - ((product!.price! * 5) / 100)}'
                                                ,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: MyColors.text_color,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color:
                                                    MyColors.main_color_20_percent,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: SizedBox(
                                                  width: 0,
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 20),
                                                  child: SelectableText(
                                                    order!.receiverNumber!,
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        color: MyColors.text_color,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: SizedBox(
                                                  width: 0,
                                                )),
                                              ],
                                            ),
                                          ),

                                          /*Row(
                                            children: [
                                              Text(
                                                'Receiver number:',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: MyColors
                                                        .text_secondary_color),
                                              ),
                                              Expanded(
                                                  child: SizedBox(
                                                width: 0,
                                              )),
                                              SelectableText(
                                                order.receiverNumber,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: MyColors.text_color,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),*/

                                          SizedBox(
                                            height: 10,
                                          ),
                                          StreamBuilder<DocumentSnapshot>(
                                            stream: firestore
                                                .collection('Product')
                                                .doc(order!.productId)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text('Something went wrong');
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }

                                              Product? _Product =
                                                  Product.fromFirestore(
                                                      snapshot.data!);

                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Operator:',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: MyColors
                                                                .text_secondary_color),
                                                      ),
                                                      Expanded(
                                                          child: SizedBox(
                                                        width: 0,
                                                      )),
                                                      Text(
                                                        getOperator(
                                                                _Product.operator)
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                MyColors.text_color,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          FutureBuilder<DocumentSnapshot>(
                                            future: firestore
                                                .collection('UserCustomer')
                                                .doc(order!.uId)
                                                .get(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text('Something went wrong');
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }

                                              UserInf _Info = UserInf.fromFirestore(
                                                  snapshot.data!);
                                              userToken = _Info.token;

                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Customer:',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: MyColors
                                                                .text_secondary_color),
                                                      ),
                                                      Expanded(
                                                          child: SizedBox(
                                                        width: 0,
                                                      )),
                                                      Text(
                                                        _Info.firstName!,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                MyColors.text_color,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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

  String getAvailable(bool b, int i) {
    if (b)
      return 'Unlimited';
    else
      return i.toString() + ' left';
  }

  String? getOperator(int? operator) {
    if (operator == 1) {
      return 'Airtel';
    } else if (operator == 2) {
      return 'Banglalink';
    } else if (operator == 3) {
      return 'Grameenphone';
    } else if (operator == 4) {
      return 'Robi';
    } else if (operator == 5) {
      return 'Teletalk';
    }
  }

  confirmButtonPress() {
    if (order!.status == 0 && !order!.confirm!) {
      return null;
    } else if ((order!.status == 1 || order!.status == 2) &&
        order!.payment! &&
        order!.send!) {
      return null;
    } else if ((order!.status == 1 || order!.status == 2) &&
        order!.payment! &&
        !order!.send!) {
      return () {
        firestore.collection('Order').doc(order!.orderId).update(
          {
            'send': true,
            'sendDate': FieldValue.serverTimestamp(),
          },
        ).whenComplete(
          () {
            sendNotification([
              userToken!
            ], 'You order is delivered. If you got the offer please make confirm',
                'Order delivered #' + widget.orderId);
          },
        ).catchError(
          (onError) {
            Fluttertoast.showToast(msg: 'qqu47p ' + onError.toString());
          },
        );
      };
    }
  }
}
