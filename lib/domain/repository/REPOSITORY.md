# DEFINISION:
- Domain-Driven Design (DDD) and helps maintain a clear and consistent domain language.

- Repository interfaces define the contracts or interfaces for interacting with external data sources in the domain layer

- They abstract away the implementation details and provide a consistent way to access and manipulate data. Here are examples of repository interfaces

# EXAMPLE:

// domain/repositories/product_repository.dart

import 'package:your_app/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product> getProductById(String id);
  void saveProduct(Product product);
  void deleteProduct(String id);
}