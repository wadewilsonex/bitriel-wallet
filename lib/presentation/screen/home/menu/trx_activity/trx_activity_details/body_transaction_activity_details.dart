import 'package:wallet_apps/index.dart';

Widget transactionActivityDetailsBody(BuildContext context, Map<String, dynamic> trxInfo, Function popScreen) {
  return Container(
    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        myAppBar(
          context,
          title: "Activity details"
        ),
        // Container( /* Activity Information */
        //   margin: EdgeInsets.only(top: 30.0),
        //   child: Column(
        //     children: <Widget>[
        //       rowInformation("Receipt no: ", _trxInfo['receipt_no']),
        //       rowInformation("Location: ", _trxInfo['location']),
        //       rowInformation("Amount: ", _trxInfo['amount']),
        //       rowInformation("Rewards: ", _trxInfo['rewards']),
        //       rowInformation("Status", _trxInfo['status']),
        //       rowInformation("Created date: ", AppUtils.timeStampToDateTime(_trxInfo['created_at'])),
        //       // Divider(height: 1, color: Colors.white.withOpacity(0.1), thickness: 1.0,),
        //     ],
        //   ),
        // )
      ],
    ),
  );
}
