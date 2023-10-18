import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/provider/revenue_provider.dart';
import 'package:qlquanao/utils/snack_bar.dart';
import 'package:qlquanao/model/Order.dart';

class ManageRevenue extends StatefulWidget {
  const ManageRevenue({super.key});

  @override
  State<ManageRevenue> createState() => _ManageRevenueState();
}

class _ManageRevenueState extends State<ManageRevenue> {
  final TextEditingController dateStart = TextEditingController();
  final TextEditingController dateEnd = TextEditingController();

  DateTime selectedDate = DateTime.now();
  int? revenue = 0;
  int? countBill = 0;
  List<Orders>? o = <Orders>[];

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

  Future<void> _ShowData() async {
    final ep = context.read<RevenueProvider>();
    await ep.getRevenueAll();

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        revenue = ep.total;
        countBill = ep.countOrder;
        o = ep.order;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Định dạng tiền tệ sử dụng NumberFormat
    NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
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
                          "TOTAL:   ${currencyFormatter.format(revenue)}",
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
                          "QUANTITY:   ${countBill.toString()}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 15,
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
                height: 15,
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
              Container(
                width: 75,
                height: 45,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () async {
                    if (dateStart.text != null && dateEnd.text != null) {
                      final ep = context.read<RevenueProvider>();
                      await ep.getRevenue(dateStart.text, dateEnd.text);
                      revenue = await ep.total;
                      o = await ep.order;
                      countBill = await ep.countOrder;

                      setState(() {});
                    } else {
                      openSnackbar(context, "Fill date", Colors.red);
                    }
                  },
                  child: Text('Find'),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: FutureBuilder(
                    future: _ShowData(),
                    builder: (context, snapshot) {
                      if (o?.length == 0) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          child: Image.network(
                              'https://static.thenounproject.com/png/4143644-200.png'),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: o?.length,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // Canh giữa theo chiều ngang
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Container(
                                        child: Text(
                                          o![index].oderDate.toString(),
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
                                          "${currencyFormatter.format(o![index].totalamount)}",
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
                                          o![index].status.toString(),
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
                              );
                            });
                      }
                    }),
              )
            ],
          ),
        )));
  }
}
