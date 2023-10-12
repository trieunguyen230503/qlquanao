// import 'dart:io';
// import 'dart:typed_data';
// import 'package:path/path.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:qlquanao/model/User.dart';
// import 'package:sqflite/sqflite.dart';
// import 'dart:async';
//
// class DBHelper {
//   copyDB() async {
//     // Construct a file path to copy database to
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, "User.db");
//     // Only copy if the database doesn't exist
//     if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
//       // Load database from asset and copy
//       ByteData data = await rootBundle.load(join('assets', 'User.db'));
//       List<int> bytes =
//           data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//       // Save copied asset to documents
//       await new File(path).writeAsBytes(bytes);
//     }
//   }
//
//   openDB() async {
//     Directory appDocDir = await getApplicationDocumentsDirectory();
//     String databasePath = join(appDocDir.path, 'User.db');
//     return await openDatabase(databasePath);
//   }
//
//   // Future<List<User>> getUser() async {
//   //   List<User> data = <User>[];
//   //   Database db = await openDB();
//   //
//   //   var list = await db.rawQuery('SELECT * FROM tbluser');
//   //   //var list = await db.query('tblStudent');
//   //   for (var item in list.toList()) {
//   //     data.add(User(
//   //         id: int.parse(item['ID'].toString()),
//   //         UserName: item['UserName'].toString(),
//   //         Password: item['Password'].toString()));
//   //   }
//   //   db.close();
//   //   return data;
//   // }
//
//   //hàm check logup
//   Future<bool> registerDB(String username, String pass) async {
//     Database db = await openDB();
//
//     var list = await db.rawQuery('SELECT * FROM tbluser');
//     for (var item in list.toList()) {
//       if (username.toLowerCase() == item['UserName'].toString().toLowerCase()) {
//         return false;
//       }
//     }
//     final User user = User(UserName: username, Password: pass);
//     db.insert('tbluser', user.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.ignore);
//     db.close();
//     return true;
//   }
//
//   //hàm check login - Khải
//   Future<bool> checkLogin(String username, String password) async {
//     DBHelper dbHelper = DBHelper();
//     Database db = await dbHelper.openDB();
//
//     List<Map<String, dynamic>> result = await db.rawQuery(
//       'SELECT * FROM tbluser WHERE UserName = ? AND Password = ?',
//       [username, password],
//     );
//
//     db.close();
//
//     // Kiểm tra kết quả truy vấn để xác định đăng nhập thành công hay không
//     if (result.length > 0) {
//       return true; // Đăng nhập thành công
//     } else {
//       return false; // Sai tên đăng nhập hoặc mật khẩu
//     }
//   }
//
//   //Hàm update tài khoản
//   Future<bool> updateStudent(String username, String password) async {
//     print(username);
//     print(password);
//     Database db = await openDB();
//     Map<String, String> values = {'UserName': username, 'Password': password};
//     var result = db
//         .update('tbluser', values, where: 'UserName=?', whereArgs: [username]);
//     return true;
//   }
// // Future<int> deleteStudent(int id) async {
// //   Database db = await openDB();
// //   var result = db.delete('Students', where: 'id=?', whereArgs: [id]);
// //   return result;
// // }
// }
