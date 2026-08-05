class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;
  final int ratingCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'];
    return Product(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Untitled',
      price: ((json['price'] as num?) ?? 0).toDouble(),
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      rating: ((rating is Map ? rating['rate'] : null) as num?)?.toDouble() ?? 0,
      ratingCount: (rating is Map ? rating['count'] : null) as int? ?? 0,
    );
  }
}
