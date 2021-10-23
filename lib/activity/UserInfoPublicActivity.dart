import 'dart:io';

import 'package:arpon_agent/activity/HomeActivity.dart';
import 'package:arpon_agent/data/my_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'UserInfoPrivetActivity.dart';

class UserInfoPublicActivity extends StatefulWidget {
  UserInfoPublicActivity({Key? key}) : super(key: key);

  _UserInfoPublicState createState() => _UserInfoPublicState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _UserInfoPublicState extends State<UserInfoPublicActivity> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool? loading = false;
  bool? nameError = false;
  String? nameErrorText = 'Enter name';
  TextEditingController fulName = new TextEditingController();
  Color? color;
  FocusNode oneFocus = new FocusNode();
  File? imageFile;
  TextEditingController imageLink = new TextEditingController();
  late AppState state;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    oneFocus.addListener(() {
      setState(() {
        color = oneFocus.hasFocus ? Colors.black : MyColors.text_third_color;
      });
    });
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: loading!
            ? null
            : () async {
                String name = fulName.text.toString();

                if (name.isEmpty)
                  setState(() {
                    nameError = true;
                    nameErrorText = 'Enter name';
                  });
                else
                  setState(() {
                    nameError = false;
                  });

                if (name.isEmpty)
                  return;
                else if (name.length < 2)
                  setState(() {
                    nameError = true;
                    nameErrorText =
                        'User name must more than 2 character long';
                  });
                else {
                  setState(() {
                    nameError = false;
                    loading = true;
                  });

                  try {
                    final result =
                        await InternetAddress.lookup('example.com');
                    if (result.isNotEmpty &&
                        result[0].rawAddress.isNotEmpty) {
                      if (imageFile == null) {
                        await _firestore
                            .collection('UserAgent')
                            .doc(_auth.currentUser!.uid)
                            .set({
                          'name': name,
                          'uid': _auth.currentUser!.uid,
                          'image': 'n',
                          'token': 'n',
                          'time': FieldValue.serverTimestamp(),
                          'revTotalNumber' : 0,
                          'revNumber' : 0,
                        }).then((va) {
                          setState(() {
                            loading = false;
                          });
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeActivity()), (route) => false);
                        }).catchError((onError) {
                          Fluttertoast.showToast(msg: 'Error');
                          print('sd75ap ' + onError.toString());
                        });
                      } else {
                        var permissionStatus = await Permission.photos.status;

                        if (permissionStatus.isGranted) {
                          if (imageFile != null) {
                            var snapshot = await firebaseStorage
                                .ref()
                                .child('userImage/' +
                                _auth.currentUser!.uid +
                                '/userImage')
                                .putFile(imageFile!);
                            var downloadUrl = await snapshot.ref.getDownloadURL();

                            await _firestore
                                .collection('UserAgent')
                                .doc(_auth.currentUser!.uid)
                                .set({
                              'name': name,
                              'uid': _auth.currentUser!.uid,
                              'image': downloadUrl,
                              'token': 'n',
                              'time': FieldValue.serverTimestamp(),
                              'revTotalNumber' : 0,
                              'revNumber' : 0,
                            }).then((va) {
                              setState(() {
                                loading = false;
                              });
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeActivity()), (route) => false);
                            }).catchError((onError) {
                              Fluttertoast.showToast(msg: 'Error');
                              print('12121a ' + onError.toString());
                            });
                          } else {
                            print('No Image Path Received');
                          }
                        } else {
                          print(
                              'Permission not granted. Try Again with permission access');
                        }
                      }
                    }
                  } on SocketException catch (_) {
                    setState(() {
                      loading = false;
                    });
                  }

                  _firestore
                      .collection('UserAgentSecretInformation')
                      .doc(_auth.currentUser!.uid)
                      .set({
                    'name': name,
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => UserInfoPublicActivity()),
                        (route) => false);
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Fluttertoast.showToast(msg: 'as774a ' + error.toString());
                  });
                }
              },
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
            : Icon(FeatherIcons.arrowRight),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            SizedBox(height: statusBarHeight),
            Container(
              height: appBar.preferredSize.height,
              child: Center(
                child: Text(
                  'Personal info',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'This information can view all users of arpon',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyColors.text_color, fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 25),
                      Stack(
                        children: [
                          imageFile == null
                              ? Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Icon(
                                      FeatherIcons.user,
                                      color: Colors.white,
                                      size: 90,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: MyColors.layout_divider_color,
                                    borderRadius: BorderRadius.circular(120),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(120),
                                  child: Image.file(
                                    imageFile!,
                                    height: 120,
                                    width: 120,
                                  ),
                                ),
                          Positioned.fill(
                            bottom: 0,
                            right: 0,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white70, width: 1),
                                  borderRadius: BorderRadius.circular(120),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: InkWell(
                                    onTap: () {
                                      _pickImage();
                                    },
                                    child: Icon(
                                      FeatherIcons.edit2,
                                      color: MyColors.main_color,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        focusNode: oneFocus,
                        controller: fulName,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          errorText: nameError! ? nameErrorText : null,
                          border: OutlineInputBorder(),
                          labelText: 'User name *',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.layout_divider_color,
                                width: 2.0),
                          ),
                          labelStyle: TextStyle(color: color),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
            /*InkWell(
              onTap: loading!
                  ? null
                  : () {
                      String name = fulName.text.toString();

                      if (name.isEmpty)
                        setState(() {
                          nameError = true;
                          nameErrorText = 'Enter name';
                        });
                      else
                        setState(() {
                          nameError = false;
                        });

                      if (name.isEmpty)
                        return;
                      else if (name.length < 2)
                        setState(() {
                          nameError = true;
                          nameErrorText =
                              'User name must more than 2 character long';
                        });
                      else {
                        setState(() {
                          nameError = false;
                          loading = true;
                        });
                        _firestore
                            .collection('UserAgentSecretInformation')
                            .doc(_auth.currentUser!.uid)
                            .set({
                          'name': name,
                        }).then((value) {
                          setState(() {
                            loading = false;
                          });
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserInfoPublicActivity()),
                              (route) => false);
                        }).onError((error, stackTrace) {
                          setState(() {
                            loading = false;
                          });
                          Fluttertoast.showToast(
                              msg: 'as774a ' + error.toString());
                        });
                      }
                    },
              child: Container(
                color: MyColors.main_color,
                height: appBar.preferredSize.height,
                child: Center(
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
                      : Text(
                          'CONTINUE',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Future<Null> _pickImage() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 8);
    if(pickedImage!=null){
      imageFile = File(pickedImage.path);
      if (imageFile != null) {
        _cropImage();
        setState(() {
          state = AppState.picked;
        });
      }
    }
  }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            cropFrameStrokeWidth: 5,
            backgroundColor: Colors.black,
            statusBarColor: Colors.black,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }
}
