import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../../provider/signin_provider.dart';

class UpdateAccount extends StatefulWidget {
  final String uid;

  UpdateAccount({required this.uid});

  @override
  State<UpdateAccount> createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  final email = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final dob = TextEditingController();

  final _scaffoldKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController updateController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController deleteController =
      RoundedLoadingButtonController();

  DateTime selectedDate = DateTime.now();

  Future<void> _ShowData() async {
    final sp = context.read<SignInProvider>();
    await sp.getUserForUpdate(widget.uid);

    email.text = sp.email!;
    name.text = sp.name!;
    phone.text = sp.phone!;
    address.text = sp.address!;
    dob.text = sp.dob!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ShowData();

    print(email.text);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      errorFormatText: 'Ngày không hợp lệ',
      errorInvalidText: 'Ngày không hợp lệ',
      initialEntryMode: DatePickerEntryMode.input,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dob.text = DateFormat("dd/MM/yyyy").format(selectedDate).toString();
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
              Navigator.pop(context);
              // Xử lý khi người dùng nhấn vào icon trở về
            },
          ),
          backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
          centerTitle: true,
          title: const Text(
            'UPDATE ACCOUNT',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Container(
            child: Center(
              child: Form(
                key: _scaffoldKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                            hintText: "Enter email",
                            fillColor: Colors.grey[200],
                            filled: true,
                            enabled: false),
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
                          hintText: "Enter name",
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: TextFormField(
                        keyboardType: TextInputType.datetime,
                        controller: dob,
                        decoration: InputDecoration(
                            hintText: 'DOB',
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context),
                            )),
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
                          await sp.updateProfileAdmin(
                              widget.uid,
                              email.text,
                              name.text,
                              phone.text,
                              address.text,
                              null,
                              dob.text);
                          await Future.delayed(Duration(seconds: 6), () {
                            Navigator.pop(context);
                          });
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
                              'Update information',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    RoundedLoadingButton(
                        controller: deleteController,
                        successColor: Colors.red,
                        color: Colors.red,
                        width: MediaQuery.of(context).size.width * 0.8,
                        elevation: 0,
                        borderRadius: 25,
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      Text('Do you want to remove this user ?'),
                                  content: Text(
                                      'If you remove this users, you can not resotre'),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          await sp.removeUser(widget.uid);
                                          Navigator.pop(context);
                                        },
                                        child: Text("Remove"))
                                  ],
                                );
                              });
                          await Future.delayed(Duration(seconds: 6), () {
                            deleteController.success();
                            Navigator.pop(context);
                          });
                        },
                        child: const Wrap(
                          children: const [
                            Icon(
                              FontAwesomeIcons.deleteLeft,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Delete information',
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
        )));
  }
}
