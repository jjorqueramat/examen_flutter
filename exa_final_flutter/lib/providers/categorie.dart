class Category {
  final int id;
  final String name;
  final String state;

  Category({
    required this.id,
    required this.name,
    required this.state,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['category_id'],
      name: json['category_name'],
      state: json['category_state'],
    );
  }
}
