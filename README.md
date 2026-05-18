Todo_app_using_http

A Flutter application that performs CRUD operations using **Provider state management and **HTTP** requests with the DummyJSON API.

Name= Yeshak Tsegaye

ID= UGR/0585/16


Features

- Create new todos
- Read / view all todos (limit 5)
- Update todo title and completed status
- Delete todos
- Loading text indicator
- Error handling with messages

Screenshots

GET ALL
![GET ALL](screenshots/get_all.png)

GET SINGLE
![GET SINGLE](screenshots/get_single.png)

CREATE
![CREATE](screenshots/create_new.png)

UPDATE
![UPDATE](screenshots/update.png)

DELETE
![DELETE](screenshots/delete.png)

Loading
![Loading](screenshots/loading.png)



Project Structure

lib/
├── models/
│ └── todo.dart
├── providers/
│ └── todo_provider.dart
├── screens/
│ └── home_screen.dart
├── services/
│ └── api_service.dart
└── main.dart


Requirements Fulfilled

- Provider for state management  
- http for network requests  
- Clean project structure  
- Full CRUD operations  
- Loading states (text indicator)  
- Error handling