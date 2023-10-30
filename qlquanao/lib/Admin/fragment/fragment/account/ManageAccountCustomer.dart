import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/Admin/fragment/fragment/account/CreateCustomer.dart';

import '../../../../model/User.dart';
import '../../../../provider/signin_provider.dart';
import '../../../../utils/next_screen.dart';
import 'UpdateAccount.dart';

class ManageAccountCustomer extends StatefulWidget {
  const ManageAccountCustomer({super.key});

  @override
  State<ManageAccountCustomer> createState() => _ManageAccountCustomerState();
}

class _ManageAccountCustomerState extends State<ManageAccountCustomer> {
  List<Users>? user = <Users>[];
  double height = 0;

  Future<List<Users>?> _ShowData() async {
    final sp = context.read<SignInProvider>();
    await sp.getAccountUser();
    height = (user!.length * 120)!;
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        user = sp.userCustomer?.reversed.toList();
      });
    });

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () {
                    nextScreen(context, CreateCustomer());
                  },
                  child: Text('Create')),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: height,
                child: FutureBuilder<List<Users>?>(
                  future: _ShowData(),
                  builder: (context, snapshot) {
                    if (user == null) {
                      return Text('no data');
                    } else {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: user?.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                user![index].imageUrl),
                                            radius: 20,
                                          ),
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        ),
                                        Container(
                                          child: Text(
                                            user![index].name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 0, 0),
                                          width: 100,
                                        ),
                                        Container(
                                          child: Text(
                                            user![index].phone,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 0, 0),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      nextScreen(context,
                                          UpdateAccount(uid: user![index].uid));
                                    },
                                  )
                                ],
                              ),
                            );
                          });
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
