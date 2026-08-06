class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'] as Map<String, dynamic>? ?? const {};
    return Product(
      id: json['id'] as int? ?? 0,
      name: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (rating['rate'] as num?)?.toDouble() ?? 0,
      reviewCount: (rating['count'] as num?)?.toInt() ?? 0,
      imageUrl: json['image'] as String? ?? '',
    );
  }

  final int id;
  final String name;
  final String description;
  final String category;
  final double price;
  final double rating;
  final int reviewCount;
  final String imageUrl;
}
