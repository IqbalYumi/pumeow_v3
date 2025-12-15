class Product {
  final int id;
  final String name;
  final String variant;
  final double price;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.variant,
    required this.price,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "variant": variant,
    "price": price,
    "description": description,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
