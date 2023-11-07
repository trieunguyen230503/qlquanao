import 'package:flutter/material.dart';
import 'package:qlquanao/Customer/Home/OrderHistoryPage.dart';
import 'package:qlquanao/utils/Login.dart';
import 'package:qlquanao/utils/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late SharedPreferences logindata;
  late String username = 'Profile';

  @override
  void initState() {
    // TODO: implement initState
    check();
  }

  void check() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username') ?? "Profile";
    });
    print(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          'MEMBERSHIP',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromRGBO(247, 247, 247, 1.0),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            GridView(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              shrinkWrap: true, // Để ListView tự thu gọn dựa trên nội dung
              physics: NeverScrollableScrollPhysics(), // Ngăn cuộn ListView
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.person),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            username,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                    margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderHistoryPage()));
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.history),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Order history'),
                        ],
                      ),
                    ),
                    color: Colors.white,
                    margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  ),
                ),
                InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.settings),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Setting'),
                          ],
                        ),
                      ),
                      color: Colors.white,
                      margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                    ))
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              color: Colors.white70,
              child: ListTile(
                //tileColor: Colors.grey,
                title: Text('Store Locator'),
                trailing: Icon(Icons.keyboard_arrow_right),
                selectedTileColor: Colors.black,
              ),
            ),
            Container(
              color: Colors.white70,
              child: ListTile(
                //tileColor: Colors.grey,
                title: Text('STORE LOCATOR'),
                trailing: Icon(Icons.keyboard_arrow_right),
                selectedTileColor: Colors.black,
              ),
            ),
            Container(
              color: Colors.white70,
              child: ListTile(
                //tileColor: Colors.grey,
                title: Text('GETTING STARTED'),
                trailing: Icon(Icons.keyboard_arrow_right),
                selectedTileColor: Colors.black,
              ),
            ),
            Container(
              color: Colors.white70,
              child: ListTile(
                //tileColor: Colors.grey,
                title: Text('TERM OF USE'),
                trailing: Icon(Icons.keyboard_arrow_right),
                selectedTileColor: Colors.black,
              ),
            ),
            InkWell(
              onTap: () {
                logindata.setBool('login', false);
                logindata.setString('username', '');
                Navigator.pushReplacement(context,
                    new MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
