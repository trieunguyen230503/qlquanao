class CategoryProduct{
  String? key;
  CategoryProductData? categoryProductData;

  CategoryProduct({this.key,this.categoryProductData});
}

class CategoryProductData{
  String? uid;
  String? name;

  CategoryProductData({this.uid,this.name});

  CategoryProductData.fromJson(Map<dynamic,dynamic> json){
    uid = json["CateID"];
    name = json["Name"];
  }
}