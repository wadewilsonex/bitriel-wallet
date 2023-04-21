import 'package:wallet_apps/index.dart';

class WalletConnectMenuItem extends StatelessWidget {
  final String? title;
  final Function? action;
  final String? image;
  
  const WalletConnectMenuItem({Key? key, 
    this.title,
    @required this.action,
    this.image,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(image!),
        ),
        title: MyText(
          text: title,
          fontWeight: FontWeight.w700,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
        trailing: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async{
              action!();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: hexaCodeToColor(AppColors.warningColor),
                borderRadius: BorderRadius.circular(10)
              ),
              child: const MyText(text: "Disconnect", hexaColor: AppColors.whiteColorHexa)
            ),
          ),
        ),
      ),
    );
  }
}