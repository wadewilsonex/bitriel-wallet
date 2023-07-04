# STRUCTURE
├── lib/
│   ├── data/
|   |   ├── api
|   |   |   └── api.dart
│   │   ├── repositories/
│   │   │   └── account_repository.dart
│   │   └── sdk/
│   │       └── bitriel_sdk.dart
|   |
│   ├── domain/
│   │   ├── entities/
│   │   │   └── account.dart
│   │   ├── models/
│   │   │   ├── account_model.dart
│   │   │   └── mnemonic_model.dart
│   │   ├── repositories/
│   │   │   └── account_repository.dart
│   │   |── use_cases/
│   │   |   ├── create_account_use_case.dart
│   │   |   └── import_account_use_case.dart
│   │   └── validator/
|   |       └── form_validate.dart
|   |
│   ├── presentation/
│   │   ├── providers/
│   │   │   └── account_provider.dart
│   │   ├── screens/
│   │   │   ├── create_account_screen.dart
│   │   │   └── import_account_screen.dart
│   │   └── widgets/
│   │       ├── account_card.dart
│   │       └── mnemonic_form.dart
|   |
│   └── standalone/
│       ├── utils/
│       │   └── utility_file.dart
│       ├── components/
│       │   └── component_file.dart
│       └── widgets/
│           └── widget_file.dart
|   
├── pubspec.yaml
└── README.md

# Flow
Data <- Repository <- Usecases <- Provider <- Presentation