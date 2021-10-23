import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/helper/helper.dart';
import 'package:arpon_agent/list/ProductList.dart';
import 'package:arpon_agent/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllProductActivity extends StatefulWidget {
  int? which;

  AllProductActivity(this.which);

  static AnimationController? controller;

  _AllProductState createState() => _AllProductState();
}

class _AllProductState extends State<AllProductActivity>
    with SingleTickerProviderStateMixin {
  AppBar appBar = AppBar();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  ScrollController? controller;
  DocumentSnapshot? _lastVisible;
  bool? _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<Product> _data = [];
  bool? dateAscending = true;
  bool? priceAscending;
  bool? allFilterClears = true;

  @override
  void initState() {
    controller = new ScrollController()..addListener(scrollListener);
    super.initState();
    _isLoading = true;
    getData();
  }

  onRefresh() {
    setState(() {
      _snap.clear();
      _data.clear();
      _isLoading = true;
      _lastVisible = null;
    });
    getData();
  }

  getData() async {
    QuerySnapshot data;

    if (widget.which == 1) {
      if (_lastVisible == null) {
        data = await firestore
            .collection('Product')
            .orderBy('time', descending: true)
            .where('uId', isEqualTo: auth.currentUser!.uid)
            .where('activeStatus', isEqualTo: true)
            .limit(20)
            .get();
      } else {
        data = await firestore
            .collection('Product')
            .orderBy('time', descending: true)
            .where('uId', isEqualTo: auth.currentUser!.uid)
            .where('activeStatus', isEqualTo: true)
            .startAfter([_lastVisible!['time']])
            .limit(20)
            .get();
      }
    } else {
      if (_lastVisible == null) {
        data = await firestore
            .collection('Product')
            .orderBy('time', descending: true)
            .where('uId', isEqualTo: auth.currentUser!.uid)
            .where('activeStatus', isEqualTo: false)
            .limit(20)
            .get();
      } else {
        data = await firestore
            .collection('Product')
            .orderBy('time', descending: true)
            .where('uId', isEqualTo: auth.currentUser!.uid)
            .where('activeStatus', isEqualTo: false)
            .startAfter([_lastVisible!['time']])
            .limit(20)
            .get();
      }
    }

    if (data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => Product.fromFirestore(e)).toList();
        });
      }
    } else {
      setState(() => _isLoading = false);
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

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: statusBarHeight),
          Container(
            height: appBar.preferredSize.height,
            child: Row(
              children: [
                IconButton(
                    icon: Icon(FeatherIcons.arrowLeft),
                    onPressed: () => Navigator.pop(context)),
                Text(
                  widget.which == 1 ? 'All active offers' : 'All deactive offers' ,
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
            child: RefreshIndicator(
              color: MyColors.text_color,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowGlow();
                  return true;
                },
                child: _lastVisible == null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator(
                                color: MyColors.text_color,
                                strokeWidth: 1,
                              ),
                            ),
                          ),
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
                                  return ProductList(_data[index], context);
                                }
                                return Opacity(
                                  opacity: _isLoading! ? 1.0 : 0.0,
                                  child: _lastVisible == null
                                      ? Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: LoadingCard(height: 110),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        )
                                      : Center(
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color:
                                                        MyColors.text_color,
                                                    strokeWidth: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                );
                              },
                              childCount:
                                  _data.length == 0 ? 20 : _data.length + 1,
                            ),
                          ),
                        ],
                      ),
              ),
              onRefresh: () async => onRefresh(),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

bool get isPanelVisible {
  final AnimationStatus status = AllProductActivity.controller!.status;
  return status == AnimationStatus.completed ||
      status == AnimationStatus.forward;
}
