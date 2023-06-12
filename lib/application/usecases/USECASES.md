# DEFINITION

Use cases encapsulate specific actions or operations that the application can perform. They orchestrate the collaboration between multiple domain entities and repositories to achieve a specific goal

# SAMPLE CODE

class LoginUseCase {
  UserRepository userRepository;
  AuthenticationService authService;

  LoginUseCase(this.userRepository, this.authService);

  Future<void> execute(String username, String password) async {
    // Perform input validation, if needed
    // ...

    // Retrieve user from repository
    final user = await userRepository.getUserByUsername(username);

    // Authenticate user
    final isAuthenticated = authService.authenticate(user, password);

    if (isAuthenticated) {
      // Perform further operations, such as session management
      // ...
    } else {
      throw Exception("Invalid credentials");
    }
  }
}