# DEFINITION

Value Objects: The value_objects directory contains classes representing immutable values that are used within the domain entities. These values typically enforce specific rules or constraints and are shared across multiple entities.

Example email.dart code in the value_objects directory:

class Email {
  final String value;

  Email(this.value) {
    // Validate the email value and enforce any constraints
  }

  // Additional methods and behavior specific to the Email value object
}