import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../../provider/internet_provider.dart';
import '../../../../provider/signin_provider.dart';
import '../../../../utils/snack_bar.dart';

class CreateStaff extends StatefulWidget {
  const CreateStaff({super.key});

  @override
  State<CreateStaff> createState() => _CreateStaffState();
}

class _CreateStaffState extends State<CreateStaff> {
  final RoundedLoadingButtonController registerController =
      RoundedLoadingButtonController();

  final email = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();
  final dob = TextEditingController();

  DateTime selectedDate = DateTime.now();

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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
          centerTitle: true,
          title: const Text(
            'CREATE',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    controller: registerController,
                    successColor: Colors.black,
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width * 0.8,
                    elevation: 0,
                    borderRadius: 25,
                    onPressed: () {
                      registerStaff(context);
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
                          'Register',
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
        ));
  }

  Future registerStaff(BuildContext context) async {
    if (phone.text.isNotEmpty || name.text.isNotEmpty || dob.text.isNotEmpty) {
      if (email.text.contains("@gmail.com")) {
        if (phone.text.length == 10) {
          final sp = context.read<SignInProvider>();
          final ip = context.read<InternetProvider>();
          await ip.checkInternetConnection();

          if (ip.hasInternet == false) {
            openSnackbar(context, "Check your internet connection", Colors.red);
          } else {
            sp.CreateStaffAccount(email.text, name.text, phone.text, dob.text)
                .then((value) async {
              if (value == false) {
                await sp.saveStaffToFireStore();
                openSnackbar(
                    context,
                    "Your data is loading, please wait for a second",
                    Colors.orangeAccent);
                await Future.delayed(Duration(seconds: 6), () {
                  Navigator.pop(context);
                });
                registerController.success();
              } else {
                openSnackbar(
                    context, "This email is used for other staff", Colors.red);
                registerController.reset();
              }
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Your phone number must be 10 character')));
          registerController.reset();
        }
      } else {
        registerController.reset();
        openSnackbar(context, "Fill correct format email", Colors.red);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill full information')));
      registerController.reset();
    }
  }
}
