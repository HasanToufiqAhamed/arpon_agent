import 'package:arpon_agent/activity/AllProductActivity.dart';
import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/list/ProductList.dart';
import 'package:arpon_agent/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeDactiveProduct extends StatefulWidget {
  HomeDactiveProduct({Key? key}) : super(key: key);

  _HomeDactiveProductState createState() => _HomeDactiveProductState();
}

class _HomeDactiveProductState extends State<HomeDactiveProduct> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth=FirebaseAuth.instance;
  bool? moreOffer = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowGlow();
        return true;
      },
      child: FutureBuilder<QuerySnapshot>(
        future: firestore
            .collection('Product')
            .orderBy('time', descending: true)
            .where('uId', isEqualTo: auth.currentUser!.uid)
            .where('activeStatus', isEqualTo: false)
            .limit(20)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
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
            );
          } else {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.data!.size == 0) {
              return Center(child: Text('Empty list', style: TextStyle(color: MyColors.edit_text_tint_color, fontSize: 18),));
            }

            if (snapshot.data!.size == 20) {
              moreOffer = true;
            }
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                    snapshot.data!.docs[index];
                    Product product = Product.fromFirestore(documentSnapshot);
                    return ProductList(product, context);
                  },
                ),
                Visibility(
                  visible: moreOffer! ? true : false,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AllProductActivity(2)
                          ),
                        );
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                                (states) => MyColors.ripple_effect_color),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(1000))),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Load more ...',
                          style: TextStyle(color: MyColors.text_color),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}