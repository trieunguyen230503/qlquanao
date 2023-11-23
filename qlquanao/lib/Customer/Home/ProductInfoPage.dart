import 'package:clippy_flutter/arc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/model/ProductSizeColor.dart';
import 'package:qlquanao/utils/Login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:qlquanao/model/Product.dart';

import '../../model/Cart.dart';
import '../../provider/signin_provider.dart';
import '../Order/CartPage.dart';

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

  String? uid;
  int quantity = 1;
  int quantityNew = 0;
  int price = 0;
  String idCart = "";

  int quantityOfStock = 0;

  Map<String, int> sizeQuantityMap = {};

  List<ProductSizeColorData> listProductSizeColor = [];

  List<String> listSizesId = [];
  List<String> listClrsId = [];

  List<String> sizes = [];
  String selectedSize = "";
  String IDselectedSize = "";

  List<String> clrs = [];
  String selectedColor = "";
  String IDselectedColor = "";

  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<String> _sliderImages = [];

  List<int> _quantityInStock = [];


  void goToPage(int pageIndex) {
    setState(() {
      _currentPage = pageIndex;
      _pageController.jumpToPage(pageIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    quantityNew = 0;
    // Lấy id user đang đăng nhập
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreference();
    uid = sp.uid;

    price = product.promoPrice!;
    getProductSizeColorFromFirebase();
  }

  void getProductSizeColorFromFirebase() async {
    final DatabaseReference databaseRef =
    FirebaseDatabase.instance.ref("ProductSizeColor");

    await databaseRef.onValue.listen((event) async {
      if (listProductSizeColor.isNotEmpty) {
        listProductSizeColor.clear();
      }

      if (listSizesId.isNotEmpty) {
        listSizesId.clear();
      }
      if (listSizesId.isNotEmpty) {
        listClrsId.clear();
      }
      if (sizes.isNotEmpty) {
        sizes.clear();
      }
      if (clrs.isNotEmpty) {
        clrs.clear();
      }
      if(_sliderImages.isNotEmpty){
        _sliderImages.clear();
      }

      for (final snap in event.snapshot.children) {
        ProductSizeColorData p = ProductSizeColorData.fromSnapshot(snap);
        listProductSizeColor.add(p);
        String productID = snap.child("ProductID").value.toString();

        if (productID == product.productId) {
          String size = snap.child("SizeID").value.toString();
          String color = snap.child("ColorID").value.toString();
          String image = snap.child("url").value.toString();
          int quantity = int.parse(snap.child("Quantity").value.toString());
          if(!listSizesId.contains(size)){
            listSizesId.add(size);
          }
          if(!listClrsId.contains(color)){
            listClrsId.add(color);
            _sliderImages.add(image);
          }
          _quantityInStock.add(quantity);
        }
      }

      final ref = FirebaseDatabase.instance.ref();

      for (var c in listClrsId) {
        final snapshot = await ref.child('Color/$c/Name').get();
        String color = snapshot.value.toString();
        if(mounted){
          setState(() {
            clrs.add(color);
          });
        }
      }

      for (var s in listSizesId) {
        final snapshot = await ref.child('Size/$s/Name').get();
        String size = snapshot.value.toString();
        if(mounted){
          setState(() {
            sizes.add(size);
          });
        }
      }

      if(mounted){
        setState(() {
          if (sizes.isNotEmpty && clrs.isNotEmpty) {
            selectedSize = sizes[0];
            selectedColor = clrs[0];
            IDselectedSize = listSizesId[0];
            onColorSelected(listClrsId[0]);
            quantityOfStock = sizeQuantityMap[listSizesId[0]] ?? 0;
          }
        });
      }
    }, onError: (error) {
      // Error.
    });
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormatterUSD = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    final List<Widget> _slider = _sliderImages
        .map((image) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03),
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            image,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ))
        .toList();

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
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width - 32,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      if(mounted){
                        setState(() {
                          _currentPage = index;
                          selectedColor = clrs[index];
                        });
                      }
                    },
                    children: _slider,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Container(
                  child: AnimatedSmoothIndicator(
                    activeIndex: _currentPage,
                    count: _slider.length,
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 5,
                      dotColor: Color.fromRGBO(217, 217, 217, 1),
                      activeDotColor: Color.fromRGBO(102, 102, 102, 1),
                      paintStyle: PaintingStyle.fill,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Arc(
                edge: Edge.TOP,
                arcType: ArcType.CONVEY,
                height: 20,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 50, bottom: 20),
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
                          padding: EdgeInsets.only(top: 10, bottom: 12),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              "Material: ${product.material}",
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
                                "Color: ",
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
                                        onTap: () {
                                          setState(() {
                                            selectedColor = clrs[i];
                                            onColorSelected(listClrsId[i]);
                                            quantityOfStock = sizeQuantityMap[IDselectedSize] ?? 0 ;
                                            goToPage(i);
                                          });
                                        },
                                        // thẻ IntrinsicWidth giúp tự tăng chiều dài phù hợp với Text
                                        child: IntrinsicWidth(
                                          child: Container(
                                            height: 30,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                  selectedColor == clrs[i]
                                                      ? Colors.blueAccent
                                                      : Colors.grey
                                                      .withOpacity(0.5),
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
                                "Size: ",
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
                                        onTap: () {
                                          setState(() {
                                            selectedSize = sizes[i];
                                            IDselectedSize = listSizesId[i];
                                            quantityOfStock = sizeQuantityMap[listSizesId[i]] ?? 0;
                                          });
                                        },
                                        child: IntrinsicWidth(
                                          child: Container(
                                            height: 30,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                  selectedSize == sizes[i]
                                                      ? Colors.blueAccent
                                                      : Colors.grey
                                                      .withOpacity(0.5),
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
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Quantity of stock: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  TextSpan(
                                    text: quantityOfStock.toString(),
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.only(top: 14, right: 10),
                          child: Row(
                            children: [
                              Spacer(),
                              Text(
                                "Quantity:   ",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (quantity > 1) {
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
                                    color: quantity == 1
                                        ? Colors.black12
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
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
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  quantity.toString().trim(),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if(quantity < quantityOfStock){
                                    setState(() {
                                      quantity++;
                                      //Nếu người dùng ấn tăng sl thì tăng thêm giá tổng
                                      price += product.price!;
                                    });
                                  }

                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: (quantityOfStock != 0 && quantity == quantityOfStock)
                                        ? Colors.black12
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
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
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 24, bottom: 40),
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
          padding: EdgeInsets.only(left: 30, right: 20),
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
                currencyFormatterUSD.format(price),
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              ElevatedButton.icon(
                onPressed: quantityOfStock != 0
                    ? () => addToCart(context) : null,
                icon: Icon(
                  CupertinoIcons.cart_badge_plus,
                  color: Colors.white,
                ),
                label: Text(
                  "Add to cart",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return states.contains(MaterialState.disabled) ? Colors.grey : Colors.black;
                    },
                  ),
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


  Future<void> addToCart(BuildContext context) async {

    if(uid == null){
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
    else{
      checkProductIsUnit(product.productId!).then((checkIsUnit) {
        final ref = FirebaseDatabase.instance.ref();
        final snapshotCartItem = ref.child('cart');
        if(checkIsUnit == false){
          String? idCart = snapshotCartItem.push().key;
          Cart c = Cart(
              idCart: idCart!,
              productID: product.productId!,
              productName: product.name!,
              image: product.image!,
              color: selectedColor,
              size: selectedSize,
              price: product.promoPrice!,
              quantity: quantity,
              userID: uid!);
          snapshotCartItem.child(idCart!).set(c.toJson());
        }
        else{
          Cart c = Cart(
              idCart: idCart,
              productID: product.productId!,
              productName: product.name!,
              image: product.image!,
              color: selectedColor,
              size: selectedSize,
              price: product.promoPrice!,
              quantity: quantityNew,
              userID: uid!);
          snapshotCartItem.child(idCart).set(c.toJson());
          print(quantity.toString());
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
      });
    }
  }

  void onColorSelected(String color) {
    setState(() {
      IDselectedColor = color;
      // Clear the sizeQuantityMap
      sizeQuantityMap.clear();
      // Populate sizeQuantityMap with quantities for the selected color
      for (String size in listSizesId) {
        int quantity = getQuantity(color, size, listProductSizeColor);
        sizeQuantityMap[size] = quantity; // số lượng của size tương ứng, cách dùng: sizeQuantityMap[listSizesId[i]] ?? 0;
      }
    });
  }

  // Get quantity for a specific color and size
  int getQuantity(String selectedColor, String selectedSize, List<ProductSizeColorData> lstSizeColor) {
    List<ProductSizeColorData> filteredList = lstSizeColor
        .where((item) => item.colorID == selectedColor && item.sizeID == selectedSize)
        .toList();

    int totalQuantity = 0;
    for (var item in filteredList) {
      totalQuantity += item.quantity!;
    }

    return totalQuantity;
  }

  Future<bool> checkProductIsUnit(String productID) async {
    bool check = false;
    final ref = FirebaseDatabase.instance.ref();
    final snapshotCartItem = ref.child('cart');
    await snapshotCartItem.onValue.first.then((event) {
      for (final child in event.snapshot.children) {
        Cart cart = Cart.fromSnapshot(child);
        if (cart.userID == uid && cart.productID == productID && cart.color == selectedColor && cart.size == selectedSize) {
          quantityNew = quantity + cart.quantity;
          idCart = cart.idCart;
          check = true;
          return check;
        }
      }
    }).catchError((error) {
      print(error);
    });
    return check;
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
              "Product",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {
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