import '../models/product.dart';

class ProductService {
  // داده‌های تست - بعداً با API جایگزین می‌شود
  static final List<Product> _products = [
    Product(
      id: 1,
      name: 'گوشی هوشمند سامسونگ',
      description: 'گوشی هوشمند پیشرفته با کیفیت عالی',
      price: 15000000,
      category: 'الکترونیک',
      imageUrl: 'https://example.com/phone.jpg',
      createdAt: DateTime.now(),
    ),
    Product(
      id: 2,
      name: 'لپ‌تاپ ایسوس',
      description: 'لپ‌تاپ قدرتمند برای کار و بازی',
      price: 25000000,
      category: 'الکترونیک',
      imageUrl: 'https://example.com/laptop.jpg',
      createdAt: DateTime.now(),
    ),
    Product(
      id: 3,
      name: 'پیراهن مردانه',
      description: 'پیراهن با کیفیت و طراحی مدرن',
      price: 500000,
      category: 'پوشاک',
      imageUrl: 'https://example.com/shirt.jpg',
      createdAt: DateTime.now(),
    ),
  ];

  static Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _products.where((p) => p.isActive).toList();
  }

  static Future<Product?> getProductById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<List<Product>> getProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _products
        .where((product) => product.category == category && product.isActive)
        .toList();
  }

  static Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _products
        .where(
          (product) =>
              product.isActive &&
              (product.name.toLowerCase().contains(query.toLowerCase()) ||
                  (product.description?.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ??
                      false)),
        )
        .toList();
  }

  static Future<Product> createProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final newProduct = product.copyWith(
      id: _products.length + 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _products.add(newProduct);
    return newProduct;
  }

  static Future<Product?> updateProduct(int id, Product product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      final updatedProduct = product.copyWith(
        id: id,
        updatedAt: DateTime.now(),
      );
      _products[index] = updatedProduct;
      return updatedProduct;
    }
    return null;
  }

  static Future<bool> deleteProduct(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _products.indexWhere((product) => product.id == id);
    if (index != -1) {
      // soft delete
      _products[index] = _products[index].copyWith(
        isActive: false,
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  static Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products
        .where((p) => p.isActive)
        .map((p) => p.category)
        .where((category) => category != null)
        .cast<String>()
        .toSet()
        .toList();
  }
}
