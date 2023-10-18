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

  Future<List<Users>?> _ShowData() async {
    final sp = context.read<SignInProvider>();
    await sp.getAccountUser();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        user = sp.userCustomer;
      });
    });

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () {
                  nextScreen(context, CreateCustomer());
                },
                child: Text('Create')),
          ),
          Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: Center(
                  child: Padding(
                padding: EdgeInsets.all(20),
                child: FutureBuilder<List<Users>?>(
                  future: _ShowData(),
                  builder: (context, snapshot) {
                    if (user == null) {
                      return Text('no data');
                    } else {
                      return ListView.builder(
                          itemCount: user?.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    child: Container(
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
                                            padding: EdgeInsets.fromLTRB(
                                                20, 0, 20, 0),
                                          ),
                                          Container(
                                            child: Text(
                                              user![index].name,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            padding: EdgeInsets.fromLTRB(
                                                20, 0, 0, 0),
                                            width: 100,
                                          ),
                                          Container(
                                            child: Text(
                                              user![index].phone,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            padding: EdgeInsets.fromLTRB(
                                                20, 0, 0, 0),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2.0,
                                        ),

                                        //   gradient: LinearGradient(
                                        //       begin: Alignment.topLeft,
                                        //       end: Alignment.bottomRight,
                                        //       colors: [
                                        //         Color.fromRGBO(218, 135, 235, 1),
                                        //         Color.fromRGBO(156, 129, 246, 1),
                                        //       ]),
                                      ),
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                      height: 80,
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
              ))),
        ],
      ),
    ));
  }
}
