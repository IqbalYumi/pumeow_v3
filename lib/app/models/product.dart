class Product {
  final int id;
  final String name;
  final String variant;
  final double price;
  final String description;
  final String imageAsset;
  final String location;
  final double rating;
  final bool isAvailable;

  const Product({
    required this.id,
    required this.name,
    required this.variant,
    required this.price,
    required this.description,
    required this.imageAsset,
    required this.location,
    this.rating = 4.5,
    this.isAvailable = true,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "variant": variant,
        "price": price,
        "description": description,
        "imageAsset": imageAsset,
        "location": location,
        "rating": rating,
        "isAvailable": isAvailable,
      };

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: _asInt(map['id']),
      name: (map['name'] ?? '') as String,
      variant: (map['variant'] ?? '') as String,
      price: _asDouble(map['price']),
      description: (map['description'] ?? '') as String,
      imageAsset: (map['image_asset'] ?? map['imageAsset'] ?? '') as String,
      location: (map['location'] ?? '') as String,
      rating: _asDouble(map['rating'] ?? 4.5),
      isAvailable: (map['is_available'] ?? map['isAvailable'] ?? true) as bool,
    );
  }

  static double _asDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
