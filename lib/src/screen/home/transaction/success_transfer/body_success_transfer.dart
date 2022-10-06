import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/ticket_c.dart';

class SuccessTransferBody extends StatelessWidget {
  const SuccessTransferBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _headerWidget(context),
          _detailTrxWidget(context),
        ],
      ),
    );
  }

  Widget _headerWidget(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: paddingSize + 50),
            child: Icon(Iconsax.tick_circle, color: Colors.green, size: 40.sp,),
          ),
          MyText(text: "Success", fontSize: 18, fontWeight: FontWeight.bold,)
        ],
      ),
    );
  }

  Widget _detailTrxWidget(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 220,
            margin: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            child: CustomPaint(
              painter: TicketPainter(
                borderColor: Colors.transparent,
                bgColor: hexaCodeToColor(isDarkMode ? AppColors.defiMenuItem : AppColors.whiteColorHexa)
              ),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

}