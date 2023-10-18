class Product {
  final String name;
  final String image;
  final String color;
  final String size;
  final int price;
  int quantity;

  Product({
    required this.name,
    required this.image,
    required this.color,
    required this.size,
    required this.price,
    int? quantity,
  }) : quantity = (quantity == null || quantity < 1) ? 1 : quantity;

  @override
  String toString() {
    return "sản phẩm: " + " name: " + name + " image: " + image + " size: " + size + " color: " + color + " price: " + price.toString() + " quantity: " + quantity.toString();
  }
}
