import 'package:arpon_agent/activity/EditAccountActivity.dart';
import 'package:arpon_agent/activity/OrderListActivity.dart';
import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/dialogue/LanguageDialogue.dart';
import 'package:arpon_agent/helper/SendNotification.dart';
import 'package:arpon_agent/model/UserAgentInfo.dart';
import 'package:arpon_agent/widget/star_rating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class MePage extends StatefulWidget {
  MePage({Key? key}) : super(key: key);

  _MeState createState() => _MeState();
}

class _MeState extends State<MePage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? name = '';
  String? image = 'n';
  int? reviewTotal = 0;
  int? reviewCount = 0;

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      _readUserInfo();
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _readUserInfo() async {
    await _firestore
        .collection('UserAgent')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      UserAgentInfo info = UserAgentInfo.fromFirestore(value);

      setState(() {
        name = info.name;
        image = info.image;
        reviewTotal = info.revTotalNumber!;
        reviewCount = info.revNumber!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      image == 'n'
                          ? Container(
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Icon(
                            FeatherIcons.user,
                            color: Colors.white,
                            size: 70,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: MyColors.layout_divider_color,
                          borderRadius: BorderRadius.circular(120),
                        ),
                      )
                          : CachedNetworkImage(
                        imageUrl: image!,
                        imageBuilder: (context, imageProvider) =>
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover),
                              ),
                            ),
                        placeholder: (context, url) => Center(
                            child: SizedBox(
                                height: 100,
                                width: 100,
                                child: CircularProgressIndicator(
                                  color: MyColors.text_color,
                                  strokeWidth: 1,
                                ))),
                        errorWidget: (context, url, error) =>
                            Container(
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Icon(
                                  FeatherIcons.user,
                                  color: Colors.white,
                                  size: 70,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: MyColors.layout_divider_color,
                                borderRadius: BorderRadius.circular(120),
                              ),
                            ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(height: 6),
                      make(reviewCount! / reviewTotal!, reviewTotal!),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(13, 13, 13, 15),
            alignment: Alignment.centerLeft,
            child: Text(
              'Account',
              style: TextStyle(
                  fontSize: 18, color: MyColors.text_secondary_color),
            ),
          ),
          InkWell(
            highlightColor: MyColors.veryLightWhit,
            child: ListTile(
              title: Text(
                'Edit profile',
                style:
                TextStyle(fontSize: 18, color: MyColors.text_color),
              ).tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Icon(FeatherIcons.edit3, size: 20, color: Colors.white),
              ),
              trailing: Icon(FeatherIcons.chevronRight, size: 20,),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditAccountActivity(),
                ),
              );
            },
          ),
          InkWell(
            highlightColor: MyColors.veryLightWhit,
            child: ListTile(
              title: Text(
                'Order',
                style:
                TextStyle(fontSize: 18, color: MyColors.text_color),
              ).tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Icon(FeatherIcons.fileText, size: 20, color: Colors.white),
              ),
              trailing: Icon(FeatherIcons.chevronRight, size: 20,),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderListActivity(),
                ),
              );
            },
          ),
          Container(
            padding: EdgeInsets.fromLTRB(13, 20, 13, 15),
            alignment: Alignment.centerLeft,
            child: Text(
              'Settings',
              style: TextStyle(
                  fontSize: 18, color: MyColors.text_secondary_color),
            ),
          ),
          InkWell(
            highlightColor: MyColors.veryLightWhit,
            child: ListTile(
              title: Text(
                'Get notification',
                style:
                TextStyle(fontSize: 18, color: MyColors.text_color),
              ).tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Icon(FeatherIcons.bell, size: 20, color: Colors.white),
              ),
              trailing: Switch(
                value: true,
                onChanged: (bool) {

                },
                inactiveThumbColor: MyColors.text_color,
                activeColor: MyColors.main_color,
                activeTrackColor: MyColors.ripple_effect_color,
                inactiveTrackColor: MyColors.layout_divider_color,
              ),
            ),
            onTap: () {},
          ),
          InkWell(
            highlightColor: MyColors.veryLightWhit,
            child: ListTile(
              title: Text(
                'language',
                style:
                TextStyle(fontSize: 18, color: MyColors.text_color),
              ).tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Icon(FeatherIcons.globe, size: 20, color: Colors.white),
              ),
              trailing: Text(
                'lan',
                style:
                TextStyle(fontSize: 14, color: MyColors.text_third_color),
              ).tr(),
              onTap: null,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    LanguageDialogue(),
              );
            },
          ),
          InkWell(
            highlightColor: MyColors.veryLightWhit,
            child: ListTile(
              title: Text(
                'Help & info',
                style:
                TextStyle(fontSize: 18, color: MyColors.text_color),
              ).tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Icon(FeatherIcons.helpCircle, size: 20, color: Colors.white),
              ),
              trailing: Icon(FeatherIcons.chevronRight, size: 20,),
            ),
            onTap: () async {
              /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpAndInfoActivity(),
                  ),
                );*/
            },
          ),
          InkWell(
            highlightColor: MyColors.veryLightWhit,
            child: ListTile(
              title: Text(
                'Hotline',
                style:
                TextStyle(fontSize: 18, color: MyColors.text_color),
              ).tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Icon(FeatherIcons.phoneCall, size: 20, color: Colors.white),
              ),
              trailing: SelectableText(
                '+880 123456',
                style:
                TextStyle(fontSize: 18, color: MyColors.text_color),
              ),
            ),
            onTap: () {
              _makePhoneCall('tel:+880123456');
            },
          ),
          FlatButton(
              onPressed: () async {
                var deviceState = await OneSignal.shared.getDeviceState();

                if (deviceState == null || deviceState.userId == null)
                  return;

                print(deviceState.userId!);
                sendNotification(
                    [deviceState.userId!], 'Body text', 'Title');
              },
              child: Text('click')),
          FlatButton(
              onPressed: () async {
                _auth.signOut();
              },
              child: Text('log out')),
        ],
      ),
    );
  }

  Widget make(double d, int i) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StarRating(
              starCount: 5,
              rating: d,
              color: Colors.orange[300],
              size: 30,
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              d.isNaN ? '0' : d.toStringAsFixed(1),
              style: TextStyle(
                  color: MyColors.text_color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              ' (' + i.toString() + ')',
              style: TextStyle(
                  color: MyColors.text_third_color,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ],
    );
  }
}
