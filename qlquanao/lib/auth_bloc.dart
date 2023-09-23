import 'dart:async';

import 'database.dart';


class AuthBloc {
  DBHelper dbHelper = new DBHelper();
  StreamController _nameController = new StreamController();
  StreamController _phoneController = new StreamController();
  StreamController _emailController = new StreamController();
  StreamController _passController = new StreamController();
  StreamController _prepassController = new StreamController();

  Stream get nameStream => _nameController.stream;
  Stream get phoneStream => _phoneController.stream;
  Stream get emailStream => _emailController.stream;
  Stream get passStream => _passController.stream;
  Stream get prePassStream => _prepassController.stream;

  bool isValid(String name, String phone, String email, String pass, String prePass) {
    if (name == null || name.length == 0) {
      _nameController.sink.addError("Nhập họ tên");
      return false;
    }
    _nameController.sink.add("");

    if (phone == null || phone.length == 0) {
      _phoneController.sink.addError("Nhập số điện thoại");
      return false;
    }
    _phoneController.sink.add("");

    if (email == null || email.length == 0) {
      _emailController.sink.addError("Nhập email");
      return false;
    }
    _emailController.sink.add("");

    if (pass == null || pass.length < 6) {
      _passController.sink.addError("Mật khẩu phải trên 5 ký tự");
      return false;
    }
    _passController.sink.add("");

    if (prePass != pass) {
      _prepassController.sink.addError("Phải trùng với mật khẩu");
      return false;
    }
    _prepassController.sink.add("");

    return true;
  }

  void errorEmailExist() {
    _emailController.sink.addError("Email đã được sử dụng");
  }

  void dispose() {
    _emailController.close();
    _passController.close();
    _prepassController.close();
  }
}