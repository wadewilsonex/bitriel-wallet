// import 'package:fluttercontactpicker/fluttercontactpicker.dart';
// import 'package:wallet_apps/index.dart';
// import 'package:wallet_apps/src/constants/db_key_con.dart';
// import 'package:wallet_apps/src/models/contact_book_m.dart';
// import 'package:wallet_apps/src/screen/home/contact_book/add_contact/body_add_contact.dart';

// class AddContact extends StatefulWidget {
//   final PhoneContact? contact;

//   const AddContact({Key? key, this.contact}) : super(key: key);

//   @override
//   AddContactState createState() => AddContactState();
// }

// class AddContactState extends State<AddContact> {
//   final ContactBookModel _addContactModel = ContactBookModel();

//   // Future<void> dialog(String text1, String text2, {Widget action}) async {
//   //   await showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         shape:
//   //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//   //         title: Align(
//   //           child: Text(text1),
//   //         ),
//   //         content: Padding(
//   //           padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//   //           child: Text(text2),
//   //         ),
//   //         actions: <Widget>[
//   //           FlatButton(
//   //             onPressed: () => Navigator.pop(context),
//   //             child: const Text('Close'),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }

//   Future<void> submitContact() async {
//     try {
//       // Show Loading
//       dialogLoading(context);

//       await Future.delayed(const Duration(seconds: 1), () {});
//       final Map<String, dynamic> contactData = {
//         'username': _addContactModel.userName.text,
//         'phone': _addContactModel.contactNumber.text,
//         'address': _addContactModel.address.text,
//         'memo': _addContactModel.memo.text
//       };

//       await StorageServices.addMoreData(contactData, DbKey.contactList);

//       // Close Dialog Loading
//       if(!mounted) return;
//       Navigator.pop(context);

//       await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0)),
//             title: const Align(
//               child: Text("Congratulation"),
//             ),
//             content: const Padding(
//               padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//               child: Text(
//                   "Successfully add new contact!\n Please check your contact book"),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   Navigator.pop(context, true);
//                 },
//                 child: const Text('Close'),
//               ),
//             ],
//           );
//         },
//       );

//       // await dialog(
//       //     "Successfully add new contact!\n Please check your contact book",
//       //     "Congratualtion");
//       // Close Screen
//       // Navigator.pop(context, true);
//     } catch (e) {
//       // Close Dialog Loading
//       Navigator.pop(context);
//       if (ApiProvider().isDebug == true) {
//         if (kDebugMode) {
//           debugPrint("Error submitContact $e");
//         }
//       }
//     }
//   }

//   String? onChanged(String value) {
//     allValidator();
//     return value;
//   }

//   Future<bool> validateAddressF(String address) async {
//     final res = await Provider.of<ApiProvider>(context, listen: false).validateAddress(address);
//     return res;
//   }

//   Future<void> onSubmit() async {
//     if (_addContactModel.contactNumberNode.hasFocus) {
//       FocusScope.of(context).requestFocus(_addContactModel.userNameNode);
//     } else if (_addContactModel.userNameNode.hasFocus) {
//       FocusScope.of(context).requestFocus(_addContactModel.addressNode);
//     } else if (_addContactModel.addressNode.hasFocus) {
//       FocusScope.of(context).requestFocus(_addContactModel.memoNode);
//     } else {
//       if (_addContactModel.enable) await submitContact();
//     }
//   }

//   void allValidator() {
//     if (_addContactModel.contactNumber.text.isNotEmpty &&
//         _addContactModel.userName.text.isNotEmpty &&
//         _addContactModel.address.text.isNotEmpty) {
//       setState(() {
//         _addContactModel.enable = true;
//       });
//     } else if (_addContactModel.enable) {
//       setState(() {
//         _addContactModel.enable = false;
//       });
//     }
//   }

//   String? validateAddress(String? value) {
//     return null;
//   }

//   @override
//   void initState() {
//     _addContactModel.contactNumber.text = widget.contact!.phoneNumber!.number!;
//     _addContactModel.userName.text = widget.contact!.fullName!;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BodyScaffold(
//         height: MediaQuery.of(context).size.height,
//         child: AddContactBody(
//           model: _addContactModel,
//           validateAddress: validateAddress,
//           onChanged: onChanged,
//           onSubmit: onSubmit,
//           submitContact: submitContact,
//         ),
//       ),
//     );
//   }
// }
