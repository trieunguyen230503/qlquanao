import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qlquanao/Admin/fragment/fragment/product/category/AddCategory.dart';


class ManageCategory extends StatefulWidget {
  const ManageCategory({super.key});

  @override
  State<ManageCategory> createState() => _ManageCategoryState();
}

class _ManageCategoryState extends State<ManageCategory> {
  final fb = FirebaseDatabase.instance;
  TextEditingController cateName = TextEditingController();

  var l;
  var g;
  var k;
  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('Category');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddCategory(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: FirebaseAnimatedList(
        query: ref,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          var v =
          snapshot.value.toString(); // {subtitle: webfun, title: subscribe}

          g = v.replaceAll(
              RegExp("{|}|CateID: |Name: "), ""); // webfun, subscribe
          g.trim();

          l = g.split(','); // [webfun,  subscribe}]

          return GestureDetector(
            onTap: () {
              setState(() {
                k = snapshot.key;
              });

              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextField(
                      controller: cateName,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Category Name',
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 255, 0, 0),
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
                                      ref.child(snapshot.key!).remove();
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
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      color: Color.fromARGB(255, 0, 22, 145),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await upd();
                        Navigator.of(ctx).pop();
                      },
                      color: Color(0xFF758467),
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Color(0xFF758467),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Color(0xFF758467),
                  title: Text(
                    l[1],
                    // 'dd',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
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

  upd() async {
    DatabaseReference ref1 = FirebaseDatabase.instance.ref("Category/$k");

// Only update the name, leave the age and address!
    await ref1.update({
      "Name": cateName.text,
    });
    cateName.clear();
  }
}

