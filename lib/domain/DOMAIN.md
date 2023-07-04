# DEFINITION

- The domain layer is responsible for defining the business logic of the application. 
- The Domain Layer represents the core business logic and entities

The domain layer contains the classes that represent the entities in the application, as well as the classes that define the operations that can be performed on those entities. The domain layer is also responsible for defining the rules that govern the behavior of the application.

Business logic is the set of rules that govern how an application works. It is responsible for ensuring that the application behaves in a consistent and predictable manner. Business logic is typically implemented in the domain layer.

# NOTE:

=> that the domain layer itself is often referred to as the "model".

/state folder: contain app state of selendra connection.

# REPOSTIRY vs USE_CASES

Using the AccountRepositoryImpl directly in the presentation layer, instead of going through the CreateAccountUseCaseImpl, would tightly couple the presentation layer with the data layer. This approach violates the principles of separation of concerns and dependency inversion.