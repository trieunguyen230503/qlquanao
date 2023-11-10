import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../productsizecolor/ManageProductSizeColor.dart';
import 'AddProduct.dart';
import 'UpdateProduct.dart';

class ManageProduct extends StatefulWidget {
  const ManageProduct({super.key});

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  @override
  Widget build(BuildContext context) {
    DatabaseReference db_Ref = FirebaseDatabase.instance.ref().child('Product');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF758467),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddProduct(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: FirebaseAnimatedList(
        query: db_Ref,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          Map Product = snapshot.value as Map;
          Product['ProductID'] = snapshot.key;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ManageProductSizeColor(
                    Product_Key: Product['ProductID'],
                  ),
                ),
              );
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tileColor: Colors.white,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UpdateProduct(
                                Product_Key: Product['ProductID'],
                                CategoryUID: Product['Category'],
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red[900],
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm Deletion"),
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
                                          .child(Product['ProductID'])
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
                  leading: ClipRRect(
                    child: Image.network(Product['url']),
                  ),
                  title: Text(
                    Product['Name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '\$ ${Product['PromoPrice'].toString()}',
                    style: TextStyle(
                      fontSize: 20,
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
