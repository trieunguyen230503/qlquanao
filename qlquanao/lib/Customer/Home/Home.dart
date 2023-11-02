import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;
import 'package:qlquanao/model/Product.dart';

import '../Order/CartPage.dart';
import 'ProductInfoPage.dart';

String formatPrice(int price) {
  final formatter = NumberFormat("#,###");
  return formatter.format(price);
}

class Category {
  String idCate;
  String nameCate;

  Category({required this.idCate, required this.nameCate});
}

List<Product> productList = [];
List<Category> cateList = [];

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  bool isFavorite = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductsFromFirebase();
  }

  void getProductsFromFirebase() async {
    final DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref("Product");

    await databaseRef.onValue.listen((event) {
      if (productList.isNotEmpty) {
        productList.clear();
      }

      for (final child in event.snapshot.children) {
        Product p = Product.fromSnapshot(child);
        setState(() {
          productList.add(p);
        });
      }
    }, onError: (error) {
      // Error.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEDECF2),
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Color(0xFFEDECF2),
                collapsedHeight: 190,
                expandedHeight: 190,
                floating: false,
                pinned: true,
                flexibleSpace: HomeAppBar(),
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.6),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final productItem = productList[index];
                    return Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "-" +(100 - (productItem.promoPrice!/productItem.price! * 100).toInt()).toString() + "%",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });
                                },
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 30,
                                  color: Colors.redAccent,
                                ),
                              ),
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
                                  padding: EdgeInsets.only(bottom: 8),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    productItem.name!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    formatPrice(productItem.price!) + "đ",
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    formatPrice(productItem.promoPrice!) + "đ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
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
              ),
            ],
          ),
        ));
  }
}

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  int quantityInCart = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuantityInCart();
  }

  void getQuantityInCart() async {
    final DatabaseReference cartRef = FirebaseDatabase.instance.ref("cart");
    final DatabaseReference cateRef = FirebaseDatabase.instance.ref("Category");

    cartRef.onValue.listen((event) {
      if (quantityInCart != 0) {
        quantityInCart = 0;
      }
      for (final child in event.snapshot.children) {
        setState(() {
          quantityInCart++;
        });
      }
    }, onError: (error) {
      // Error.
    });

    cateRef.onValue.listen((event) {
      if (cateList.isNotEmpty) {
        cateList.clear();
      }
      for (final child in event.snapshot.children) {
        String idCate = child.child("cateID").value.toString();
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                    width: MediaQuery.of(context).size.width - 160,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search...",
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.search,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartPage()));
                  },
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < cateList.length; i++)
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
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
            "All products",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
