import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/helper/ConfirmationSlider.dart';
import 'package:arpon_agent/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductActive extends StatefulWidget {
  String productCode;

  ProductActive(this.productCode);

  _PostActivityState createState() => _PostActivityState();
}

class _PostActivityState extends State<ProductActive> {
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
  String titalPrice = 'Total ৳0';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Product? product;

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
              stream: firestore
                  .collection('Product')
                  .doc(widget.productCode)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                product = Product.fromFirestore(snapshot.data!);

                return Column(
                  children: <Widget>[
                    Container(
                      height: appBar.preferredSize.height,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(FeatherIcons.arrowLeft),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            'Offer',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: appBar.preferredSize.height,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 15),
                                                    child: Text(
                                                      product!.title.toString(),
                                                      maxLines: 1,
                                                      textAlign: TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                                product!.price
                                                                    .toString(),
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
                                                            product!.internet
                                                                    .toString() +
                                                                ' GB',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                            product!.talkTime
                                                                    .toString() +
                                                                ' Minutes',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                            FeatherIcons
                                                                .messageSquare,
                                                            color: Colors.redAccent,
                                                          )),
                                                          Container(width: 10),
                                                          Text(
                                                            product!.sms
                                                                    .toString() +
                                                                ' SMS',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                        product!.validity
                                                            .toString(),
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
                                                            product!.unlimited!,
                                                            product!.available!),
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
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
                                                  product!.description!,
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
                        text: product!.activeStatus!
                            ? 'DACTIVE OFFER'
                            : 'ACTIVE PRODUCT',
                        onConfirmation: () {
                          if (product!.activeStatus!) {
                            firestore
                                .collection('Product')
                                .doc(widget.productCode)
                                .update({
                              'activeStatus': false,
                            }).then((value) {
                              Fluttertoast.showToast(msg: 'Deactivated successfully');
                            }).catchError(
                              (onError) {
                                Fluttertoast.showToast(
                                    msg: 'kfk145 ' + onError.toString());
                              },
                            );
                          } else {
                            firestore
                                .collection('Product')
                                .doc(widget.productCode)
                                .update({
                              'activeStatus': true,
                            }).then((value) {
                              Fluttertoast.showToast(msg: 'Activated successfully');
                            }).catchError(
                              (onError) {
                                Fluttertoast.showToast(
                                    msg: 'klk45a ' + onError.toString());
                              },
                            );
                          }
                        },
                        backgroundColor: Color(0xFFECECEC),
                        backgroundShape: BorderRadius.circular(10),
                        icon: FeatherIcons.arrowRight,
                        foregroundColor: product!.activeStatus!
                            ? MyColors.text_color
                            : MyColors.main_color,
                        foregroundShape: BorderRadius.circular(10),
                        shadow: BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 0,
                          spreadRadius: 0,
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

  String getAvailabelText(bool unlimited, int available) {
    if (unlimited)
      return 'Unlimited';
    else
      return available.toString();
  }
}
