import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/Admin/fragment/fragment/Revenue/DetailRevenueProduct.dart';
import 'package:qlquanao/Customer/Home/Home.dart';
import 'package:qlquanao/model/OrderItem.dart';
import 'package:qlquanao/model/Product.dart';
import 'package:qlquanao/provider/revenue_provider.dart';
import 'package:qlquanao/utils/next_screen.dart';
import 'package:qlquanao/utils/snack_bar.dart';
import 'package:qlquanao/model/Order.dart';

class MangeReveuneProduct extends StatefulWidget {
  const MangeReveuneProduct({super.key});

  @override
  State<MangeReveuneProduct> createState() => _MangeReveuneProductState();
}

class _MangeReveuneProductState extends State<MangeReveuneProduct> {
  final TextEditingController dateStart = TextEditingController();
  final TextEditingController dateEnd = TextEditingController();

  DateTime selectedDate = DateTime.now();
  int revenue = 0;
  int? countProduct = 0;

  //Doanh thu của từng sản phẩm

  //DS SP
  List<Product>? p = <Product>[];
  List<OrderItem>? o = <OrderItem>[];
  List<int>? totalProduct = <int>[];
  bool check = true;
  double height = 0;
  Timer? t;

  Future<void> _selectDate(BuildContext context, int checkOrder) async {
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
        if (checkOrder == 1) {
          dateStart.text =
              DateFormat('dd/MM/yyyy').format(selectedDate).toString();
        } else {
          dateEnd.text =
              DateFormat('dd/MM/yyyy').format(selectedDate).toString();
        }
        DateTime ds = DateFormat("dd/MM/yyyy").parse(dateStart.text);
        DateTime de = DateFormat("dd/MM/yyyy").parse(dateEnd.text);

        if (de.isBefore(ds)) {
          openSnackbar(
              context, "Date end must be higher than date start", Colors.red);
          dateEnd.text = "";
        }
        if (dateStart.text != null && dateEnd.text != null) {
          t?.cancel();
          check = false;
        }
      });
    }
  }

  Future<void> _ShowData() async {
    final ep = context.read<RevenueProvider>();
    //await ep.cleanProductRevenue();
    await ep.getProductAll();
    await ep.getOrderItemAll();
    if (check == true) {
      await ep.getProductRevenue();
    } else {
      await ep.getProductRevenueByTime(dateStart.text, dateEnd.text);
    }
    height = (p!.length * 100)!;
    t = Timer(Duration(seconds: 3), () {
      setState(() {
        countProduct = ep.productList?.length;
        revenue = ep.total!;
        //sản phẩm
        p = ep.productList;
        totalProduct = ep.totalProduct;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    t?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // Định dạng tiền tệ sử dụng NumberFormat
    NumberFormat currencyFormatterUSD =
        NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 120,
                  width: 300,
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromRGBO(110, 237, 237, 1),
                          Color.fromRGBO(80, 175, 248, 1),
                        ]),
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(45, 0, 0, 0),
                        child: Text(
                          "TOTAL:   ${currencyFormatterUSD.format(revenue)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(45, 0, 0, 0),
                        child: Text(
                          "QUANTITY:   ${countProduct.toString()}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: dateStart,
                decoration: InputDecoration(
                    hintText: 'Date start',
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, 1),
                    )),
                readOnly: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: dateEnd,
                decoration: InputDecoration(
                    hintText: 'Date end',
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, 2),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   width: 75,
                  //   height: 45,
                  //   child: ElevatedButton(
                  //     style: ButtonStyle(
                  //       backgroundColor:
                  //           MaterialStateProperty.all(Colors.black),
                  //     ),
                  //     onPressed: () async {
                  //
                  //     },
                  //     child: Text('Find'),
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    width: 120,
                    height: 45,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () async {
                        setState(() {
                          check = true;
                          dateEnd.text = "";
                          dateStart.text = "";
                          t?.cancel();
                        });
                      },
                      child: Text(
                        'All the time',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: height,
                child: FutureBuilder(
                    future: _ShowData(),
                    builder: (context, snapshot) {
                      if (o == []) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          child: Image.network(
                              'https://static.thenounproject.com/png/4143644-200.png'),
                        );
                      } else {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: p?.length,
                            itemBuilder: (context, index) {
                              return Center(
                                  child: InkWell(
                                onTap: () {
                                  nextScreen(
                                      context,
                                      DetailRevenueProduct(
                                        nameProduct: p?[index].name,
                                        productID: p?[index].productId,
                                        url: p?[index].image,
                                      ));
                                },
                                child: Container(
                                  height: 80,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromRGBO(237, 194, 159, 1),
                                          Color.fromRGBO(248, 159, 146, 1),
                                        ]),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // Canh giữa theo chiều ngang
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: CircleAvatar(
                                          child: Image.network(p![index].image),
                                          radius: 20,
                                        ),
                                        width: 90,
                                        height: 60,
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      ),
                                      Expanded(
                                          child: Container(
                                        child: Text(
                                          p![index].name,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        width: 20,
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      )),
                                      Expanded(
                                          child: Container(
                                        child: Text(
                                          "${currencyFormatterUSD.format(p![index].totalRevue)}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        width: 20,
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      )),
                                    ],
                                  ),
                                ),
                              ));
                            });
                      }
                    }),
              )
            ],
          ),
        )));
  }
}
