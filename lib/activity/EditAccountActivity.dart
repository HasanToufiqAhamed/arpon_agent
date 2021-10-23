import 'dart:io';
import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/model/UserAgentInfo.dart';
import 'package:arpon_agent/model/UserInfo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditAccountActivity extends StatefulWidget {
  EditAccountActivity();

  _EditAccountActivityState createState() => _EditAccountActivityState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _EditAccountActivityState extends State<EditAccountActivity> {
  AppBar appBar = AppBar();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool emptyFirstName = false;
  bool emptyLastName = false;
  TextEditingController firstName = new TextEditingController();
  TextEditingController imageLink = new TextEditingController();
  final focus = FocusNode();
  FocusNode fNameFocus = new FocusNode();
  TextStyle? labelStyle;
  Color? color;
  late AppState state;
  File? imageFile;
  bool? loading = false;

  @override
  void initState() {
    super.initState();
    getOldDate();
    state = AppState.free;
  }

  getOldDate() async {
    await firestore
        .collection('UserAgent')
        .doc(auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot value) {
      UserAgentInfo _userInfo = UserAgentInfo.fromFirestore(value);
      firstName.text = _userInfo.name!;
      imageLink.text = _userInfo.image!;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    fNameFocus.addListener(() {
      setState(() {
        color = fNameFocus.hasFocus ? Colors.black : MyColors.text_third_color;
      });
    });
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: statusBarHeight),
            Container(
              height: appBar.preferredSize.height,
              child: Row(
                children: [
                  Container(
                    height: appBar.preferredSize.height,
                    width: appBar.preferredSize.height,
                    child: IconButton(
                        icon: Icon(FeatherIcons.arrowLeft),
                        onPressed: () => Navigator.pop(context)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        'Edit account',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: appBar.preferredSize.height,
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            if (imageFile == null)
                              imageLink.text == 'n'
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
                                  : CachedNetworkImage(
                                imageUrl: imageLink.text,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                placeholder: (context, url) => Center(
                                    child: SizedBox(
                                        height: 120,
                                        width: 120,
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
                                          size: 90,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: MyColors.layout_divider_color,
                                        borderRadius: BorderRadius.circular(120),
                                      ),
                                    ),
                              )
                            else
                              ClipRRect(
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
                                    side:
                                    BorderSide(color: Colors.white70, width: 1),
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
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.fromLTRB(13, 0, 13, 10),
                    child: Column(
                      children: [
                        TextFormField(
                          focusNode: fNameFocus,
                          controller: firstName,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            errorText: emptyFirstName ? 'Enter first name' : null,
                            border: OutlineInputBorder(),
                            labelText: 'First name *',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyColors.layout_divider_color, width: 2.0),
                            ),
                            labelStyle: TextStyle(color: color),
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () async {
                              String fname = firstName.text.toString();

                              setState(() {
                                fname.isEmpty
                                    ? emptyFirstName = true
                                    : emptyFirstName = false;
                              });

                              if (fname.isEmpty) {
                                Fluttertoast.showToast(msg: 'Empty');
                              } else {
                                setState(() {
                                  loading = true;
                                });

                                try {
                                  final result =
                                  await InternetAddress.lookup('example.com');
                                  if (result.isNotEmpty &&
                                      result[0].rawAddress.isNotEmpty) {
                                    if (imageFile == null) {
                                      await firestore
                                          .collection('UserAgent')
                                          .doc(auth.currentUser!.uid)
                                          .update({
                                        'name': fname,
                                        'time': FieldValue.serverTimestamp(),
                                      }).then((va) {
                                        setState(() {
                                          loading = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: 'Update successfully');
                                      }).catchError((onError) {
                                        Fluttertoast.showToast(msg: 'Error');
                                        print('sd75ap ' + onError.toString());
                                      });
                                    } else {
                                      var permissionStatus =
                                      await Permission.photos.status;

                                      if (permissionStatus.isGranted) {
                                        if (imageFile != null) {
                                          var snapshot = await firebaseStorage
                                              .ref()
                                              .child('userImage/' +
                                              auth.currentUser!.uid +
                                              '/userImage')
                                              .putFile(imageFile!);
                                          var downloadUrl =
                                          await snapshot.ref.getDownloadURL();

                                          await firestore
                                              .collection('UserAgent')
                                              .doc(auth.currentUser!.uid)
                                              .update({
                                            'name': fname,
                                            'image': downloadUrl,
                                            'time': FieldValue.serverTimestamp(),
                                          }).then((va) {
                                            setState(() {
                                              loading = false;
                                            });
                                            Fluttertoast.showToast(
                                                msg: 'Update successfully');
                                          }).catchError((onError) {
                                            Fluttertoast.showToast(msg: 'Error');
                                            print('sd75ap ' + onError.toString());
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
                              }
                            },
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
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(MyColors.main_color),
                              overlayColor: MaterialStateColor.resolveWith(
                                      (states) => MyColors.ripple_effect_color),
                              shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1000),
                                      side: BorderSide(
                                          width: 2,
                                          color: MyColors.main_color))),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool validPhoneNumber(String p) {
    if (p.startsWith('017') ||
        p.startsWith('013') ||
        p.startsWith('019') ||
        p.startsWith('014') ||
        p.startsWith('016') ||
        p.startsWith('018') ||
        p.startsWith('015'))
      return true;
    else
      return false;
  }

  Future<Null> _pickImage() async {
    final pickedImage = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 8);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      _cropImage();
      setState(() {
        state = AppState.picked;
      });
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

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }
}
