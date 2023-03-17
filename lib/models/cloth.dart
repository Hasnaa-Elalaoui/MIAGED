class Cloth {
  final String name;
  final String description;
  final double price;
  final String size;
  final String imageUrl;
  final String brand;
  final String category;

  Cloth({required this.name, required this.description, required this.brand, required this.price, required this.size, required this.imageUrl, required this.category});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'size': size,
      'imageUrl': imageUrl,
      'brand': brand,
      'category': category,
    };
  }

  Cloth.fromMap(Map<String, dynamic> clothMap)
      : name = clothMap["name"],
        description = clothMap["description"],
        size = clothMap["size"],
        imageUrl = clothMap["imageUrl"],
        brand = clothMap["brand"],
        price = clothMap["price"],
        category = clothMap["category"];
}