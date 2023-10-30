class SizeProduct{
  String? key;
  SizeProductData? sizeProductData;

  SizeProduct({this.key,this.sizeProductData});
}

class SizeProductData{
  String? uid;
  String? name;

  SizeProductData({this.uid,this.name});

  SizeProductData.fromJson(Map<dynamic,dynamic> json){
    uid = json["SizeID"];
    name = json["Name"];
  }
}