// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:wallet_apps/index.dart';
// import 'package:http/http.dart' as http;

// class MongoDbService {

//   Future<void> signUp() async {
//     print("Hello my db");
//     try {
//       await http.post(
//         Uri.parse('https://airdropv2-api.selendra.org/auth/register'),
//         headers: {"Content-Type": "application/json; charset=utf-8"},
//         body: json.encode({
//           "email": "condaveat@gmail.com",
//           "password": "123456",
//           "wallet": "helloworld"
//         })
//       ).then((value) {
//         print("Hello value ${value.body}");
//       });

//       // var db = Db(AppConfig.mongoUrl);
//       // await db.open().then((value) {
//       //   print("Hello my db openDb $value");
//       // });
//       // print("Done connect to mongo");
//     } catch (e) {
//       print("Error openDb $e");
//     }
//   }

//   Future<void> signUp() async {
//     print("Hello my db");
//     try {
//       await http.post(
//         Uri.parse('https://airdropv2-api.selendra.org/auth/register'),
//         headers: {"Content-Type": "application/json; charset=utf-8"},
//         body: json.encode({
//           "email": "condaveat@gmail.com",
//           "password": "123456",
//           "wallet": "helloworld"
//         })
//       ).then((value) {
//         print("Hello value ${value.body}");
//       });

//       // var db = Db(AppConfig.mongoUrl);
//       // await db.open().then((value) {
//       //   print("Hello my db openDb $value");
//       // });
//       // print("Done connect to mongo");
//     } catch (e) {
//       print("Error openDb $e");
//     }
//   }
// }