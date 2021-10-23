import 'package:arpon_agent/activity/WalletActivity.dart';
import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/model/Balance.dart';
import 'package:arpon_agent/tab/HomeActiveProduct.dart';
import 'package:arpon_agent/tab/HomeDactiveProduct.dart';
import 'package:arpon_agent/tab/HomeWaitingProduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  final FirebaseFirestore? firestore = FirebaseFirestore.instance;
  FirebaseAuth? auth = FirebaseAuth.instance;
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              floating: true,
              pinned: false,
              snap: false,
              expandedHeight: height / 5,
              leading: SizedBox(),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: firestore!
                        .collection('UserAgentSecretInformation')
                        .doc(auth!.currentUser!.uid)
                        .collection('Account')
                        .doc('Balance')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: MyColors.text_color,
                            strokeWidth: 1,
                          ),
                        );
                      }

                      if (!snapshot.data!.exists) {
                        return Center(
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Wrap(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      color: MyColors.main_color,
                                    ),
                                    height: height / 5,
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        Image.asset(
                                          'assets/images/card_back.png',
                                          height: height / 5,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '৳ -',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        'Your balance',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: SizedBox(
                                                      width: 0,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: null,
                                                    child: Text(
                                                      'Wallet',
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .main_color),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  Colors.white),
                                                      overlayColor: MaterialStateColor
                                                          .resolveWith((states) =>
                                                              MyColors
                                                                  .ripple_effect_color),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              side: BorderSide(
                                                                  width: 2,
                                                                  color: MyColors
                                                                      .main_color))),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                      width: 0,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Arpon',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      Balance balance = Balance.fromFirestore(snapshot.data);

                      return Center(
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WalletActivity(),
                                ),
                              ),
                              child: Wrap(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      color: MyColors.main_color,
                                    ),
                                    height: height / 5,
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        Image.asset(
                                          'assets/images/card_back.png',
                                          height: height / 5,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '৳${balance.balance!.toStringAsFixed(balance.balance!.truncateToDouble() == balance.balance ? 0 : 2)}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        'Your balance',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: SizedBox(
                                                      width: 0,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: null,
                                                    child: Text(
                                                      'Wallet',
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .main_color),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  Colors.white),
                                                      overlayColor: MaterialStateColor
                                                          .resolveWith((states) =>
                                                              MyColors
                                                                  .ripple_effect_color),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              side: BorderSide(
                                                                  width: 2,
                                                                  color: MyColors
                                                                      .main_color))),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                      width: 0,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Arpon',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                centerTitle: false,
              ),
            ),
          ];
        },
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              TabBar(
                indicatorColor: MyColors.main_color,
                labelColor: MyColors.main_color,
                labelStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                unselectedLabelColor: MyColors.text_third_color,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 1,
                isScrollable: false,
                tabs: [
                  Tab(text: "Active Offers"),
                  Tab(text: "Dactive Offers"),
                  Tab(text: "Waiting Offers"),
                ],
                controller: _tabController,
              ),
              Expanded(
                flex: 1,
                child: TabBarView(
                  children: [
                    //SellerOfferTab(widget.sellerUid),
                    //SellerReviewTab(widget.sellerUid)
                    HomeActiveProduct(),
                    HomeDactiveProduct(),
                    HomeWaitingProduct(),
                  ],
                  controller: _tabController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
