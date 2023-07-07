import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/standalone/utils/app_utils/global.dart';
import 'package:bitriel_wallet/standalone/utils/themes/colors.dart';

class DashboardMenuItem extends StatelessWidget {
  final String title;
  final String? asset;
  final Widget? icon;
  final Function? action;

  const DashboardMenuItem({
    Key? key,
    required this.title,
    this.asset,
    this.icon,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        action!();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.white),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
              Flexible(
                child: Align(
                  heightFactor: 1,
                  widthFactor: 1,
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(File(asset!)),
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                child: MyText(
                  text: title,
                  fontSize: 18,
                  color: AppColors.midNightBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

class ScrollMenuItem extends StatelessWidget {
  final String title;
  final String? asset;
  final Widget? icon;
  final Function? action;

  const ScrollMenuItem({
    Key? key,
    required this.title,
    this.asset,
    this.icon,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        action!();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: 30,
          decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.white),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              const SizedBox(width: 2,),

              Container(
                margin: const EdgeInsets.all(5),
                child: Image.asset(asset!, height: 25, width: 25,)
              ),

              MyText(
                text: title,
                fontSize: 15,
                color: AppColors.midNightBlue,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(width: 5,)
              
            ],
          ),
        ),
      ),
    );
  }
}

