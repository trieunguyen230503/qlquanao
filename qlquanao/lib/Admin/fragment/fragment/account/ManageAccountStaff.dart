import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/Admin/fragment/fragment/account/CreateStaff.dart';
import 'package:qlquanao/Admin/fragment/fragment/account/UpdateAccount.dart';
import 'package:qlquanao/provider/signin_provider.dart';
import 'package:qlquanao/utils/ProfileCustome.dart';
import 'package:qlquanao/utils/next_screen.dart';

import '../../../../model/User.dart';

class MangeAccountStaff extends StatefulWidget {
  const MangeAccountStaff({super.key});

  @override
  State<MangeAccountStaff> createState() => _MangeAccountState();
}

class _MangeAccountState extends State<MangeAccountStaff> {
  List<Users>? user = <Users>[];
  double height = 0;

  Future<List<Users>?> _ShowData() async {
    final sp = context.read<SignInProvider>();
    await sp.getAccountStaff();
    height = (user!.length * 120)!;
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        user = sp.userCustomer?.reversed.toList();
      });
    });

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () {
                    nextScreen(context, CreateStaff());
                  },
                  child: Text('Create')),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: height,
              width: MediaQuery.sizeOf(context).width,
              child: FutureBuilder<List<Users>?>(
                future: _ShowData(),
                builder: (context, snapshot) {
                  if (user == null) {
                    return Text('no data');
                  } else {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: user?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user![index].imageUrl),
                                      radius: 20,
                                    ),
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  ),
                                  Container(
                                    child: Text(
                                      user![index].name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    width: 100,
                                  ),
                                  Container(
                                    child: Text(
                                      user![index].phone,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  ),
                                ],
                              ),
                              onTap: () {
                                nextScreen(context,
                                    UpdateAccount(uid: user![index].uid));
                              },
                            ),
                          );
                        });
                  }
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
