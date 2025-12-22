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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
