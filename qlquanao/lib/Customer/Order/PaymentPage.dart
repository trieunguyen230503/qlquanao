import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qlquanao/Customer/mainpage.dart';
import 'package:qlquanao/model/Cart.dart';
import 'package:qlquanao/model/Order.dart';
import 'package:qlquanao/model/OrderItem.dart';

import '../../provider/signin_provider.dart';



String nameNew = " ";
String phoneNew = " ";
String addressNew = " ";
String detailAddress = " ";
bool tempAddress = false;


String formatPrice(int price) {
  final formatter = NumberFormat("#,###");
  return formatter.format(price);
}

int totalAmount = 0;

class PaymentPage extends StatefulWidget {
  final List<Cart> listProduct;

  PaymentPage({required this.listProduct});

  @override
  State<PaymentPage> createState() => _PaymentPageState(listProduct: listProduct);
}

class _PaymentPageState extends State<PaymentPage> {
  final List<Cart> listProduct;
  _PaymentPageState({required this.listProduct});
  ScrollController _scrollController = ScrollController();
  String? uid;
  String? nameDefault;
  String? phoneDefault;
  String? addressDefault;


  int? groupValue = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalAmount = 0;
    for(var p in listProduct){
      totalAmount += p.price * p.quantity;
    }

    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreference();
    uid = sp.uid;
    // Kiểm tra nếu name = null hoặc = ' ' thì gán = <Trống>
    nameDefault = (sp.name == null || sp.name!.trim().length != 0) ? '<null>' : sp.name!;
    phoneDefault = (sp.phone == null || sp.phone!.trim().length != 0) ? '<null>' : sp.phone!;
    addressDefault = (sp.address == null || sp.address!.trim().length != 0) ? '<null>' : sp.address!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 18,
                        ),
                      ),
                      Text(
                        "Delivery address",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddressPage(listProduct: listProduct)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Text(
                            "Change",
                            style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Text(
                          (tempAddress == false) ? "Name: " + nameDefault! : "Name: " + nameNew,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        (tempAddress == false) ? "  |  Phone: " + phoneDefault! : "  |  Phone: " + phoneNew,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 15),
                    child: Text(
                      (tempAddress == false) ? "Address: " + addressDefault! : "Address: " + detailAddress + ", " + addressNew,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey, // Đổi màu đường gạch thành đỏ
              thickness: 1, // Độ dày của đường gạch
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 15),
              child: Text(
                "List of products",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 8,
                radius: Radius.circular(10),
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: listProduct.length,
                  itemBuilder: (context, index) {
                    final product = listProduct[index];
                    return Container(
                      height: 110,
                      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            margin: EdgeInsets.only(right: 10),
                            child: Image.network(product.image),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.productName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  product.color + ", " + product.size,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4C53A5),
                                  ),
                                ),
                                Text(
                                  formatPrice(product.price) + "đ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "x" + product.quantity.toString().trim(),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Divider(
                  color: Colors.grey, // Đổi màu đường gạch thành đỏ
                  thickness: 1, // Độ dày của đường gạch
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 10, 4),
                  child: Text(
                      "Select a payment method",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: RadioListTile<int>(
                    value: 1,
                    groupValue: groupValue,
                    onChanged: (int? value) {
                      setState(() {
                        groupValue = value;
                      });
                    },
                    title: Text("Payment on delivery"),
                    activeColor: Colors.black45,
                    secondary: Icon(
                        Icons.attach_money
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: RadioListTile<int>(
                    value: 2,
                    groupValue: groupValue,
                    onChanged: (int? value) {
                      setState(() {
                        groupValue = value;
                      });
                    },
                    title: Text("Payment via Momo"),
                    activeColor: Colors.black45,
                    secondary: Image(
                      image: AssetImage('assets/momo_icon_horizontal_pink_RGB.png'),
                      height: 48,
                      width: 48,
                    )
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey, // Đổi màu đường gạch thành đỏ
              thickness: 1, // Độ dày của đường gạch
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              height: 150,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total amount:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatPrice(totalAmount) + "đ",
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF4C53A5),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if((nameDefault == "<null>" || phoneDefault == "<null>" || addressDefault == "<null>") && (nameNew == " " || phoneNew == " " || addressNew == " ")) {
                        Fluttertoast.showToast(
                            msg: "Please enter complete personal information!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black45,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                        }
                      else{
                        if(groupValue == 1){

                          final ref = FirebaseDatabase.instance.ref();

                          //push order lên firebase
                          final snapshotOrders = ref.child('orders');
                          String? orderID = snapshotOrders.push().key;
                          if(uid == null){
                            uid = " ";
                          }
                          String uAddress = detailAddress + ", " + addressNew;
                          DateTime now = DateTime.now();
                          String orderDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

                          Orders order = Orders.full(orderID, uid, nameNew, phoneNew, uAddress, orderDate, totalAmount, false);
                          snapshotOrders.child(orderID!).set(order.toJson());
                          print("orderID: ${orderID}");


                          //push orderItem lên firebase
                          final snapshotOrderItem = ref.child('orderItem');
                          for(var item in listProduct){
                            String? orderItemID = snapshotOrders.push().key;
                            OrderItem o = OrderItem.all(orderItemID, orderID, item.productID, item.productName, item.image, item.size, item.color, orderDate, item.quantity, item.price);
                            snapshotOrderItem.child(orderItemID!).set(o.toJson());
                          }

                        }
                        else if(groupValue == 2){

                          Fluttertoast.showToast(
                              msg: "Momo payment is not supported yet",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black45,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }

                        _showMyDialog();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 16),
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Order",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.asset('assets/order_success.png',
                  width: 80,
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text('Order Success',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text('Thank you for your purchase! You can track your order status on your personal page.',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes', style: TextStyle(fontSize: 18),),
              onPressed: () {
                final ref = FirebaseDatabase.instance.ref();
                final snapshotCart = ref.child('cart').get();
                final DatabaseReference databaseRef = FirebaseDatabase.instance.ref("cart");
                for(var c in listProduct){
                  databaseRef.child(c.idCart).remove();
                }

                Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
              },
            ),
          ],
        );
      },
    );
  }
}



class AddressPage extends StatefulWidget {
  final List<Cart> listProduct;
  AddressPage({required this.listProduct});

  @override
  _addressPageState createState() => _addressPageState(listProduct: listProduct);
}

class _addressPageState extends State<AddressPage> {
  final List<Cart> listProduct;
  _addressPageState({required this.listProduct});

  String host = "https://vn-public-apis.fpo.vn/";

  List<dynamic> cityData = [];
  List<dynamic> districtData = [];
  List<dynamic> wardData = [];
  String selectedCity = "";
  String selectedDistrict = "";
  String selectedWard = "";

  TextEditingController _textNameController = TextEditingController();
  TextEditingController _textPhoneController = TextEditingController();
  TextEditingController _textdetailAddressController = TextEditingController();


  @override
  void initState() {
    super.initState();
    callAPI(host + "provinces/getAll?limit=-1").then((data) {
      setState(() {
        cityData = data;
      });
    });
  }

  Future<List<dynamic>> callAPI(String api) async {
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body)['data']['data'];
      return responseData;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  void updateDistrictData(String cityCode) async{
    callAPI(host + "districts/getByProvince?provinceCode=$cityCode&limit=-1")
        .then((data) {
      setState(() {
        districtData = data;
      });
    });
  }

  void updateWardData(String districtCode) async{
    callAPI(host + "wards/getByDistrict?districtCode=$districtCode&limit=-1")
        .then((data) {
      setState(() {
        wardData = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shipment Details",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                child: TextField(
                  controller: _textNameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                child: TextField(
                  controller: _textPhoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: DropdownMenu<String>(
                  width: 250,
                  initialSelection: selectedCity,
                  hintText: "Select province/city",
                  // Văn bản mặc định khi không có giá trị nào được chọn
                  onSelected: (value) {
                    setState(() {
                      if (value != null) {
                        selectedCity =
                            value; // Cập nhật giá trị thành phố khi người dùng thay đổi

                        // Tìm đối tượng có tên thành phố tương ứng và lấy giá trị "code"
                        final selectedCityObject = cityData.firstWhere(
                              (item) => item["name_with_type"] == value,
                          orElse: () => null,
                        );

                        if (selectedCityObject != null) {
                          String cityCode = selectedCityObject["code"].toString().trim();
                          print("Code City: " + cityCode);
                          updateDistrictData(cityCode);
                        }
                      }
                    });
                  },
                  dropdownMenuEntries: cityData.map((item) {
                    return DropdownMenuEntry<String>(
                      value: item["name_with_type"].toString(),
                      label: item["name_with_type"],
                    );
                  }).toList(),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: DropdownMenu<String>(
                  width: 250,
                  initialSelection: selectedDistrict,
                  hintText: "Select district",
                  // Văn bản mặc định khi không có giá trị nào được chọn
                  onSelected: (value) {
                    setState(() {
                      if (value != null) {
                        selectedDistrict = value; // Cập nhật giá trị quận/huyện khi người dùng thay đổi

                        // Tìm đối tượng có tên quận/huyện tương ứng và lấy giá trị "code"
                        final selectedDistrictObject = districtData.firstWhere(
                              (item) => item["name_with_type"] == value,
                          orElse: () => null,
                        );

                        if (selectedDistrictObject != null) {
                          String districtCode = selectedDistrictObject["code"].toString().trim();
                          print("Code District: " + districtCode);
                          updateWardData(districtCode);
                        }
                      }
                    });
                  },
                  dropdownMenuEntries: districtData.map((item) {
                    return DropdownMenuEntry<String>(
                      value: item["name_with_type"].toString(),
                      label: item["name_with_type"],
                    );
                  }).toList(),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: DropdownMenu<String>(
                  width: 250,
                  initialSelection: selectedWard,
                  hintText: "Select ward",
                  // Văn bản mặc định khi không có giá trị nào được chọn
                  onSelected: (value) {
                    setState(() {
                      if (value != null) {
                        selectedWard = value;
                      }
                    });
                  },
                  dropdownMenuEntries: wardData.map((item) {
                    return DropdownMenuEntry<String>(
                      value: item["name_with_type"].toString(),
                      label: item["name_with_type"],
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                child: TextField(
                  controller: _textdetailAddressController,
                  decoration: InputDecoration(
                    labelText: 'Enter detailed address',
                  ),
                ),
              ),

              SizedBox(height: 20), // Khoảng cách giữa ô văn bản và nút
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showConfirmDialog();

                    // nameNew = _textNameController.text;
                    // phoneNew = _textPhoneController.text.trim();
                    // addressNew = selectedWard + ", " + selectedDistrict + ", " + selectedCity;
                    // detailAddress = _textdetailAddressController.text;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(listProduct: listProduct)));
                  });
                  print("name: " + nameNew);
                  print("phone: " + phoneNew);
                  print("address: " + addressNew);
                  print("deAdd: " + detailAddress);
                },
                child: Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Set as default address?"),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('This information will automatically be updated to your account\'s personal information and set as default for subsequent purchases?',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Just this time', style: TextStyle(fontSize: 18),),
              onPressed: () {
                tempAddress = true;
                nameNew = _textNameController.text;
                phoneNew = _textPhoneController.text.trim();
                addressNew = selectedWard + ", " + selectedDistrict + ", " + selectedCity;
                detailAddress = _textdetailAddressController.text;
                Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(listProduct: listProduct)));
              },
            ),
            Spacer(),
            TextButton(
              child: const Text('Agree', style: TextStyle(fontSize: 18),),
              onPressed: () {
                tempAddress = false;
                final user = context.read<SignInProvider>();
                user.updateAddress(_textNameController.text, _textPhoneController.text.trim(), _textdetailAddressController.text + ", " + selectedWard + ", " + selectedDistrict + ", " + selectedCity);
                Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(listProduct: listProduct)));
              },
            ),
          ],
        );
      },
    );
  }
}



