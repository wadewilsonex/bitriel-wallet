// import 'package:wallet_apps/index.dart';

// class TrxHistoryList extends StatelessWidget {
//   final Widget? icon;
//   final String? title; 
//   final String? address;
//   final String? amount;
//   final String? dateTime;
  
//   const TrxHistoryList({
//     Key? key,
//     this.icon,
//     this.title,
//     this.address,
//     this.amount,
//     this.dateTime,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: hexaCodeToColor(AppColors.bluebgColor),
//         child: icon,
//       ),
//       title: MyText(text: title, color: AppColors.whiteColorHexa, fontWeight: FontWeight.bold, fontSize: 16, textAlign: TextAlign.start,),
//       trailing: MyText(text: amount, color: AppColors.redColor, fontWeight: FontWeight.bold, fontSize: 16, textAlign: TextAlign.end),
//       subtitle: MyText(text: dateTime, color: AppColors.greyColor, textAlign: TextAlign.start),
//     );
//   }
// }

import 'package:wallet_apps/index.dart';

class TrxHistoryList extends StatelessWidget {
  final Widget? icon;
  final String? title; 
  final String? address;
  final String? amount;
  final String? dateTime;
  final Function? action;
  
  const TrxHistoryList({
    Key? key,
    this.icon,
    this.title,
    this.address,
    this.amount,
    this.dateTime,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = List.generate(
      10,
      (index) => {"title": "Transfer seDd.....dj3p", "subtitle": "22-08-2022 10:36", "trailing": "-100 SEL"}
    );

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(
          backgroundColor: hexaCodeToColor(AppColors.bluebgColor),
          child: icon,
        ),
        title: MyText(text: items[index]["title"], color: AppColors.whiteColorHexa, fontWeight: FontWeight.bold, fontSize: 16, textAlign: TextAlign.start,),
        trailing: MyText(text: items[index]["trailing"], color: AppColors.redColor, fontWeight: FontWeight.bold, fontSize: 16, textAlign: TextAlign.end),
        subtitle: MyText(text: items[index]["subtitle"], color: AppColors.greyColor, textAlign: TextAlign.start),
        onTap: () {
          action!();
        },
      ),
    );
  }
}