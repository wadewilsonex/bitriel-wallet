import 'package:wallet_apps/index.dart';

class TrxActivityBody extends StatelessWidget{

  final List<dynamic>? activityList;
  final void Function()? popScreen;

  const TrxActivityBody({
    Key? key, 
    this.activityList,
    this.popScreen
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MyAppBar(
          title: "My activity",
          onPressed: popScreen,
        ),
        Expanded(
          child: buildListBody(activityList!),
        )
      ],
    );
  }

}