import 'package:arpon_agent/activity/HomeActivity.dart';
import 'package:arpon_agent/activity/UserInfoPrivetActivity.dart';
import 'package:arpon_agent/activity/UserInfoPublicActivity.dart';
import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/helper/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerifiActivity extends StatefulWidget {
  String number;

  VerifiActivity(this.number);

  _VerifiState createState() => _VerifiState();
}

class _VerifiState extends State<VerifiActivity> {
  TextEditingController ctrl = TextEditingController();
  TextEditingController code = new TextEditingController();
  String? _verificationCode;
  FirebaseAuth? auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? loading = false;

  @override
  void initState() {
    super.initState();
    _verifyPhone();
    code.text = code.text;
  }

  void readData() {
    _firestore
        .collection('UserAgentSecretInformation')
        .doc(auth!.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        _firestore
            .collection('UserAgent')
            .doc(auth!.currentUser!.uid)
            .get()
            .then((value2) {
          if (value2.exists) {
            setState(() {
              loading = false;
            });
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeActivity()),
                (route) => false);
          } else {
            setState(() {
              loading = false;
            });
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => UserInfoPublicActivity()),
                (route) => false);
          }
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(msg: 'f4f4sa ' + error.toString());
        });
      } else {
        setState(() {
          loading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => UserInfoPrivetActivity()),
            (route) => false);
      }
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: '15ds7a ' + error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    ctrl.text = "+88";
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/t5_verification.png',
                  width: width / 2.5, height: width / 2.5),
              SizedBox(height: 25),
              Container(
                width: 220,
                child: Text(
                  'OTP has been sent to you on your mobile phone. Please enter it below.',
                  style: TextStyle(
                    color: MyColors.text_color,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              IntrinsicWidth(
                child: TextField(
                  controller: code,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]'),
                    ),
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'XXXXXX',
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
                              color: MyColors.text_color,
                              strokeWidth: 1,
                            ),
                          ),
                        )
                      : Text(
                          'SUBMIT',
                          style: TextStyle(
                              color: MyColors.text_color,
                              fontWeight: FontWeight.bold),
                        ),
                  onPressed: loading!
                      ? null
                      : () async {
                          String num = code.text.toString();

                          if (num.isEmpty) {
                            showErrorSnackbar(context, 'Enter OTP');
                          } else if (num.length != 6) {
                            showErrorSnackbar(context, 'Enter correct OTP');
                          } else {
                            setState(() {
                              loading = true;
                            });
                            {
                              try {
                                await auth!
                                    .signInWithCredential(
                                        PhoneAuthProvider.credential(
                                            verificationId: _verificationCode!,
                                            smsCode: code.text.toString()))
                                    .then((value) async {
                                  if (value.user != null) {
                                    readData();
                                  }
                                });
                              } catch (e) {
                                setState(() {
                                  loading = false;
                                });
                                Fluttertoast.showToast(msg: 'invalid OTP');
                                print(e.toString());
                              }

                              /*PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: _verificationCode,
                                smsCode: code.text.toString());

                        // Sign the user in (or link) with the credential
                        await auth.signInWithCredential(credential).then((value) async {
                          if (value.user != null) {
                            Toast.show('suc', context);
                          }
                        });*/

                              /*final PhoneVerificationCompleted verificationCompleted =
                            (AuthCredential phoneAuthCredential) {
                          auth
                              .signInWithCredential(phoneAuthCredential)
                              .then((UserCredential value) {
                            if (value.user != null) {
                              // Handle loogged in state
                              Toast.show(value.user.uid, context);

                            } else {
                              Toast.show("Error validating OTP, try again", context);
                            }
                          }).catchError((error) {
                            Toast.show("Try again in sometime", context);
                          });
                        };*/
                            }
                          }
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _verifyPhone() async {
    await auth!.verifyPhoneNumber(
      phoneNumber: '+88' + widget.number,
      timeout: Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String? verficationID, int? resendToken) {
        setState(() {
          _verificationCode = verficationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          _verificationCode = verificationID;
        });
      },
    );
  }
}
