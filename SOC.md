# SEPARATION_OF_CONCERN

## ISSUES

Using the AccountRepositoryImpl directly in the presentation layer, instead of going through the CreateAccountUseCaseImpl, would tightly couple the presentation layer with the data layer. This approach violates the principles of separation of concerns and dependency inversion.

## REASON:
Here are a few reasons why it's preferable to use the CreateAccountUseCase abstraction instead of directly accessing the AccountRepositoryImpl:

    - Abstraction and Encapsulation: By using the CreateAccountUseCase interface, the presentation layer is only concerned with the high-level functionality provided by the use case. It doesn't need to know about the specific implementation details of the repository. This promotes abstraction and encapsulation, making the code more modular and maintainable.

    - Flexibility and Testability: By relying on the abstraction, you can easily swap out different implementations of the CreateAccountUseCase, such as a mock implementation for testing purposes or a different implementation with alternative business logic. This flexibility improves testability and makes it easier to modify or extend the system in the future.

    - Dependency Inversion Principle: The use of the CreateAccountUseCase abstraction follows the Dependency Inversion Principle, which states that high-level modules should not depend on low-level modules; both should depend on abstractions. By depending on the abstraction, you achieve a more flexible and loosely coupled architecture.

# SUMMARY:
Overall, using the CreateAccountUseCase abstraction provides better separation of concerns, promotes code reusability, improves testability, and follows established software design principles. It allows you to decouple the presentation layer from the specific implementation details of the data layer, providing a more maintainable and scalable architecture.