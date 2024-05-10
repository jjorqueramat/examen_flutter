class Product {
  final int id;
  final String name;
  final int price;
  final String imageUrl;
  final String state;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.state,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'],
      name: json['product_name'],
      price: json['product_price'],
      imageUrl: json['product_image'],
      state: json['product_state'],
    );
  }
}
