import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qlquanao/Customer/mainpage.dart';
import 'package:qlquanao/model/Cart.dart';
import 'package:qlquanao/model/Order.dart';
import 'package:qlquanao/model/OrderItem.dart';
import 'package:qlquanao/model/ProductSizeColor.dart';

import '../../provider/signin_provider.dart';

String nameNew = " ";
String phoneNew = " ";
String addressNew = " ";
String detailAddress = " ";
bool tempAddress = false;

int totalAmount = 0;

class PaymentPage extends StatefulWidget {
  final List<Cart> listProduct;

  PaymentPage({required this.listProduct});

  @override
  State<PaymentPage> createState() =>
      _PaymentPageState(listProduct: listProduct);
}

class _PaymentPageState extends State<PaymentPage> {
  final List<Cart> listProduct;
  _PaymentPageState({required this.listProduct});
  ScrollController _scrollController = ScrollController();
  String? uid;
  String? nameDefault;
  String? phoneDefault;
  String? addressDefault;

  List<Map<String, dynamic>> listProductForMap = [];
  List<ProductSizeColorData> listProductSizeColor = [];

  int? groupValue = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalAmount = 0;
    getProductSizeColorFromFirebase();
    for (var p in listProduct) {
      totalAmount += p.price * p.quantity;
    }
    listProductForMap = toMapList(listProduct);

    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreference();
    uid = sp.uid;
    // Kiểm tra nếu name = null hoặc = ' ' thì gán = <Trống>
    nameDefault =
        (sp.name == null || sp.name!.trim().length == 0) ? '<null>' : sp.name!;
    phoneDefault = (sp.phone == null || sp.phone!.trim().length == 0)
        ? '<null>'
        : sp.phone!;
    addressDefault = (sp.address == null || sp.address!.trim().length == 0)
        ? '<null>'
        : sp.address!;
  }

  void getProductSizeColorFromFirebase() async {
    final DatabaseReference databaseRef =
    FirebaseDatabase.instance.ref("ProductSizeColor");

    databaseRef.onValue.listen((event) {
      if (listProductSizeColor.isNotEmpty) {
        listProductSizeColor.clear();
      }
      if(!mounted)
        return;

      for (final snap in event.snapshot.children) {
        ProductSizeColorData p = ProductSizeColorData.fromSnapshot(snap);
        listProductSizeColor.add(p);
      }
      onError:(error) {
        // Error.
      };
    });
  }

  List<Map<String, dynamic>> toMapList(List<Cart> c) {
    List<Map<String, dynamic>> productsAsMap = c.map((product) {
      return {
        "name": product.productName,
        "quantity": product.quantity,
        "price": product.price,
        "currency": "USD"
      };
    }).toList();
    return productsAsMap;
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormatterUSD =
        NumberFormat.currency(locale: 'en_US', symbol: '\$');
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddressPage(listProduct: listProduct)));
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
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text(
                      (tempAddress == false)
                          ? "Name: " + nameDefault!
                          : "Name: " + nameNew,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 4, bottom: 4),
                    child: Text(
                      (tempAddress == false)
                          ? "Phone: " + phoneDefault!
                          : "Phone: " + phoneNew,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 15),
                    child: Text(
                      (tempAddress == false)
                          ? "Address: " + addressDefault!
                          : "Address: " + detailAddress + ", " + addressNew,
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
                                  (product.productName.length > 18)
                                      ? '${product.productName.substring(0, 18)}...' // Hiển thị 'text...' nếu độ dài vượt quá length
                                      : product.productName,
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
                                  currencyFormatterUSD.format(product.price),
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
                    secondary: Icon(Icons.attach_money),
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
                      title: Text("Payment via Paypal"),
                      activeColor: Colors.black45,
                      secondary: Image(
                        image: AssetImage('assets/paypal_logo.png'),
                        height: 50,
                        width: 50,
                      )),
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
                        currencyFormatterUSD.format(totalAmount),
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF4C53A5),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if ((nameDefault == "<null>" ||
                              phoneDefault == "<null>" ||
                              addressDefault == "<null>") &&
                          (nameNew == " " ||
                              phoneNew == " " ||
                              addressNew == " ")) {
                        Fluttertoast.showToast(
                            msg: "Please enter complete personal information!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black45,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        if (groupValue == 1) {
                          _pushOrder(false);

                          _showMyDialog(context);
                        } else if (groupValue == 2) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => PaypalCheckout(
                              sandboxMode: true,
                              clientId:
                                  "AQqddvU4gqYASZShn4Ky2MMHYfI1Vz0c6IoJHJ08qG9QiLg6pzBk-SGZ1TtErD1eZtoiRvgmiyKWpLRY",
                              secretKey:
                                  "ENUgjfPZ2KM-Tfh2_VC1K_UCcJOa8hwgxedM2QmnuYAiowRAOCRBLEFDEum3cBT-ZSJ5WyNoZQGxZtTo",
                              returnURL: "success.snippetcoder.com",
                              cancelURL: "cancel.snippetcoder.com",
                              transactions: [
                                {
                                  "amount": {
                                    "total": '${totalAmount}',
                                    "currency": "USD",
                                    "details": {
                                      "subtotal": '${totalAmount}',
                                      "shipping": '0',
                                      "shipping_discount": 0
                                    }
                                  },
                                  "description":
                                      "The payment transaction description.",
                                  // "payment_options": {
                                  //   "allowed_payment_method":
                                  //       "INSTANT_FUNDING_SOURCE"
                                  // },
                                  "item_list": {
                                    "items": listProductForMap,

                                    // shipping address is not required though
                                    //   "shipping_address": {
                                    //     "recipient_name": "Raman Singh",
                                    //     "line1": "Delhi",
                                    //     "line2": "",
                                    //     "city": "Delhi",
                                    //     "country_code": "IN",
                                    //     "postal_code": "11001",
                                    //     "phone": "+00000000",
                                    //     "state": "Texas"
                                    //  },
                                  }
                                }
                              ],
                              note:
                                  "Contact us for any questions on your order.",
                              onSuccess: (Map params) async {
                                print("onSuccess: $params");
                                _pushOrder(true);
                                _showMyDialog(context);
                              },
                              onError: (error) {
                                print("onError: $error");
                                Navigator.pop(context);
                              },
                              onCancel: () {
                                print('cancelled:');
                              },
                            ),
                          ));
                        }
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

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white, // Set màu nền của Dialog là màu trắng
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Image.asset(
                  'assets/order_success.png',
                  width: 80,
                  height: 80,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Order Success',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Text(
                  'Thank you for your purchase! You can track your order status on your personal page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainPage()));
                  },
                  child: Text(
                    'Return to home page',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _pushOrder(bool paymentOnl) async {
    final ref = FirebaseDatabase.instance.ref();

    //push order lên firebase
    final snapshotOrders = ref.child('orders');
    String? orderID = snapshotOrders.push().key;

    String uAddress = detailAddress + ", " + addressNew;
    DateTime now = DateTime.now();
    String orderDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    Orders order;

    if (tempAddress == true) {
      order = Orders.full(orderID, uid, nameNew, phoneNew, uAddress, orderDate,
          totalAmount, false, paymentOnl);
    } else {
      order = Orders.full(orderID, uid, nameDefault, phoneDefault,
          addressDefault, orderDate, totalAmount, false, paymentOnl);
    }
    snapshotOrders.child(orderID!).set(order.toJson());

    //push orderItem lên firebase
    final snapshotOrderItem = ref.child('orderItem');
    for (var item in listProduct) {
      await _updateQuantity(item);
      String? orderItemID = snapshotOrders.push().key;
      OrderItem o = OrderItem.all(
          orderItemID,
          orderID,
          item.productID,
          item.productName,
          item.image,
          item.size,
          item.color,
          orderDate,
          item.quantity,
          item.price);
      snapshotOrderItem.child(orderItemID!).set(o.toJson());
    }

    //Xóa sp khỏi giỏ hàng
    final DatabaseReference databaseRef =
    FirebaseDatabase.instance.ref("cart");
    for (var c in listProduct) {
      databaseRef.child(c.idCart).remove();
    }
  }

  Future<void> _updateQuantity(Cart productCart) async {
    final DatabaseReference databaseRef =
    FirebaseDatabase.instance.ref("ProductSizeColor");
    print("màu: " + productCart.color);

    String? idColor = await getColorID(productCart.color);
    String? idSize = await getSizeID(productCart.size);

    for(var item in listProductSizeColor){
      String productID = item.productID.toString();
      if (productID == productCart.productID) {
        String size = item.sizeID.toString();
        String color = item.colorID.toString();
        String id  = item.uid.toString();

        // print("size: " + size + "   " + "color: " + color);
        // print("idSize: " + idSize.toString() + "   " + "idColor: " + idColor.toString());

        if(size == idSize && color == idColor){
          print("id: " + id.toString());
          ProductSizeColorData p = ProductSizeColorData(
            uid: item.uid,
            productID: item.productID,
            sizeID: item.sizeID,
            colorID: item.colorID,
            price: item.price,
            quantity: item.quantity! - productCart.quantity,
            url: item.url,
          );
          databaseRef.child(id).set(p.toJson());
        }
      }
    }
  }

  Future<String?> getColorID(String colorName) async {
    String? color;
    try {
      final recentPostsRef = await FirebaseDatabase.instance.ref('Color').orderByChild('Name').equalTo(colorName).once();
      DataSnapshot snapshot = recentPostsRef.snapshot;
      if (snapshot.value != null) {
        color = snapshot.children.first.key.toString();
      } else {
        print("No color data found");
      }
      return color;
    } catch (error) {
      print("Error: $error");
      return color;
    }
  }

  Future<String?> getSizeID(String sizeName) async {
    String? size;
    try {
      final recentPostsRef = await FirebaseDatabase.instance.ref('Size').orderByChild('Name').equalTo(sizeName).once();
      DataSnapshot snapshot = recentPostsRef.snapshot;
      if (snapshot.value != null) {
        size = snapshot.children.first.key.toString();
      } else {
        print("No color data found");
      }
      return size;
    } catch (error) {
      print("Error: $error");
      return size;
    }
  }

}






class AddressPage extends StatefulWidget {
  final List<Cart> listProduct;
  AddressPage({required this.listProduct});

  @override
  _addressPageState createState() =>
      _addressPageState(listProduct: listProduct);
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

  void updateDistrictData(String cityCode) async {
    callAPI(host + "districts/getByProvince?provinceCode=$cityCode&limit=-1")
        .then((data) {
      setState(() {
        districtData = data;
      });
    });
  }

  void updateWardData(String districtCode) async {
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                child: TextField(
                  controller: _textNameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
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
                          String cityCode =
                              selectedCityObject["code"].toString().trim();
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
                        selectedDistrict =
                            value; // Cập nhật giá trị quận/huyện khi người dùng thay đổi

                        // Tìm đối tượng có tên quận/huyện tương ứng và lấy giá trị "code"
                        final selectedDistrictObject = districtData.firstWhere(
                          (item) => item["name_with_type"] == value,
                          orElse: () => null,
                        );

                        if (selectedDistrictObject != null) {
                          String districtCode =
                              selectedDistrictObject["code"].toString().trim();
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
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
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(listProduct: listProduct)));
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
              child: Text(
                'This information will automatically be updated to your account\'s personal information and set as default for subsequent purchases?',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Just this time',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                tempAddress = true;
                nameNew = _textNameController.text;
                phoneNew = _textPhoneController.text.trim();
                addressNew = selectedWard +
                    ", " +
                    selectedDistrict +
                    ", " +
                    selectedCity;
                detailAddress = _textdetailAddressController.text;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PaymentPage(listProduct: listProduct)));
              },
            ),
            Spacer(),
            TextButton(
              child: const Text(
                'Agree',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                tempAddress = false;
                final user = context.read<SignInProvider>();
                user.updateAddress(
                    _textNameController.text,
                    _textPhoneController.text.trim(),
                    _textdetailAddressController.text +
                        ", " +
                        selectedWard +
                        ", " +
                        selectedDistrict +
                        ", " +
                        selectedCity);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PaymentPage(listProduct: listProduct)));
              },
            ),
          ],
        );
      },
    );
  }
}
