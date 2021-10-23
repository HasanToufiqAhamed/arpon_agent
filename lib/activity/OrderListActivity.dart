import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/tab/ActiveOrder.dart';
import 'package:arpon_agent/tab/AllOrder.dart';
import 'package:arpon_agent/tab/CancelOrder.dart';
import 'package:arpon_agent/tab/DoneNotPaymentOrder.dart';
import 'package:arpon_agent/tab/DoneOrder.dart';
import 'package:arpon_agent/tab/PendingOrder.dart';
import 'package:arpon_agent/tab/SendNotConformOrder.dart';
import 'package:arpon_agent/tab/WaitingOrder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderListActivity extends StatefulWidget {

  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderListActivity> with SingleTickerProviderStateMixin {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 8, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: statusBarHeight),
          //title bar
          Container(
            child: Row(
              children: [
                IconButton(
                    icon: Icon(FeatherIcons.arrowLeft),
                    onPressed: () => Navigator.pop(context)),
                Text(
                  'Order list',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          TabBar(
            indicatorColor: MyColors.main_color,
            labelColor: MyColors.main_color,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.normal),
            unselectedLabelColor: MyColors.text_third_color,
            indicatorWeight: 1,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: "All"),
              Tab(text: "Waiting"),
              Tab(text: "Pending"),
              Tab(text: "Active"),
              Tab(text: "Send"),
              Tab(text: "Not Payment"),
              Tab(text: "Done"),
              Tab(text: "Cancel"),
            ],
            controller: _tabController,
          ),

          //body
          Expanded(
            flex: 1,
            child: TabBarView(
              children: [
                AllOrder(),
                WaitingOrder(),
                PendingOrder(),
                ActiveOrder(),
                SendNotConformOrder(),
                DoneNotPaymentOrder(),
                DoneOrder(),
                CancelOrder(),
              ],
              controller: _tabController,
            ),
          )
        ],
      ),
    );
  }
}
