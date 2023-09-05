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

# More: 

The repository pattern helps to decouple the domain layer from the specific implementation details of the data layer. The repositories define contracts or interfaces that specify the available methods for data retrieval, storage, and manipulation. The concrete implementations of these repositories are usually located in the data layer.