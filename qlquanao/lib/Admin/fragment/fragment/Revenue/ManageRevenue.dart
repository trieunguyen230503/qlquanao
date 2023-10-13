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

  Future<List<Orders>?> _ShowData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            padding: EdgeInsets.fromLTRB(20, 0, 20, 300),
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: FutureBuilder(
                future: _ShowData(),
                builder: (context, snapshot) {
                  if (o?.length == 0) {
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: Image.network('https://static.thenounproject.com/png/4143644-200.png'),
                    );
                  } else {
                    return Center(
                      child:ListView.builder(
                          itemCount: o?.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // Canh giữa theo chiều ngang
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Text(o![index].orderID.toString())),
                                Expanded(
                                    child: Text(o![index].oderDate.toString())),
                                Expanded(
                                    child:
                                    Text(o![index].totalamount.toString())),
                                Expanded(
                                    child: Text(o![index].status.toString())),
                              ],
                            );
                          }),
                    );
                  }
                }),
          )
        ],
      ),
    ));
  }
}
