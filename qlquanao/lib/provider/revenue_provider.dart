import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:qlquanao/model/Order.dart';

class RevenueProvider extends ChangeNotifier {
  String? _oderItemID;

  String? get oderItemID => _oderItemID;

  String? _oderID;

  String? get orderID => _oderID;

  String? _userID;

  String? get userID => _userID;

  String? _orderDate;

  String? get oderDate => _orderDate;

  int? _totalamount;

  int? get totalamount => _totalamount;

  bool? _status;

  bool? get status => _status;

  int? _total = 0;

  int? get total => _total;

  List<Orders>? _order;

  List<Orders>? get order => _order;

  int _countOrder = 0;

  int? get countOrder => _countOrder;

  Future getRevenue(String dateStart, String dateEnd) async {
    DateTime ds = DateFormat("dd/MM/yyyy").parse(dateStart);
    DateTime de = DateFormat("dd/MM/yyyy").parse(dateEnd);
    _order = <Orders>[];
    final DatabaseReference myOrder = FirebaseDatabase.instance.ref("orders");
    await myOrder.onValue.listen((event) async {
      _total = 0;
      _countOrder = 0;
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? data = child.value as Map?;
        if (data != null) {
          DateTime d = DateFormat("dd/MM/yyyy").parse(data['orderdate']);
          if ((d.isAfter(ds) || d.isAtSameMomentAs(ds)) &&
              (d.isBefore(de) || d.isAtSameMomentAs(de))) {
            _countOrder = _countOrder + 1;
            int? t = await data['totalamount'];
            _total = await (_total ?? 0) + (t ?? 0);
            _order?.add(Orders(data["oderID"], data["UserID"],
                data["orderdate"], data["totalamount"], data["status"]));
          }
          print(_total);
        }
      }
    });
  }

  Future getRevenueAll() async {
    _order = <Orders>[];
    final DatabaseReference myOrder = FirebaseDatabase.instance.ref("orders");
    ;
    await myOrder.onValue.listen((event) async {
      _total = 0;
      _countOrder = 0;
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? data = child.value as Map?;
        if (data != null) {
          int? t = await data['totalamount'];
          _total = await (_total ?? 0) + (t ?? 0);
          _countOrder = await _countOrder + 1;
          _order?.add(Orders(data["oderID"], data["UserID"], data["orderdate"],
              data["totalamount"], data["status"]));
          print(_total);
        }
      }
    });
  }
}
