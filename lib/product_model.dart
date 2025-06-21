class ProductFields {
  static const String tableName = 'products';

  static const String id = '_id';
  static const String description = 'description';
  static const String price = 'price';
  static const String isAvailable = 'isAvailable';
  static const String createdTime = 'createdTime';
}

class ProductModel {
  final int? id;
  final String description;
  final double price;
  final bool isAvailable;
  final DateTime createdTime;

  ProductModel({
    this.id,
    required this.description,
    required this.price,
    required this.isAvailable,
    required this.createdTime,
  });

  ProductModel copy({
    int? id,
    String? description,
    double? price,
    bool? isAvailable,
    DateTime? createdTime,
  }) =>
      ProductModel(
        id: id ?? this.id,
        description: description ?? this.description,
        price: price ?? this.price,
        isAvailable: isAvailable ?? this.isAvailable,
        createdTime: createdTime ?? this.createdTime,
      );

  static ProductModel fromJson(Map<String, Object?> json) => ProductModel(
        id: json[ProductFields.id] as int?,
        description: json[ProductFields.description] as String,
        price: json[ProductFields.price] as double,
        isAvailable: json[ProductFields.isAvailable] == 1,
        createdTime: DateTime.parse(json[ProductFields.createdTime] as String),
      );

  Map<String, Object?> toJson() => {
        ProductFields.id: id,
        ProductFields.description: description,
        ProductFields.price: price,
        ProductFields.isAvailable: isAvailable ? 1 : 0,
        ProductFields.createdTime: createdTime.toIso8601String(),
      };
}