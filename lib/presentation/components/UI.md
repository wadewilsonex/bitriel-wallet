# Function Widget vs New Class Widget

- The complexity of the widget: If the widget is complex, then using a new class object will be more efficient. This is because a new class object can be cached by the Flutter engine, while a function widget cannot.

- The number of times the widget is used: If the widget is only used once, then there is no need to create a new class object. In this case, using a function widget may be more concise and easier to read.

- The readability of the code: If the widget is complex, then using a new class object may make the code more readable. This is because a new class object can be broken down into smaller, more manageable pieces.