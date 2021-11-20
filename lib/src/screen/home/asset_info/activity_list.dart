import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/activity_item.dart';
import 'package:wallet_apps/src/screen/home/transaction/activity/activity_detail.dart';

class ActivityList extends StatelessWidget {
  final List<TransactionInfo>? transactionInfo;
  const ActivityList({
    Key? key,
    @required this.transactionInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactionInfo!.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                RouteAnimation(
                    enterPage: ActivityDetail(
                  trxInfo: transactionInfo![index],
                )));
          },
          child: ActivityItem(transactionInfo![index]),
        );
      },
    );
  }
}
