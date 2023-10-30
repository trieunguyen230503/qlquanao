import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../HomePageAdmin.dart';
import 'AddProductSizeColor.dart';
import 'UpdateProductSizeColor.dart';

class ManageProductSizeColor extends StatefulWidget {
  String Product_Key;

  ManageProductSizeColor({required this.Product_Key});

  @override
  State<ManageProductSizeColor> createState() => _ManageProductSizeColorState();
}

class _ManageProductSizeColorState extends State<ManageProductSizeColor> {
  DatabaseReference db_Ref =
      FirebaseDatabase.instance.ref().child('ProductSizeColor');

  String productName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    GetProductName();
  }

  Future<void> GetProductName() async {
    DatabaseReference dbRef2 = FirebaseDatabase.instance
        .ref('Product/${widget.Product_Key}')
        .child('Name');
    DatabaseEvent event = await dbRef2.once();
    setState(() {
      productName = event.snapshot.value.toString();
    });
  }

  Future<String?> getNameById(String id, String node) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('$node/$id/Name');
    DatabaseEvent event = await ref.once();
    return event.snapshot.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    Query db_Ref2 =
        db_Ref.orderByChild('ProductID').equalTo(widget.Product_Key);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo[900],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AddProductSizeColor(Product_Key: widget.Product_Key),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Add your custom back button behavior here.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomePageAdmin(),
              ),
            );
          },
        ),
        title: Text(
          productName,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.indigo[900],
      ),
      body: FirebaseAnimatedList(
        query: db_Ref2,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          Map ProductSizeColor = snapshot.value as Map;
          ProductSizeColor['ProductSizeColorID'] = snapshot.key;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UpdateProductSizeColor(
                    ProductSizeColor_Key:
                        ProductSizeColor['ProductSizeColorID'],
                    ColorUID: ProductSizeColor['ColorID'],
                    SizeUID: ProductSizeColor['SizeID'],
                    ProductUID: ProductSizeColor['ProductID'],
                  ),
                ),
              );
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Colors.indigo[100],
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue[900],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UpdateProductSizeColor(
                                ProductSizeColor_Key:
                                    ProductSizeColor['ProductSizeColorID'],
                                ColorUID: ProductSizeColor['ColorID'],
                                SizeUID: ProductSizeColor['SizeID'],
                                ProductUID: ProductSizeColor['ProductID'],
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red[900],
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Deletion"),
                                content: Text("Are you sure you want "
                                    "to delete this item?"),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Delete"),
                                    onPressed: () {
                                      // Perform the deletion logic here
                                      db_Ref
                                          .child(ProductSizeColor[
                                              'ProductSizeColorID'])
                                          .remove();
                                      Navigator.of(context)
                                          .pop(); // Close the AlertDialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      ProductSizeColor['url'],
                    ),
                  ),
                  title: FutureBuilder<String?>(
                    future: getNameById(ProductSizeColor['SizeID'], 'Size'),
                    builder: (context, sizeSnapshot) {
                      return FutureBuilder<String?>(
                        future:
                            getNameById(ProductSizeColor['ColorID'], 'Color'),
                        builder: (context, colorSnapshot) {
                          if (sizeSnapshot.connectionState ==
                                  ConnectionState.done &&
                              colorSnapshot.connectionState ==
                                  ConnectionState.done) {
                            final sizeName =
                                sizeSnapshot.data ?? 'Default Size Name';
                            final colorName =
                                colorSnapshot.data ?? 'Default Color Name';
                            return Text(
                              'Size: $sizeName\nColor: $colorName',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else {
                            return const Text(
                                'Loading...'); // You can use a loading indicator here.
                          }
                        },
                      );
                    },
                  ),
                  subtitle: Text(
                    'Số lượng: ${ProductSizeColor['Quantity'].toString()}\nGiá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(ProductSizeColor['Price'])}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}