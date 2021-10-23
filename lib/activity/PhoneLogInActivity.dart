import 'package:arpon_agent/activity/VerifiActivity.dart';
import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/helper/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneLogInActivity extends StatefulWidget {
  PhoneLogInActivity({Key? key}) : super(key: key);

  _PhoneLogInState createState() => _PhoneLogInState();
}

class _PhoneLogInState extends State<PhoneLogInActivity> {
  TextEditingController ctrl = TextEditingController();
  TextEditingController number = new TextEditingController();
  bool? loading = false;

  @override
  void initState() {
    number.text = number.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    ctrl.text = "+88";
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/t5_ragistration.png',
                  width: width / 2.5, height: width / 2.5),
              SizedBox(
                height: 10,
              ),
              Text(
                'Verify Your Number',
                style: TextStyle(
                    color: MyColors.text_color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Container(height: 10),
              Container(
                width: 220,
                child: Text(
                  'Please enter your mobile number to receive a verification code.',
                  style: TextStyle(
                    color: MyColors.text_color,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IntrinsicWidth(
                    child: TextField(
                      enabled: false,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: ctrl,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyColors.text_color,
                          fontSize: 18),
                    ),
                  ),
                  Container(width: 10),
                  IntrinsicWidth(
                    child: TextField(
                      controller: number,
                      maxLength: 11,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]'),
                        ),
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '01XXX-XXXXXX',
                        counterText: '',
                        hintStyle: TextStyle(
                            fontSize: 18, color: MyColors.edit_text_tint_color),
                      ),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyColors.text_color,
                          fontSize: 18),
                      //controller: ctr2,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: 200,
                child: TextButton(
                  child: loading!
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1,
                            ),
                          ),
                        )
                      : Text(
                          "CONTINUE",
                          style: TextStyle(color: Colors.white),
                        ),
                  onPressed: loading!
                      ? null
                      : () {
                          String num = number.text.toString();

                          if (num.isEmpty) {
                            showErrorSnackbar(context, 'Enter mobile number');
                          } else if (num.length != 11) {
                            showErrorSnackbar(context, 'Enter correct number');
                          } else if (!num.startsWith('01')) {
                            showErrorSnackbar(
                                context, 'Number should start with 01');
                          } else {
                            setState(() {
                              loading = true;
                            });
                            firestore
                                .collection('Agent')
                                .doc(num)
                                .get()
                                .then((DocumentSnapshot snapshot) {
                              if (snapshot.exists) {
                                setState(() {
                                  loading = false;
                                });
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => VerifiActivity(num)));
                              } else {
                                setState(() {
                                  loading = false;
                                });
                                showErrorSnackbar(
                                    context, 'Agent not registered');
                              }
                            });
                          }
                        },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(MyColors.main_color),
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => MyColors.ripple_effect_color),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1000),
                            side: BorderSide(
                                width: 2, color: MyColors.main_color))),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
