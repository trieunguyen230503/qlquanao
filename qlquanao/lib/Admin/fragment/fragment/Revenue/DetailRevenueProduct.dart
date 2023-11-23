import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/Customer/Order/CartPage.dart';
import 'package:qlquanao/model/OrderItem.dart';
import 'package:qlquanao/model/ProductSizeColor.dart';
import '../../../../provider/revenue_provider.dart';
import '../../../../utils/snack_bar.dart';

class DetailRevenueProduct extends StatefulWidget {
  String? productID;
  String? nameProduct;
  String? url;

  DetailRevenueProduct(
      {required this.nameProduct, required this.productID, required this.url});

  @override
  State<DetailRevenueProduct> createState() => _DetailRevenueProductState();
}

class _DetailRevenueProductState extends State<DetailRevenueProduct> {
  final TextEditingController dateStart = TextEditingController();
  final TextEditingController dateEnd = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<ProductSizeColor> productSizeColorlist = <ProductSizeColor>[
    ProductSizeColor(
        productID: 'ProductID',
        sizeID: 'getSize',
        colorID: 'getColor',
        price: 0,
        quantity: 2,
        url:
            'https://firebasestorage.googleapis.com/v0/b/qlquanao.appspot.com/o/product_size_color_photo%2FM_Xanh%20ng%E1%BB%8Dc%20b%C3%ADch.jpg?alt=media&token=d5925cc4-b258-4017-bebd-03dae6f9f481'),
    ProductSizeColor(
        productID: 'ProductID',
        sizeID: 'getSize',
        colorID: 'getColor',
        price: 0,
        quantity: 2,
        url:
            'https://firebasestorage.googleapis.com/v0/b/qlquanao.appspot.com/o/product_size_color_photo%2FM_Xanh%20ng%E1%BB%8Dc%20b%C3%ADch.jpg?alt=media&token=d5925cc4-b258-4017-bebd-03dae6f9f481'),
  ];
  Timer? t;

  Future<void> _selectDate(BuildContext context, int check) async {
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
        if (check == 1) {
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

        if (dateEnd.text != "" && dateStart.text != "") {
          getProductSizeColorRevenueByTime(
              dateStart.text, dateEnd.text, widget.productID);
        }
      });
    }
  }

  String? productname;
  bool checkDate = true;
  bool checkRevenue = true;
  double height = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final ep = context.read<RevenueProvider>();
    // ep.cleanProductSizeColor();

    //getListSizeColor();
    getProductSizeColorRevenue(widget.productID);
    // _ShowData();
    // t = Timer(Duration(seconds: 3), () {
    //   setState(() {
    //     print('object');
    //     _ShowData();
    //   });
    // });
  }

  Future<String> getNameById(String id, String node) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('$node/$id/Name');
    DatabaseEvent event = await ref.once();
    String s = event.snapshot.value.toString();
    return s.toString();
  }

  Future<void> getListSizeColor() async {
    final DatabaseReference myOrder =
        await FirebaseDatabase.instance.ref("ProductSizeColor");

    myOrder.onValue.listen((event) async {
      if (productSizeColorlist.isNotEmpty) {
        productSizeColorlist.clear();
      }

      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? data = child.value as Map?;
        if (data?["ProductID"] == widget.productID) {
          String getSize = await getNameById(data?['SizeID'], 'Size');
          String getColor = await getNameById(data?['ColorID'], 'Color');
          setState(() {
            productSizeColorlist.add(ProductSizeColor(
                productID: data?['ProductID'],
                sizeID: getSize,
                colorID: getColor,
                price: 0,
                quantity: data?['Quantity'],
                url: data?['url']));
            height = productSizeColorlist!.length * 120;
          });
        }
      }
    });
  }

  Future getProductSizeColorRevenue(String? pid) async {
    await getListSizeColor();
    final Query myOrder = await FirebaseDatabase.instance
        .ref("orders")
        .orderByChild('status')
        .equalTo(true);

    await myOrder.onValue.listen((event) async {
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? dataOrder = child.value as Map?;

        final Query myOrderItem = await FirebaseDatabase.instance
            .ref("orderItem")
            .orderByChild('orderID')
            .equalTo(dataOrder?["orderID"]);
        await myOrderItem.onValue.listen((event) async {
          for (final child1 in event.snapshot.children) {
            final Map<dynamic, dynamic>? data = child1.value as Map?;
            final Query productSizeColor = await FirebaseDatabase.instance
                .ref("ProductSizeColor")
                .orderByChild('ProductID')
                .equalTo(pid);
            int k = 0;
            await productSizeColor.onValue.listen((event) async {
              for (final child2 in event.snapshot.children) {
                final Map<dynamic, dynamic>? dataProductSizeColor =
                    child2.value as Map?;
                String getSize =
                    await getNameById(dataProductSizeColor?['SizeID'], 'Size');
                String getColor = await getNameById(
                    dataProductSizeColor?['ColorID'], 'Color');
                if (k < productSizeColorlist!.length &&
                    data?['productID'] == dataProductSizeColor?['ProductID'] &&
                    data?['productSize'] == getSize &&
                    data?['productColor'] == getColor) {
                  int subtotal = await data?['subTotal'] ?? 0;
                  int quantity = await data?['quantity'] ?? 0;
                  productSizeColorlist?[k].price =
                      await ((productSizeColorlist?[k].price)! +
                          subtotal * quantity)!;
                  print(productSizeColorlist?[k].price);
                }
                await k++;
              }
            });
          }
        });
      }
    });
    setState(() {});
  }

  Future getProductSizeColorRevenueByTime(
      String DateStart, String DateEnd, String? pid) async {
    DateTime ds = DateFormat("dd/MM/yyyy").parse(DateStart);
    DateTime de = DateFormat("dd/MM/yyyy").parse(DateEnd);
    await getListSizeColor();

    final Query myOrder = await FirebaseDatabase.instance
        .ref("orders")
        .orderByChild('status')
        .equalTo(true);

    await myOrder.onValue.listen((event) async {
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? dataOrder = child.value as Map?;

        final Query myOrderItem = await FirebaseDatabase.instance
            .ref("orderItem")
            .orderByChild('orderID')
            .equalTo(dataOrder?["orderID"]);
        await myOrderItem.onValue.listen((event) async {
          for (final child1 in event.snapshot.children) {
            final Map<dynamic, dynamic>? data = child1.value as Map?;
            List<String>? date = data?['orderDate'].toString().split(" ");
            DateTime d = DateFormat("yyyy-MM-dd").parse(date![0]);

            if ((d.isAfter(ds) || d.isAtSameMomentAs(ds)) &&
                (d.isBefore(de) || d.isAtSameMomentAs(de))) {
              final Query productSizeColor = await FirebaseDatabase.instance
                  .ref("ProductSizeColor")
                  .orderByChild('ProductID')
                  .equalTo(pid);
              int k = 0;
              await productSizeColor.onValue.listen((event) async {
                for (final child2 in event.snapshot.children) {
                  final Map<dynamic, dynamic>? dataProductSizeColor =
                      child2.value as Map?;
                  String getSize = await getNameById(
                      dataProductSizeColor?['SizeID'], 'Size');
                  String getColor = await getNameById(
                      dataProductSizeColor?['ColorID'], 'Color');
                  if (k < productSizeColorlist!.length &&
                      data?['productID'] ==
                          dataProductSizeColor?['ProductID'] &&
                      data?['productSize'] == getSize &&
                      data?['productColor'] == getColor) {
                    // print(dataProductSizeColor?['ProductID']);
                    // print(_productSizeColorlist?[k].productID);
                    // print(getSize);
                    // print(_productSizeColorlist?[k].sizeID);
                    // print(getColor);
                    // print(_productSizeColorlist?[k].colorID);
                    int subtotal = await data?['subTotal'] ?? 0;
                    int quantity = await data?['quantity'] ?? 0;
                    productSizeColorlist?[k].price =
                        await ((productSizeColorlist?[k].price)! +
                            subtotal * quantity)!;
                    print(productSizeColorlist?[k].price);
                  }
                  await k++;
                }
              });
            }
          }
        });
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormatterUSD =
        NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
          centerTitle: true,
          title: const Text(
            'DETAIL PRODUCT REVENUE',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              CircleAvatar(
                child: Image.network(widget.url.toString()),
                radius: 100,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 40,
                child: Text(
                  widget.nameProduct.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
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
                height: 30,
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
                height: 30,
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
                  //       if (dateStart.text != null && dateEnd.text != null) {
                  //         final ep = context.read<RevenueProvider>();
                  //         ep.cleanProductSizeColor();
                  //         _ShowData();
                  //         Future.delayed(Duration(seconds: 3), () {
                  //           setState(() {
                  //             _ShowData();
                  //           });
                  //         });
                  //         checkDate = false;
                  //       } else {
                  //         openSnackbar(context, "Fill date", Colors.red);
                  //       }
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
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(0, 0, 0, 1)),
                      ),
                      onPressed: () async {
                        checkDate = true;
                        dateEnd.text = "";
                        dateStart.text = "";
                        setState(() {
                          // final ep = context.read<RevenueProvider>();
                          // ep.cleanProductSizeColor();
                          // _ShowData();
                          // Future.delayed(Duration(seconds: 3), () {
                          //   setState(() {
                          //     _ShowData();
                          //   });
                          // });
                          getProductSizeColorRevenue(widget.productID);
                          checkDate = true;
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
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: productSizeColorlist!.length,
                    itemBuilder: (context, index) {
                      //List<ProductSizeColor>? p = snapshot.data;
                      return Center(
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 100,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // Canh giữa theo chiều ngang
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 60,
                                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: CircleAvatar(
                                  child: Image.network(
                                      productSizeColorlist![index]
                                          .url
                                          .toString()),
                                  radius: 20,
                                ),
                                padding: EdgeInsets.only(left: 20),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text(
                                  productSizeColorlist![index]
                                      .sizeID
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text(
                                  productSizeColorlist![index]
                                      .colorID
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "${currencyFormatterUSD.format(productSizeColorlist![index].price)}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                padding: EdgeInsets.only(right: 45),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        )));
  }
}
