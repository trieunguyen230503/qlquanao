import 'package:firebase_database/firebase_database.dart';

class Orders {
  String? _oderID;

  String? get orderID => _oderID;

  String? _userID;

  String? get userID => _userID;

  String? _userName;

  String? get userName => _userName;

  String? _phone;

  String? get phone => _phone;

  String? _address;

  String? get address => _address;

  String? _orderDate;

  String? get oderDate => _orderDate;

  int? _totalamount;

  int? get totalamount => _totalamount;

  bool? _status;

  bool? get status => _status;

  String? _confirm;

  String? get confirm => _confirm;

  bool? _payment = false;

  bool? get payment => _payment;

  Orders(this._oderID, this._userID, this._orderDate, this._totalamount,
      this._confirm, this._userName);

  Orders.full(this._oderID, this._userID, this._userName, this._phone,
      this._address, this._orderDate, this._totalamount, this._status, this._payment);

  Orders.fromSnapshot(DataSnapshot snapshot)
      : _oderID = snapshot.child("orderID").value.toString(),
        _userID = snapshot.child("userID").value.toString(),
        _userName = snapshot.child("userName").value.toString(),
        _phone = snapshot.child("userPhone").value.toString(),
        _address = snapshot.child("userAddress").value.toString(),
        _orderDate = snapshot.child("orderDate").value.toString(),
        _totalamount = int.parse(snapshot.child("totalamount").value.toString()),
        _status = bool.parse(snapshot.child("status").value.toString()),
        _payment = bool.parse(snapshot.child("payment").value.toString());

  toJson() {
    return {
      'orderID': orderID,
      'userID': userID,
      'userName': userName,
      'userPhone': phone,
      'userAddress': address,
      'orderDate': oderDate,
      'totalamount': totalamount,
      'status': status,
      'payment': payment,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'orderID: ' +
        orderID! +
        ' userID: ' +
        userID! +
        ' userName: ' +
        userName! +
        ' userPhone: ' +
        phone! +
        ' userAddress: ' +
        address! +
        ' orderDate: ' +
        oderDate! +
        ' totalamount: ' +
        totalamount!.toString();
  }
}
