import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/dialogue/CashOutDialogue.dart';
import 'package:arpon_agent/list/TransactionList.dart';
import 'package:arpon_agent/model/Balance.dart';
import 'package:arpon_agent/model/CashOut.dart';
import 'package:arpon_agent/model/Transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WalletActivity extends StatefulWidget {
  WalletActivity();

  _WalletActivityState createState() => _WalletActivityState();
}

class _WalletActivityState extends State<WalletActivity> {
  AppBar appBar = AppBar();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Balance? balance;
  CashOut? cashOut;
  bool? haveCashOutRequest = false;
  bool? disableButton = true;

  @override
  void initState() {
    super.initState();
    readCashOutRequest();
  }

  readCashOutRequest() {
    firestore
        .collection('admin')
        .doc('waiting')
        .collection('cashOut')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      cashOut = CashOut.fromFirestore(value);
      setState(() {
        haveCashOutRequest = true;
        disableButton = true;
      });
    }).onError((error, stackTrace) {
      print('paal15 ' + error.toString());
      setState(() {
        disableButton = false;
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
          /*SizedBox(height: statusBarHeight),
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
                      'Wallet',
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
                    icon: Icon(FeatherIcons.clock),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),*/
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: firestore
                        .collection('UserAgentSecretInformation')
                        .doc(auth.currentUser!.uid)
                        .collection('Account')
                        .doc('Balance')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.connectionState !=
                          ConnectionState.active) {
                        return Text('sd');
                      }

                      if (!snapshot.data!.exists) {
                        return Center(
                          child: Text('Not exist'),
                        );
                      }

                      balance = Balance.fromFirestore(snapshot.data!);

                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            color: MyColors.main_color),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/card_back2.png',
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 25, right: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Total balance',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        '৳${balance!.balance!.toStringAsFixed(balance!.balance!.truncateToDouble() == balance!.balance ? 0 : 2)}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                    ],
                                  ),
                                  /*IconButton(
                                    icon: SvgPicture.asset('assets/icons/mail-out.svg'),
                                    onPressed: disableButton!
                                        ? null
                                        : balance!.balance! <= 10
                                            ? () {
                                                Fluttertoast.showToast(
                                                    msg: 'minimum 10 taka');
                                              }
                                            : () {
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      20))),
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          CashOutDialogue(
                                                              balance!,
                                                              context),
                                                );
                                              },
                                  ),*/
                                  OutlinedButton(
                                    onPressed: disableButton!
                                        ? null
                                        : balance!.balance! <= 10
                                            ? () {
                                                Fluttertoast.showToast(
                                                    msg: 'minimum 10 taka');
                                              }
                                            : () {
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      20))),
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          CashOutDialogue(
                                                              balance!,
                                                              context),
                                                );
                                              },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 15, 10, 15),
                                      child: Text(
                                        'Cash Out',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                      ),
                                      side: BorderSide(
                                          width: 1, color: Colors.white54),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection('UserAgentSecretInformation')
                        .doc(auth.currentUser!.uid)
                        .collection('Transaction')
                        .orderBy('time', descending: true)
                        .limit(20)
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

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];
                          Transactions transactions =
                              Transactions.fromFirestore(documentSnapshot);
                          return TransactionList(transactions, context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          haveCashOutRequest!
              ? Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            width: double.infinity,
                            color: MyColors.veryLightWhit,
                            child: Stack(
                              children: [
                                //Container(padding: EdgeInsets.only(left: 5, top: 5), child: SvgPicture.asset(pos==1?'icons/home.svg':pos==2?'icons/heart.svg':pos==3?'icons/bell.svg':'icons/user.svg', color: isSelected == pos ? MyColors.edit_text_tint_color : Colors.white),),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SvgPicture.asset(cashOut!.method == 1
                                      ? 'assets/icons/bkash.svg'
                                      : cashOut!.method == 2
                                          ? 'assets/icons/nagad.svg'
                                          : 'assets/icons/upay.svg'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text('৳ ${cashOut!.amount}'),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                '${DateFormat('dd MMM yyyy (hh:mm a)').format(cashOut!.time!.toDate())}'),
                            SizedBox(
                              height: 10,
                            ),
                            Text(cashOut!.way == 1
                                ? 'Payment'.tr()
                                : 'Send money'.tr()),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        flex: 3,
                      )
                    ],
                  ),
                )
              : SizedBox(
                  width: 0,
                ),
        ],
      ),
    );
  }
}
