import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/helper/helper.dart';
import 'package:arpon_agent/list/OrderListPagination.dart';
import 'package:arpon_agent/model/Order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CancelOrder extends StatefulWidget {
  CancelOrder({Key? key}) : super(key: key);

  @override
  _CancelOrderState createState() => _CancelOrderState();
}

class _CancelOrderState extends State<CancelOrder> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  ScrollController? controller;
  DocumentSnapshot? _lastVisible;
  bool? _isLoading;
  bool? _isLoadingFirst;
  List<DocumentSnapshot> _snap = [];
  List<Order> _data = [];

  @override
  void initState() {
    controller = new ScrollController()..addListener(scrollListener);
    super.initState();
    _isLoading = true;
    _isLoadingFirst=true;
    getData();
  }

  onRefresh() {
    setState(() {
      _snap.clear();
      _data.clear();
      _isLoading = true;
      _lastVisible = null;
      _isLoadingFirst=true;
    });
    getData();
  }

  Future<Null> getData() async {
    QuerySnapshot data;

    if (_lastVisible == null) {
      data = await firestore
          .collection('Order')
          .orderBy('time', descending: true)
          .where('sellerUId', isEqualTo: auth.currentUser!.uid)
          .where('status', isEqualTo: 4)
          .limit(20)
          .get();
    } else {
      data = await firestore
          .collection('Order')
          .orderBy('time', descending: true)
          .where('sellerUId', isEqualTo: auth.currentUser!.uid)
          .where('status', isEqualTo: 4)
          .startAfter([_lastVisible!['time']])
          .limit(20)
          .get();
    }

    if (data != null && data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingFirst =false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => Order.fromFirestore(e)).toList();
        });
      }
    } else {
      setState((){
        _isLoading = false;
        _isLoadingFirst =false;
      });
    }
    return null;
  }

  @override
  void dispose() {
    controller!.removeListener(scrollListener);
    super.dispose();
  }

  void scrollListener() {
    if (!_isLoading!) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        getData();
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        child: _isLoadingFirst!
            ? Center(
            child: CircularProgressIndicator(color: MyColors.text_color))
            : _data.length == 0
            ? Center(
          child: Icon(
            FeatherIcons.alertTriangle,
            size: 50,
            color: MyColors.edit_text_tint_color,
          ),
        )
            : CustomScrollView(
          shrinkWrap: true,
          controller: controller,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  if (index < _data.length) {
                    return OrderListPagination(_data[index], context);
                  }
                },
                childCount: _data.length == 0 ? 20 : _data.length + 1,
              ),
            ),
          ],
        ),
        onRefresh: () async => onRefresh(),
      ),
    );
  }
}