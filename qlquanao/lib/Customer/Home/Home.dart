import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:qlquanao/Customer/Search/SearchPage.dart';
import 'package:qlquanao/model/Cart.dart';
import 'package:qlquanao/model/Product.dart';
import 'package:qlquanao/utils/Login.dart';
import 'package:qlquanao/utils/ProfileCustome.dart';
import 'package:qlquanao/utils/ProfilePage.dart';
import 'package:qlquanao/utils/next_screen.dart';

import '../../provider/signin_provider.dart';
import '../Order/CartPage.dart';
import 'ProductInfoPage.dart';

class Category {
  String idCate;
  String nameCate;

  Category({required this.idCate, required this.nameCate});
}

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  String? uid;
  String? avtUser;
  List<Product> productList = [];
  List<Category> cateList = [Category(idCate: "all", nameCate: "All products")];
  bool isFavorite = false;
  int quantityInCart = 0;
  String cateSelected = "All products";

  @override
  void initState() {
    super.initState();

    getDataUser();
    getProductsFromFirebase('all');
    getQuantityInCart();
  }

  void getDataUser() async {
    // Lấy id user đang đăng nhập
    final sp = context.read<SignInProvider>();
    await sp.getDataFromSharedPreference();
    uid = sp.uid;
    avtUser = sp.imageUrl;
  }

  void getProductsFromFirebase(String category) async {
    final DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref("Product");

    await databaseRef.onValue.listen((event) {
      if (productList.isNotEmpty) {
        productList.clear();
      }

      if (!mounted) return;

      if (category == "all") {
        for (final child in event.snapshot.children) {
          Product p = Product.fromSnapshot(child);
          setState(() {
            productList.add(p);
          });
        }
      } else {
        for (final child in event.snapshot.children) {
          Product p = Product.fromSnapshot(child);
          if (p.category == category) {
            setState(() {
              productList.add(p);
            });
          }
        }
      }

      if (productList.isEmpty) {
        setState(() {});
      }
    }, onError: (error) {
      // Error.
    });
  }

  void getQuantityInCart() async {
    final DatabaseReference cartRef = FirebaseDatabase.instance.ref("cart");
    final DatabaseReference cateRef = FirebaseDatabase.instance.ref("Category");

    cartRef.onValue.listen((event) {
      if (quantityInCart != 0) {
        quantityInCart = 0;
      }

      if (!mounted) return;

      for (final child in event.snapshot.children) {
        Cart c = Cart.fromSnapshot(child);
        if (c.userID == uid) {
          setState(() {
            quantityInCart++;
          });
        }
      }
    }, onError: (error) {
      // Error.
    });

    cateRef.onValue.listen((event) {
      if (cateList.isNotEmpty) {
        cateList.clear();
        cateList.add(Category(idCate: "all", nameCate: "All products"));
      }

      if (!mounted) return;
      for (final child in event.snapshot.children) {
        String idCate = child.child("CateID").value.toString();
        String nameCate = child.child("Name").value.toString();
        Category category = Category(idCate: idCate, nameCate: nameCate);
        setState(() {
          cateList.add(category);
        });
      }
    }, onError: (error) {
      // Error.
    });
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormatterUSD = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return Scaffold(
      backgroundColor: Color(0xFFEDECF2),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Color(0xFFEDECF2),
              collapsedHeight: 185,
              expandedHeight: 185,
              floating: false,
              pinned: true,
              flexibleSpace: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Image.asset(
                          "assets/logo.png",
                          width: 45,
                          height: 45,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage()));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                height: 50,
                                width: MediaQuery.of(context).size.width - 280,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Search...",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.search,
                                size: 26,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: badges.Badge(
                          badgeContent: Text(
                            quantityInCart.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          badgeStyle: badges.BadgeStyle(
                            badgeColor: Colors.red,
                            padding: EdgeInsets.all(5),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CartPage()));
                            },
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.black,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                      (uid == null)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Center(
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login()));
                                    },
                                    child: Text("LOGIN",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: InkWell(
                                onTap: () {
                                  nextScreen(context, ProfilePage());
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage((avtUser != null)
                                          ? avtUser!
                                          : "error"), // Thay thế bằng đường dẫn đến hình ảnh của bạn
                                    ),
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < cateList.length; i++)
                          InkWell(
                            onTap: () {
                              getProductsFromFirebase(
                                  cateList[i].idCate.toString());
                              cateSelected = cateList[i].nameCate.toString();
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: cateSelected == cateList[i].nameCate
                                        ? Colors.black38
                                        : Colors.white.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/aoThun1.jpg',
                                      width: 40, height: 40),
                                  Text(
                                    cateList[i].nameCate,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      cateSelected,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            productList.isNotEmpty
                ? SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.6),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final productItem = productList[index];
                        return Container(
                          padding:
                              EdgeInsets.only(left: 15, right: 15, top: 10),
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "-" +
                                          (100 -
                                                  (productItem.promoPrice! /
                                                          productItem.price! *
                                                          100)
                                                      .toInt())
                                              .toString() +
                                          "%",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     setState(() {
                                  //       isFavorite = !isFavorite;
                                  //     });
                                  //   },
                                  //   child: Icon(
                                  //     isFavorite
                                  //         ? Icons.favorite
                                  //         : Icons.favorite_border,
                                  //     size: 30,
                                  //     color: Colors.redAccent,
                                  //   ),
                                  // ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductInfoPage(
                                              product: productItem)));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      child: Image.network(
                                        productItem.image!,
                                        height: 120,
                                        width: 120,
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      padding: EdgeInsets.only(bottom: 8),
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        productItem.name!,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 8),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        currencyFormatterUSD
                                            .format(productItem.price!),
                                        style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(top: 4),
                                      child: Text(
                                        currencyFormatterUSD
                                            .format(productItem.promoPrice!),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: productList.length,
                    ),
                  )
                : SliverList(
                    delegate: SliverChildListDelegate([
                      Center(
                        child: Text("The product is out of stock",
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                      ),
                    ]),
                  ),
          ],
        ),
      ),
    );
  }
}
