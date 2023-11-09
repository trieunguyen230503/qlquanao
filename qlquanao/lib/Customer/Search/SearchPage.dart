import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qlquanao/Customer/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/Product.dart';
import '../Home/ProductInfoPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchController = TextEditingController()
    ..addListener(() {
      setState(() {});
    });

  List<Product> _productListData = [];

  List<Product> _fileteredProductListData = [];

  List<String> _searchHistory = []; // Search history list
  final int maxSearchHistoryLength = 5;

  // bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    getProductsFromFirebase();

    _fileteredProductListData = _productListData;
    _searchController.addListener(_performSearch);
    _loadSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void getProductsFromFirebase() async {
    final DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref("Product");

    await databaseRef.onValue.listen((event) {
      if (_productListData.isNotEmpty) {
        _productListData.clear();
      }

      if (!mounted) return;

      for (final child in event.snapshot.children) {
        Product p = Product.fromSnapshot(child);
        setState(() {
          _productListData.add(p);
        });
      }
    }, onError: (error) {
      // Error.
    });
  }

  Future<void> _performSearch() async {
    setState(() {
      // _isLoading = true;
    });

    //Simulates waiting for an API call
    // await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _fileteredProductListData = _productListData
          .where((element) => element.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
      // _isLoading = false;
    });
  }

  Future<void> _addToSearchHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    history.insert(0, query);
    if (history.length > maxSearchHistoryLength) {
      history.removeLast();
    }
    await prefs.setStringList('search_history', history);

    _loadSearchHistory(); // Reload search history after saving
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    setState(() {
      _searchHistory = history;
    });
  }

  Future<void> _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    setState(() {
      _searchHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xFFEDECF2),
        // title: TextFormField(
        //   controller: _searchController,
        //   decoration: InputDecoration(
        //     isDense: true,
        //     contentPadding: EdgeInsets.symmetric(
        //         vertical: MediaQuery.of(context).size.height * 0.01),
        //     prefixIcon: Icon(
        //       Icons.search,
        //       size: 20,
        //     ),
        //     suffixIcon: _searchController.text.isEmpty
        //         ? null
        //         : IconButton(
        //             splashColor: Colors.transparent,
        //             highlightColor: Colors.transparent,
        //             onPressed: _searchController.clear,
        //             icon: Icon(CupertinoIcons.clear_circled_solid)),
        //     enabledBorder: const OutlineInputBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //       borderSide: BorderSide(color: Colors.transparent),
        //     ),
        //     focusedBorder: const OutlineInputBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //       borderSide: BorderSide(color: Colors.transparent),
        //     ),
        //     hintText: 'Search by keyword',
        //     hintStyle: TextStyle(
        //       fontSize: 13,
        //     ),
        //     fillColor: Colors.grey[200],
        //     filled: true,
        //   ),
        // ),
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
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
                width: MediaQuery.of(context).size.width - 180,
                child: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search...",
                  ),
                ),
              ),
              _searchController.text.isEmpty
                  ? const Icon(
                Icons.search,
                size: 28,
                color: Colors.grey,
              )
                  : GestureDetector(
                onTap: () {
                  // Clear the search text when delete icon is tapped
                  _searchController.clear();
                },
                child: const Icon(
                  Icons.clear,
                  size: 28,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          )
        ],
      ),
      body:
          //Cái này là loading screen
          // _isLoading
          //     ? const Center(
          //   child: CircularProgressIndicator(color: Colors.black),
          // )
          //     :
          _searchController.text.isEmpty && _searchHistory.isNotEmpty
              ? _buildSearchHistory()
              : _buildSearchResults(),
      backgroundColor: Color(0xFFEDECF2),
    );
  }

  Widget _buildSearchHistory() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                _searchHistory[index],
                style: const TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductInfoPage(
                            product: _fileteredProductListData[index])));

              },
            ),
          ),
        ),
        Expanded(
            child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            _clearSearchHistory();
          },
          child: Text(
            'Clear all history',
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        )),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_fileteredProductListData.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 15),
        child: Container(
          alignment: AlignmentDirectional.topCenter,
          child: Text(
            "Search not found",
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _fileteredProductListData.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            _addToSearchHistory(_fileteredProductListData[index].name);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductInfoPage(
                        product: _fileteredProductListData[index])));
          },
          child: ListTile(
            title: Text(
              _fileteredProductListData[index].name,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      );
    }
  }
}
