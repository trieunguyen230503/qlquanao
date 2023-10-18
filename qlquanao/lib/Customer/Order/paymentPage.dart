import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:qlquanao/model/Product.dart';



String name = " ";
String phone = " ";
String address = " ";
String detailAddress = " ";


String formatPrice(int price) {
  final formatter = NumberFormat("#,###");
  return formatter.format(price);
}

int totalAmount = 0;

class PaymentPage extends StatefulWidget {
  final List<Product> danhSach;

  PaymentPage({required this.danhSach});

  @override
  State<PaymentPage> createState() => _PaymentPageState(danhSach: danhSach);
}

class _PaymentPageState extends State<PaymentPage> {
  final List<Product> danhSach;
  _PaymentPageState({required this.danhSach});
  ScrollController _scrollController = ScrollController();

  int? groupValue = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalAmount = 0;
    for(var p in danhSach){
      totalAmount += p.price * p.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thanh toán",
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
                        "Địa chỉ nhận hàng",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddressPage()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Text(
                            "Thay đổi",
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
                      "Lư Thái Qui  |  0888888888",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 6),
                    child: Text(
                      "10 QL22",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 15),
                    child: Text(
                      "Tân Xuân, Hóc Môn, Thành phố Hồ Chí Minh",
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
                "Danh sách sản phẩm",
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
                  itemCount: danhSach.length,
                  itemBuilder: (context, index) {
                    final product = danhSach[index];
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
                                  product.name,
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
                      "Chọn phương thức thanh toán",
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
                    title: Text("Thanh toán khi nhận hàng"),
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
                    title: Text("Thanh toán qua Momo"),
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
                        "Tổng tiền:",
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
                      if(groupValue == 1){
                        print("Thanh toán khi nhận hàng");

                      }
                      else if(groupValue == 2){
                        print("Thanh toán qua Momo");


                      }
                      Fluttertoast.showToast(
                          msg: "Đã đặt hàng",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black45,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
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
                        "Đặt hàng",
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

  void _OrderOnClick(BuildContext context) {
    if(groupValue == 1){
      print("Thanh toán khi nhận hàng");

    }
    else if(groupValue == 2){
      print("Thanh toán qua Momo");


    }

  }
}



class AddressPage extends StatefulWidget {
  @override
  _addressPageState createState() => _addressPageState();
}

class _addressPageState extends State<AddressPage> {
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
          "Thông tin giao hàng",
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
                    labelText: 'Nhập tên người nhận',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                child: TextField(
                  controller: _textPhoneController,
                  decoration: InputDecoration(
                    labelText: 'Nhập số điện thoại',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: DropdownMenu<String>(
                  width: 250,
                  initialSelection: selectedCity,
                  hintText: "Chọn tỉnh/thành phố",
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
                  hintText: "Chọn quận/huyện",
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
                  hintText: "Chọn phường/xã",
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
                    labelText: 'Nhập địa chỉ chi tiết',
                  ),
                ),
              ),

              SizedBox(height: 20), // Khoảng cách giữa ô văn bản và nút
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    name = _textNameController.text;
                    phone = _textPhoneController.text.trim();
                    address = selectedWard + ", " + selectedDistrict + ", " + selectedCity;
                    detailAddress = _textdetailAddressController.text;
                  });
                  Navigator.pop(context);
                  print("name: " + name);
                  print("phone: " + phone);
                  print("address: " + address);
                  print("deAdd: " + detailAddress);
                },
                child: Text('Xác nhận'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



