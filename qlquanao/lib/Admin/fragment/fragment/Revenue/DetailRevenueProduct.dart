import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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

  List<ProductSizeColor>? productSizeColorlist = <ProductSizeColor>[];
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
      });
    }
  }

  String? productname;
  bool check = true;
  double height = 0;

  Future<void> _ShowData() async {
    final ep = context.read<RevenueProvider>();
    String? pID = await widget.productID;
    if (check == true) {
      //Lấy tất cả orderitem để duyệt
      await ep.getOrderItemAll();
      await ep.getProductSizeColor(pID);
      await ep.getProductSizeColorRevenue();
    } else {
      await ep.getOrderItemAll();
      await ep.getProductSizeColor(pID);
      await ep.getProductSizeColorRevenueByTime(dateStart.text, dateEnd.text);
    }

    height = productSizeColorlist!.length * 70;
    t = Timer(Duration(seconds: 2), () {
      setState(() {
        productSizeColorlist = ep.productSizeColorlist;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    t?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
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
                  Container(
                    width: 75,
                    height: 45,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () async {
                        if (dateStart.text != null && dateEnd.text != null) {
                          check = false;
                        } else {
                          openSnackbar(context, "Fill date", Colors.red);
                        }
                      },
                      child: Text('Find'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    width: 120,
                    height: 45,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orangeAccent),
                      ),
                      onPressed: () async {
                        check = true;
                        dateEnd.text = "";
                        dateStart.text = "";
                      },
                      child: Text(
                        'All the time',
                        style: TextStyle(color: Colors.black),
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
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: productSizeColorlist!.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Container(
                                height: 50,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // Canh giữa theo chiều ngang
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      child: Text(
                                        widget.nameProduct.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      width: 50,
                                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    )),
                                    Expanded(
                                        child: Container(
                                      child: Text(
                                        productSizeColorlist![index]
                                            .sizeID
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      width: 10,
                                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    )),
                                    Expanded(
                                        child: Container(
                                      child: Text(
                                        productSizeColorlist![index]
                                            .colorID
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      width: 10,
                                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    )),
                                    Expanded(
                                        child: Container(
                                      child: Text(
                                        "${currencyFormatter.format(productSizeColorlist![index].price)}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      width: 20,
                                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    )),
                                  ],
                                ),
                              ),
                            );
                          });
                    }),
              ),
            ],
          ),
        )));
  }
}
