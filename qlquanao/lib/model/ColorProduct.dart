class ColorProduct{
  String? key;
  ColorProductData? colorProductData;

  ColorProduct({this.key,this.colorProductData});
}

class ColorProductData{
  String? uid;
  String? name;

  ColorProductData({this.uid,this.name});

  ColorProductData.fromJson(Map<dynamic,dynamic> json){
    uid = json["ColorID"];
    name = json["Name"];
  }
}