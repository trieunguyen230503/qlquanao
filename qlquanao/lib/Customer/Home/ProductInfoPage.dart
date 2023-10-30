import 'package:clippy_flutter/arc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:qlquanao/model/Product.dart';

import '../../model/Cart.dart';
import '../Order/CartPage.dart';

String formatPrice(int price) {
  final formatter = NumberFormat("#,###");
  return formatter.format(price);
}

class ProductInfoPage extends StatefulWidget {
  final Product product;
  ProductInfoPage({required this.product});

  @override
  State<ProductInfoPage> createState() =>
      _ProductInfoPageState(product: product);
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  final Product product;
  _ProductInfoPageState({required this.product});

  int quantity = 1;
  int price = 0;

  List<String> sizes = [
    "M",
    "S",
    "L",
    "XL",
    "XXL",
  ];
  String selectedSize = "";

  List<String> clrs = [
    "Trắng",
    "Đen",
    "Xanh lá mạ",
    "Đỏ mộng mơ",
  ];
  String selectedColor = "";

  @override
  void initState() {
    super.initState();
    price = product.price!;
    selectedSize = sizes[0];
    selectedColor = clrs[0];
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
              automaticallyImplyLeading: false,
              floating: false,
              pinned: true,
              flexibleSpace: ItemAppBar(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Image.network(
                  product.image.toString(),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width - 32,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Arc(
                edge: Edge.TOP,
                arcType: ArcType.CONVEY,
                height: 30,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 60, bottom: 20),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              product.name!,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 26,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              product.description.toString(),
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 12),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              "Chất liệu: ${product.material}",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                "Màu sắc: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  spacing: 10,
                                  runSpacing: 5,
                                  children: [
                                    for (int i = 0; i < clrs.length; i++)
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            selectedColor = clrs[i];
                                          });
                                        },
                                        // thẻ IntrinsicWidth giúp tự tăng chiều dài phù hợp với Text
                                        child: IntrinsicWidth(
                                          child: Container(
                                            height: 30,
                                            padding: EdgeInsets.symmetric(horizontal: 8),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: selectedColor == clrs[i] ? Colors.blueAccent : Colors.grey.withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 8,
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              clrs[i],
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                "Kích thước: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  spacing: 10,
                                  runSpacing: 5,
                                  children: [
                                    for (int i = 0; i < sizes.length; i++)
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            selectedSize = sizes[i];
                                          });
                                        },
                                        child: IntrinsicWidth(
                                          child: Container(
                                            height: 30,
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: selectedSize == sizes[i] ? Colors.blueAccent : Colors.grey.withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 8,
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              sizes[i].trim(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 18, bottom: 40, right: 10),
                          child: Row(
                            children: [
                              Spacer(),
                              Text(
                                "Số lượng:   ",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  if(quantity > 1){
                                    setState(() {
                                      quantity--;
                                      //Nếu người dùng ấn giảm sl thì giảm giá tổng
                                      price -= product.price!;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: quantity == 1 ? Colors.black12 : Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: Icon(
                                    CupertinoIcons.minus,
                                    size: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: Text(
                                  quantity.toString().trim(),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    quantity++;
                                    //Nếu người dùng ấn tăng slthì tăng thêm giá tổng
                                    price += product.price!;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                        Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: Icon(
                                    CupertinoIcons.plus,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 70,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatPrice(price) + "đ",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  final ref = FirebaseDatabase.instance.ref();
                  final snapshotCartItem = ref.child('cart');
                  bool check = false;

                  // snapshotCartItem.onValue.listen((event) {
                  //   for (final child in event.snapshot.children) {
                  //     Cart cart = Cart.fromSnapshot(child);
                  //     if(cart.productID == product.productID && cart.color == selectedColor && cart.size == selectedSize){
                  //       check = true;
                  //       cart.quantity += quantity;
                  //       snapshotCartItem.child(cart.idCart).set(cart.toJson());
                  //       break;
                  //     }
                  //   }
                  //   if(check == false){
                  //     print("Không trùng");
                  //     String? idCart = snapshotCartItem.push().key;
                  //     Cart c = Cart(idCart: idCart!, productID: product.productID!, productName: product.name!, image: product.image!, color: selectedColor, size: selectedSize, price: product.price!,
                  //         userID: "-Nf_mGcgG0xAWGoHfK9J");
                  //     snapshotCartItem.child(idCart!).set(c.toJson());
                  //     Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                  //   }
                  // }, onError: (error) {
                  //   print(error);
                  // });

                  String? idCart = snapshotCartItem.push().key;
                  Cart c = Cart(idCart: idCart!, productID: product.productId!, productName: product.name!, image: product.image!, color: selectedColor, size: selectedSize, price: product.price!, quantity: quantity,
                      userID: "-Nf_mGcgG0xAWGoHfK9J");
                  snapshotCartItem.child(idCart!).set(c.toJson());
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));

                },
                icon: Icon(
                  CupertinoIcons.cart_badge_plus,
                  color: Colors.white,
                ),
                label: Text(
                  "Thêm vào giỏ hàng",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemAppBar extends StatefulWidget {
  const ItemAppBar({super.key});

  @override
  State<ItemAppBar> createState() => _ItemAppBarState();
}

class _ItemAppBarState extends State<ItemAppBar> {
  bool isFavorite = false;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Chi tiết sản phẩm",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Spacer(),
          InkWell(
            onTap:(){
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 30,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
