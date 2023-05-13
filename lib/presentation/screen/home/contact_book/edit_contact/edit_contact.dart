// import 'package:wallet_apps/index.dart';
// import 'package:wallet_apps/src/constants/db_key_con.dart';
// import 'package:wallet_apps/src/models/contact_book_m.dart';
// import 'package:wallet_apps/src/screen/home/contact_book/edit_contact/body_edit_contact.dart';

// class EditContact extends StatefulWidget {
//   final List<ContactBookModel>? contact;
//   final int? index;

//   const EditContact({Key? key, this.contact, this.index}) : super(key: key);

//   @override
//   EditContactState createState() => EditContactState();
// }

// class EditContactState extends State<EditContact> {
//   ContactBookModel _addContactModel = ContactBookModel();

//   List<Map<String, dynamic>> contactData = [];

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

//       final result = await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0)),
//             content: const Padding(
//               padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//               child: Text("Are you sure to edit this contact?"),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Close'),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   widget.contact![widget.index!] = _addContactModel;

//                   for (final data in widget.contact!) {
//                     contactData.add({
//                       'username': data.userName.text,
//                       'phone': data.contactNumber.text,
//                       'address': data.address.text,
//                       'memo': data.memo.text
//                     });
//                   }
//                   await StorageServices.storeData(contactData, DbKey.contactList);
                  
//                   if(!mounted) return;
//                   Navigator.pop(context, true);
//                 },
//                 child: const Text("Yes"),
//               )
//             ],
//           );
//         },
//       );

//       // await dialog("Are you sure to edit this contact?", "Message",
//       //     // ignore: deprecated_member_use
//       //     action: FlatButton(
//       //       onPressed: () async {
//       //         widget.contact[widget.index] = _addContactModel;

//       //         for (final data in widget.contact) {
//       //           contactData.add({
//       //             'username': data.userName.text,
//       //             'phone': data.contactNumber.text,
//       //             'address': data.address.text,
//       //             'memo': data.memo.text
//       //           });
//       //         }
//       //         await StorageServices.setData(contactData, 'contactList');

//       //         Navigator.pop(context, true);
//       //       },
//       //       child: const Text("Yes"),
//       //     ));

//       // Close Dialog Loading
//       if(!mounted) return;
//       Navigator.pop(context);

//       if (result == true) {
//         await showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0)),
//               title: const Align(
//                 child: Text('Congratulation'),
//               ),
//               content: const Padding(
//                 padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                 child: Text("Successfully edit contact!\n Please check your contact book"),
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Close'),
//                 ),
//               ],
//             );
//           },
//         );
//         // await dialog(
//         //   "Successfully edit contact!\n Please check your contact book",
//         //   "Congratualtion",
//         // );
//         // Close Screen
//         if(!mounted) return;
//         Navigator.pop(context, true);
//       } else {
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       // Close Dialog Loading
//       Navigator.pop(context);
//     }
//   }

//   String? onChanged(String value) {
//     allValidator();
//     return value;
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

//   String? validateAddress(String value) {
//     if (_addContactModel.addressNode.hasFocus) {
//       if (value.isEmpty) {
//         return 'Please fill in address';
//       }
//     }
//     return null;
//   }

//   @override
//   void initState() {
//     _addContactModel = widget.contact![widget.index!];
//     allValidator();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BodyScaffold(
//         height: MediaQuery.of(context).size.height,
//         child: EditContactBody(
//           model: _addContactModel,
//           validateAddress: (String? value){
//             return validateAddress(value!)!;
//           },
//           onChanged: (String? value){
//             return onChanged(value!)!;
//           },
//           onSubmit: onSubmit,
//           submitContact: submitContact,
//         ),
//       ),
//     );
//   }
// }
