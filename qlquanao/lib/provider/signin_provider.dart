import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:qlquanao/model/User.dart';

class SignInProvider extends ChangeNotifier {
  //instance of firebaseauth, facebook and google
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  //hasError, errorCode, provider, uid, email, iamgeURl

  bool _hasError = false;

  bool get hasError => _hasError;

  String? _errorCode;

  String? get errorCode => _errorCode;

  String? _provider;

  String? get provider => _provider;

  String? _uid;

  String? get uid => _uid;

  String? _email;

  String? get email => _email;

  String? _imageUrl;

  String? get imageUrl => _imageUrl;

  String? _name;

  String? get name => _name;

  String? _phone = " ";

  String? get phone => _phone;

  String? _address;

  String? get address => _address;

  String? _password;

  String? get password => _password;

  String? _dob;

  String? get dob => _dob;

  int? _role;

  int? get role => _role;

  List<Users>? _userCustomer;

  List<Users>? get userCustomer => _userCustomer;

  SignInProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("sigined_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();

    s.setBool("sigined_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

//sign in with google
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      //executing our authentication
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        //Lấy token từ firebase
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        //singing to firebase user instance
        final User userDetail =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        //save all values
        _name = userDetail.displayName;
        _email = userDetail.email;
        _imageUrl = userDetail.photoURL;
        _uid = userDetail.uid;
        _provider = "GOOGLE";
        _password = " ";
        _phone = " ";
        _address = " ";
        _dob = " ";
        _role = 3;
      } on FirebaseException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Use correct provider";
            _hasError = true;
            notifyListeners();
            break;
          case "null":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

//sign in with Facebook
  Future signInWithFacebook() async {
    final LoginResult result = await facebookAuth.login();

    //getting profile
    final graphResponse = await http.get(Uri.parse(
        'https://graph.facebook.com/v18.0/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${result.accessToken!.token}'));
    for (int i = 0; i < 10; i++) {
      print(result.accessToken!.token);
    }
    // final graphResponse = await http.get(Uri.parse(
    //     'https://graph.facebook.com/v2.10/${result.accessToken!
    //         .userId}&access_token=${result.accessToken!.token}'));
    final profile = jsonDecode(graphResponse.body);
    if (result.status == LoginStatus.success) {
      try {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        await firebaseAuth.signInWithCredential(credential);
        //saving the value
        if (profile['name'] != null) {
          _name = profile['name'];
        }

        if (profile['email'] != null) {
          _email = profile['email'];
        }
        _imageUrl = profile['picture']['data']['url'];
        _uid = profile['id'];
        _hasError = false;
        _provider = "FACEBOOK";
        _password = " ";
        _phone = " ";
        _address = " ";
        _dob = " ";
        _role = 3;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Use correct provider";
            _hasError = true;
            notifyListeners();
            break;
          case "null":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

//Entry for cloudFireStore
  Future getUserDataFromFirestore(String? uid) async {
    // print(uid);
    // await FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(uid)
    //     .get()
    //     .then((DocumentSnapshot snapshot) => {
    //
    //         });
    print(uid);
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users/$_uid').get();

    final data = snapshot.value as Map<dynamic, dynamic>;

    _name = data['name'];
    _email = data['email'];
    _imageUrl = data['image_url'];
    _provider = data['provider'];
    _phone = data['phone'];
    _address = data['address'];
    _password = data['password'];
    _role = data['role'];
  }

  //Update account trong admin
  Future getUserForUpdate(String? uid) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users/$uid').get();
    final data = await snapshot.value as Map<dynamic, dynamic>;

    _name = data['name'];
    _email = data['email'];
    _imageUrl = data['image_url'];
    _provider = data['provider'];
    _phone = data['phone'];
    _address = data['address'];
    _password = data['password'];
    _role = data['role'];
  }

  //Save dành cho user
  Future saveDateToFirestore() async {
    final DatabaseReference r = FirebaseDatabase.instance.ref("users");
    DatabaseReference newUser = r.push();
    await newUser.set({
      "name": _name,
      "email": _email,
      "uid": newUser.key,
      "image_url": _imageUrl,
      "provider": _provider,
      "password": _password,
      "phone": phone,
      "dob": _dob,
      "address": _address,
      "role": 3,
    });
    notifyListeners();
  }

  //save dành cho staff
  Future saveStaffToFireStore() async {
    final DatabaseReference r = FirebaseDatabase.instance.ref("users");
    DatabaseReference newUser = r.push();
    await newUser.set({
      "name": _name,
      "email": _email,
      "uid": newUser.key,
      "image_url": _imageUrl,
      "provider": _provider,
      "password": _password,
      "phone": _phone,
      "dob": _dob,
      "address": _address,
      "role": _role,
    });
    notifyListeners();
  }

  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString('name', _name!);
    await s.setString('email', _email!);
    await s.setString('uid', _uid!);
    await s.setString('image_url', _imageUrl!);
    await s.setString('provider', _provider!);
    await s.setString("phone", _phone!);
    await s.setString('address', _address!);
    await s.setString('dob', _dob!);

    await s.setString('password', _password!);
    await s.setInt('role', _role!);
    notifyListeners();
  }

//Get data in home screen
  Future getDataFromSharedPreference() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString('name');
    _email = s.getString('email');
    _imageUrl = s.getString('image_url');
    _uid = s.getString('uid');
    _provider = s.getString('provider');
    _phone = s.getString('phone');
    _address = s.getString('address');
    _dob = s.getString('dob');
    _role = s.getInt('role');
    notifyListeners();
  }

//checkUser exists or not in cloudfirestore
  Future<bool> checkUserExists() async {
    // final DatabaseReference myTopPostsQuery =
    //     FirebaseDatabase.instance.ref("users");
    // bool check = false;
    // await myTopPostsQuery.onValue.listen((event) {
    //   for (final child in event.snapshot.children) {
    //     final key = child.key; // Lấy key của child
    //     final value = child.value; // Lấy giá trị của child (là một Map)
    //
    //     // Ví dụ: In thông tin của child
    //     print('Key: $key');
    //     print('Value: $value');
    //
    //     // Nếu bạn biết cụ thể các trường, bạn có thể truy xuất chúng như sau:
    //     if (value != null && value is Map) {
    //       final email = value['email']; // Ví dụ: Truy xuất trường 'name'
    //       print('enail db: $email');
    //       print('enail login: $_email');
    //       if (email == _email) {
    //         print("Existing User");
    //         check = true;
    //         break;
    //       }
    //     }
    //   }
    // }, onError: (error) {
    //   // Error.
    // });
    // return check;
    // print(_email);
    // final ref = FirebaseDatabase.instance.ref();
    // final snapshot = await ref.child("users/$_uid/").get();
    // if (snapshot.exists) {
    //   print("Existing User");
    //   return true;
    // } else {
    //   print("New user");
    //   return false;
    // }

    final ref = FirebaseDatabase.instance.ref("users");

    // Sử dụng orderByChild để truy vấn theo thuộc tính "email"
    final snapshot = await ref.orderByChild("email").equalTo(_email).get();
    //print(snapshot.value);
    // Kiểm tra xem có dữ liệu hay không
    if (snapshot.exists) {
      final Map<dynamic, dynamic>? data = snapshot.value as Map?;
      //print(data['uid']);
      _uid = data?.values.first['uid'];
      print(_uid);
      print("Existing user");
    } else {
      print("New user");
    }
    return snapshot.exists;
  }

  //check email registerW
  Future<bool> checkEmailExists(String email) async {
    final ref = FirebaseDatabase.instance.ref("users");

    // Sử dụng orderByChild để truy vấn theo thuộc tính "email"
    final snapshot = await ref.orderByChild("email").equalTo(email).get();
    //print(snapshot.value);
    if (snapshot.exists) {
      print("Existing User");
      return true;
    } else {
      print("New user");
      return false;
    }
  }

  //Check phone login
  Future<bool> checkEmailLogin(String email, String password) async {
    final ref = FirebaseDatabase.instance.ref("users");

    // Sử dụng orderByChild để truy vấn theo thuộc tính "email"
    final snapshot = await ref.orderByChild("email").equalTo(email).get();
    final Map<dynamic, dynamic>? data = snapshot.value as Map?;

    final e = data?.values.first['email'];
    //MÃ hóa mật khẩu
    final p = data?.values.first['password'];
    String pass = sha512.convert(utf8.encode(password)).toString();

    if (e == email && p == pass) {
      print("Existing User");
      _uid = data?.values.first['uid'];
      _name = data?.values.first['name'];
      _email = data?.values.first['email'];
      _imageUrl = data?.values.first['image_url'];
      _provider = data?.values.first['provider'];
      _phone = data?.values.first['phone'];
      _dob = data?.values.first['dob'];
      _password = data?.values.first['password'];
      _address = data?.values.first['address'];
      _role = data?.values.first['role'];
      return true;
    } else {
      print("New user");
      return false;
    }
    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    //     .collection("users")
    //     .where("email", isEqualTo: email)
    //     .where("password", isEqualTo: password)
    //     .get();
    //
    // if (querySnapshot.docs.isNotEmpty) {
    //   querySnapshot.docs.forEach((document) {
    //     // Lấy dữ liệu từ DocumentSnapshot
    //     _uid = document['uid'];
    //     _name = document['name'];
    //     _email = document['email'];
    //     _imageUrl = document['image_url'];
    //     _provider = document['provider'];
    //     _phone = document['phone'];
    //     _password = document['password'];
    //   });
    //
    //   print("Existing User");
    //
    //   return true;
    // } else {
    //   print("New user");
    //   return false;
    // }
  }

//singout
  Future userSignout() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    _isSignedIn = false;
    notifyListeners();
    await clearStoredData();
  }

  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.clear();
  }

  //Crete account
  void CreateNewAccount(email, name, password, mobile, dob) {
    _name = name;
    _email = email;
    _phone = mobile;
    //MÃ hóa mật khẩu
    _password = sha512.convert(utf8.encode(password.toString())).toString();
    _imageUrl = "https://cdn-icons-png.flaticon.com/512/1946/1946429.png";
    _provider = "PHONE";
    _uid = null;
    _address = "";
    _dob = dob;
    _role = 3;
    notifyListeners();
  }

  //Forget Password

  //Create account Staff cho admin
  Future CreateStaffAccount(email, name, phone, dob) async {
    final ref = FirebaseDatabase.instance.ref("users");
    final snapshot = await ref.orderByChild("email").equalTo(email).get();
    //print(snapshot.value);
    if (snapshot.exists) {
      print("Existing User");
      return true;
    } else {
      _name = name;
      _email = email;
      _phone = phone;
      //MÃ hóa mật khẩu
      _password = sha512.convert(utf8.encode(phone)).toString();
      _imageUrl =
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1UNFMhuAA3TLkPbNSGyD8m5lNyDY2LHe3ig&usqp=CAU";
      _provider = "PHONE";
      _uid = null;
      _dob = dob;
      _address = "";
      _role = 2;
      notifyListeners();
      print("New user");
      return false;
    }
  }

  //Create account Customer cho admin
  Future CreateCustomerAccount(email, name, phone, dob) async {
    final ref = FirebaseDatabase.instance.ref("users");
    final snapshot = await ref.orderByChild("email").equalTo(email).get();
    //print(snapshot.value);
    if (snapshot.exists) {
      print("Existing User");
      return true;
    } else {
      _name = name;
      _email = email;
      _phone = phone;
      //MÃ hóa mật khẩu
      _password = sha512.convert(utf8.encode(phone)).toString();
      _imageUrl = "https://cdn-icons-png.flaticon.com/512/4143/4143099.png";
      _provider = "PHONE";
      _uid = null;
      _dob = dob;
      _address = "";
      _role = 3;
      notifyListeners();
      print("New user");
      return false;
    }
  }

  Future<void> updateForgetPass(String email, String newValue) async {
    DatabaseReference newpostKey = FirebaseDatabase.instance.ref("users/$_uid");
    Map<String, dynamic> updateData = {
      'password': newValue,
    };
    newpostKey.update(updateData).then((value) {
      print("Thành công");
    }).catchError((onError) {
      print(onError);
    });
    //await FirebaseDatabase.instance.ref().update(value)
    // var uid1 = "";
    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    //     .collection("users")
    //     .where("email", isEqualTo: email)
    //     .get();
    // if (querySnapshot.docs.isNotEmpty) {
    //   querySnapshot.docs.forEach((document) {
    //     // Lấy dữ liệu từ DocumentSnapshot
    //     uid1 = document['uid'];
    //   });
    //
    //   try {
    //     await FirebaseFirestore.instance.collection('users').doc(uid1).set({
    //       'password': newValue,
    //     }, SetOptions(merge: true));
    //     print("Cập nhật thành công.");
    //   } catch (e) {
    //     print("Lỗi khi cập nhật: $e");
    //   }
    // }
  }

  Future<void> updateProfile(String uid, String email, String name,
      String phone, String adress, PlatformFile? image, String dob) async {
    print(dob);
    DatabaseReference newpostKey = FirebaseDatabase.instance.ref("users/$uid");

    Map<String, dynamic> updateData;
    final SharedPreferences s = await SharedPreferences.getInstance();

    if (image != null) {
      final path = 'avtuser/${image!.name}';
      final file = File(image!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      ref.putFile(file);

      //Lấy link của hình ảnh
      UploadTask? uploadtask = ref.putFile(file);
      final snapshot = await uploadtask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      updateData = {
        'name': name,
        'phone': phone,
        'address': adress,
        'image_url': urlDownload.toString(),
        'dob': dob
      };
      await s.setString('image_url', urlDownload!);
    } else {
      updateData = {
        'name': name,
        'phone': phone,
        'address': adress,
        'dob': dob
      };
    }

    //Update lại sharpreces
    await s.setString('name', name!);
    //await s.setString('email', _email!);
    await s.setString("phone", phone!);
    await s.setString('address', adress!);
    await s.setString('dob', dob!);

    await newpostKey.update(updateData).then((value) {
      print("Thành công");
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<void> updateAddress(String name, String phone, String adress) async {
    print(dob);
    DatabaseReference newpostKey = FirebaseDatabase.instance.ref("users/$_uid");

    Map<String, dynamic> updateData;
    final SharedPreferences s = await SharedPreferences.getInstance();

    updateData = {'name': name, 'phone': phone, 'address': adress, 'dob': dob};

    //Update lại sharpreces
    await s.setString('name', name!);
    //await s.setString('email', _email!);
    await s.setString("phone", phone!);
    await s.setString('address', adress!);
    await s.setString('dob', dob!);

    await newpostKey.update(updateData).then((value) {
      print("Thành công");
    }).catchError((onError) {
      print(onError);
    });
  }

  Future cleanUser() async {
    _userCustomer = [];
  }

  Future getAccountStaff() async {
    final DatabaseReference getUser = FirebaseDatabase.instance.ref("users");
    _userCustomer = <Users>[];
    await getUser.onValue.listen((event) {
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? data = child.value as Map?;
        if (data != null) {
          //print(data?["role"]);
          if (data?["role"] == 2) {
            _userCustomer?.add(Users(
                data?["provider"],
                data?["uid"],
                data?["email"],
                data?["image_url"],
                data?["name"],
                data?["phone"],
                data?["address"]));
          }
        }
      }
    });
  }

  Future getAccountUser() async {
    final DatabaseReference getUser = FirebaseDatabase.instance.ref("users");
    _userCustomer = <Users>[];
    await getUser.onValue.listen((event) {
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? data = child.value as Map?;
        if (data != null) {
          //print(data?["role"]);
          if (data?["role"] == 3) {
            _userCustomer?.add(Users(
                data?["provider"],
                data?["uid"],
                data?["email"],
                data?["image_url"],
                data?["name"],
                data?["phone"],
                data?["address"]));
          }
        }
      }
    });
  }

  Future<void> updateProfileAdmin(String uid, String email, String name,
      String phone, String adress, PlatformFile? image, String dob) async {
    DatabaseReference newpostKey = FirebaseDatabase.instance.ref("users/$uid");

    Map<String, dynamic> updateData;

    if (image != null) {
      final path = 'avtuser/${image!.name}';
      final file = File(image!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      ref.putFile(file);

      //Lấy link của hình ảnh
      UploadTask? uploadtask = ref.putFile(file);
      final snapshot = await uploadtask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      updateData = {
        'name': name,
        'phone': phone,
        'address': adress,
        'image_url': urlDownload.toString(),
        'dob': dob
      };
    } else {
      updateData = {
        'name': name,
        'phone': phone,
        'address': adress,
        'dob': dob
      };
    }
    await newpostKey.update(updateData).then((value) {
      print("Thành công");
    }).catchError((onError) {
      print(onError);
    });
  }

  Future removeUser(uid) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid");
    await ref.remove();
  }
}
