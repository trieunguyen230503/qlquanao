import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/Admin/fragment/CreateStaff.dart';
import 'package:qlquanao/provider/signin_provider.dart';
import 'package:qlquanao/utils/next_screen.dart';

import '../../../model/User.dart';

class MangeAccount extends StatefulWidget {
  const MangeAccount({super.key});

  @override
  State<MangeAccount> createState() => _MangeAccountState();
}

class _MangeAccountState extends State<MangeAccount> {
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
          centerTitle: true,
          title: const Text(
            'ACCOUNT',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  nextScreen(context, CreateStaff());
                },
                child: Text('Create')),
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
                              return Column(
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
                                                20, 0, 0, 0),
                                          ),
                                          Container(
                                            child: Text(user![index].name),
                                            padding: EdgeInsets.fromLTRB(
                                                20, 0, 0, 0),
                                            width: 100,
                                          ),
                                          Container(
                                            child: Text(user![index].phone),
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border(
                                        bottom: BorderSide(color: Colors.grey),
                                      )),
                                      height: 80,
                                    ),
                                    onTap: () {},
                                  )
                                ],
                              );
                            });
                      }
                    },
                  ),
                ))),
          ],
        )));
  }
}
