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
  List<Orders>? o;

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

  Future<List<Orders>?> _ShowData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
          centerTitle: true,
          title: const Text(
            'REVENUE',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                controller: dateStart,
                decoration: InputDecoration(
                    hintText: 'Date start',
                    filled: true,
                    fillColor: Colors.white,
                    prefix: Container(
                      width: 50,
                      child: Icon(Icons.calendar_month),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, 1),
                    )),
                readOnly: true,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: dateEnd,
                decoration: InputDecoration(
                    hintText: 'DateEnd',
                    filled: true,
                    fillColor: Colors.white,
                    prefix: Container(
                      width: 50,
                      child: Icon(Icons.calendar_month),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, 2),
                    )),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (dateStart.text != null && dateEnd.text != null) {
                    final ep = context.read<RevenueProvider>();
                    await ep.getRevenue(dateStart.text, dateEnd.text);
                    Future.delayed(Duration(seconds: 2), () {
                      setState(() {
                        revenue = ep.total;
                        o = ep.order;
                      });
                    });
                  } else {
                    openSnackbar(context, "Fill date", Colors.red);
                  }
                },
                child: Text('Test'),
              ),
              Text(revenue.toString()),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: FutureBuilder(
                    future: _ShowData(),
                    builder: (context, snapshot) {
                      if (o == null) {
                        return Container(
                          child: Center(
                            child: Text("No data"),
                          ),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: o?.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // Canh giữa theo chiều ngang
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child:
                                          Text(o![index].orderID.toString())),
                                  Expanded(
                                      child:
                                          Text(o![index].oderDate.toString())),
                                  Expanded(
                                      child: Text(
                                          o![index].totalamount.toString())),
                                  Expanded(
                                      child: Text(o![index].status.toString())),
                                ],
                              );
                            });
                      }
                    }),
              )
            ],
          ),
        ));
  }
}
