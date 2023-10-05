import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/utils/ProfilePage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../provider/signin_provider.dart';

class ProfileCustome extends StatefulWidget {
  const ProfileCustome({super.key});

  @override
  State<ProfileCustome> createState() => _ProfileCustomeState();
}

class _ProfileCustomeState extends State<ProfileCustome> {
  PlatformFile? pickedFile;

  final email = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();

  final _scaffoldKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController updateController =
      RoundedLoadingButtonController();

  bool checklogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreference();
    email.text = sp.email!;
    name.text = sp.name!;
    phone.text = sp.phone!;
    address.text = sp.address!;
  }

  Future<void> selectImage() async {
    // Uint8List img = await pickImage(ImageSource.gallery);
    // setState(() {
    //   _image = img;
    // });
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.read<SignInProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
          ),
          // Đổi icon về
          onPressed: () {
            // Xử lý khi người dùng nhấn vào icon trở về
          },
        ),
        backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
        centerTitle: true,
        title: const Text(
          'UPDATE YOUR PROFILE',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
        child: Center(
          child: Form(
            key: _scaffoldKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    pickedFile != null
                        ? ClipOval(
                            child: Container(
                            width: 120.0,
                            height: 120.0,
                            color: Colors.blue,
                            child: Image.file(
                              File(pickedFile!.path!),
                              // Thay đổi đường dẫn hình ảnh của bạn ở đây
                              fit: BoxFit.cover,
                            ),
                          ))
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage:
                                NetworkImage(sp.imageUrl.toString()),
                          ),
                    Positioned(
                      child: IconButton(
                        onPressed: () async {
                          await selectImage();
                        },
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.black,
                        ),
                      ),
                      bottom: -10,
                      left: 80,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: phone,
                    decoration: InputDecoration(
                      hintText: "Enter Phone Number",
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: TextFormField(
                    controller: address,
                    decoration: InputDecoration(
                      hintText: "Enter address",
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                RoundedLoadingButton(
                    controller: updateController,
                    successColor: Colors.black,
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width * 0.8,
                    elevation: 0,
                    borderRadius: 25,
                    onPressed: () async {
                      await sp.updateProfile(email.text, name.text, phone.text,
                          address.text, pickedFile);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()));
                    },
                    child: const Wrap(
                      children: const [
                        Icon(
                          FontAwesomeIcons.registered,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Update your profile',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
