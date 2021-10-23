import 'package:arpon_agent/activity/PostActivity.dart';
import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/dialogue/AccountBlocked.dart';
import 'package:arpon_agent/dialogue/AccountNotAcctive.dart';
import 'package:arpon_agent/model/AgentActiveInfo.dart';
import 'package:arpon_agent/pages/HomePage.dart';
import 'package:arpon_agent/pages/MePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class HomeActivity extends StatefulWidget {
  HomeActivity({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeActivity> {
  int _currentIndex = 0;
  PageController _pageController = PageController();
  List<IconData> iconList = [FeatherIcons.home, FeatherIcons.user];
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var isSelected = 1;
  AppBar appBar = AppBar();
  int? verifiedStatus;
  bool? loading = true;

  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      updateToken();
      readActiveStatue();
    }
  }

  void readActiveStatue() {
    firestore
        .collection('UserAgentSecretInformation')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      AgentActiveInfo info = AgentActiveInfo.fromFirestore(value);

      setState(() {
        verifiedStatus = info.verified;
        loading = false;
      });
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(index,
        curve: Curves.easeIn, duration: Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 64,
        width: 64,
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            color: MyColors.veryLightWhit),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: FloatingActionButton(
            highlightElevation: 0,
            elevation: 0,
            splashColor: Colors.transparent,
            backgroundColor: MyColors.main_color,
            child: loading!
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1,
                      ),
                    ),
                  )
                : Icon(FeatherIcons.plus),
            onPressed: loading!
                ? null
                : verifiedStatus == 0
                    ? () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              AccountNotAcctive(),
                        );
                      }
                    : verifiedStatus == 2
                        ? () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  AccountBlocked(),
                            );
                          }
                        : () {
                            showSheet(context);
                          },
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: statusBarHeight),
          //title bar
          Container(
            height: appBar.preferredSize.height,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'App Name',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ),

          //home page
          Expanded(
            flex: 1,
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [HomePage(), MePage()],
            ),
          ),

          Container(
            height: appBar.preferredSize.height + 10,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 11,
                    spreadRadius: 1,
                    offset: Offset(0, 3.0))
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  tabItem(1, FeatherIcons.home),
                  SizedBox(width: 64),
                  tabItem(2, FeatherIcons.user),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 25),
                Text(
                  'Select operator',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Select the operator you want to make a offer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black38,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                              color: MyColors.layout_divider_color, width: 1),
                          top: BorderSide(
                              color: MyColors.layout_divider_color, width: 1),
                        )),
                        child: InkWell(
                            hoverColor: MyColors.text_color,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostActivity(1)));
                            },
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(27, 17, 27, 17),
                                child: SvgPicture.asset(
                                    'assets/icons/airtel_colorful.svg'),
                              ),
                            )),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                              color: MyColors.layout_divider_color, width: 1),
                          top: BorderSide(
                              color: MyColors.layout_divider_color, width: 1),
                          left: BorderSide(
                              color: MyColors.layout_divider_color, width: 1),
                          right: BorderSide(
                              color: MyColors.layout_divider_color, width: 1),
                        )),
                        child: InkWell(
                          hoverColor: MyColors.text_color,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostActivity(2)));
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(27, 17, 27, 17),
                            child: SvgPicture.asset(
                                'assets/icons/banglalink_colorful.svg'),
                          ),
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                              color: MyColors.layout_divider_color, width: 1),
                          top: BorderSide(
                              color: MyColors.layout_divider_color, width: 1),
                        )),
                        child: InkWell(
                          hoverColor: MyColors.text_color,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostActivity(3)));
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(27, 17, 27, 17),
                            child: SvgPicture.asset(
                                'assets/icons/grameenphone_colorful.svg'),
                          ),
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                          right: BorderSide(
                              color: MyColors.layout_divider_color, width: 1),
                        )),
                        child: InkWell(
                          hoverColor: MyColors.text_color,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostActivity(4)));
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(27, 17, 27, 17),
                            child: SvgPicture.asset(
                                'assets/icons/robi_colorful.svg'),
                          ),
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                          right: BorderSide(
                              color: MyColors.layout_divider_color, width: 1),
                        )),
                        child: InkWell(
                          hoverColor: MyColors.text_color,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostActivity(5)));
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(27, 17, 27, 17),
                            child: SvgPicture.asset(
                                'assets/icons/teletalk_colorful.svg'),
                          ),
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 0,
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void updateToken() async {
    var deviceState = await OneSignal.shared.getDeviceState();

    if (deviceState == null || deviceState.userId == null) return;

    firestore.collection('UserAgent').doc(auth.currentUser!.uid).update({
      'token': deviceState.userId!,
    }).catchError(
      (onError) {
        Fluttertoast.showToast(msg: '1d5d4   ' + onError.toString());
      },
    );
  }

  Widget tabItem(var pos, var icon) {
    return GestureDetector(
      onTap: () {
        if (isSelected != pos) {
          setState(() {
            isSelected = pos;
            _pageController.animateToPage(pos - 1,
                curve: Curves.easeIn, duration: Duration(milliseconds: 1));
          });
        }
      },
      child: Container(
        width: 45,
        height: 45,
        alignment: Alignment.center,
        decoration: isSelected == pos
            ? BoxDecoration(
                shape: BoxShape.circle, color: MyColors.main_color_40_percent)
            : BoxDecoration(),
        child: Icon(icon,
            color: isSelected == pos
                ? MyColors.main_color
                : MyColors.edit_text_tint_color),
      ),
    );
  }
}
