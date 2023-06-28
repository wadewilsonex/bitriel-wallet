import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/widget/appbar_widget.dart';
import 'package:bitriel_wallet/standalone/utils/app_utils/global.dart';
import 'package:bitriel_wallet/standalone/utils/themes/colors.dart';

class PincodeBody extends StatelessWidget {
  
  final bool isFirst;
  final int pinLength;
  final String pinEntered;
  final List<int> numFirstRow;
  final List<int> numSecRow;
  final List<int> numThirdRow;
  final dynamic numberClicked;
  final dynamic backSpace;
  final Function? pinSetup;

  const PincodeBody({
    required this.isFirst,
    required this.pinLength,
    required this.pinEntered,
    required this.numFirstRow,
    required this.numSecRow,
    required this.numThirdRow,
    required this.numberClicked,
    required this.backSpace,
    required this.pinSetup,
    super.key
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBar(context, title: isFirst == true ? "Create a PIN" : "Confirm PIN"),
      body: Column(
        children: [
          _textHeader(),

          const Spacer(),

          _dotPin(),

          const Spacer(),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: numFirstRow.map((e) => _numPadButton(e)).toList()
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: numSecRow.map((e) => _numPadButton(e)).toList()
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: numThirdRow.map((e) => _numPadButton(e)).toList()
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Opacity(
                opacity: 0,
                child: AbsorbPointer(
                  absorbing: true,
                  child: _numPadButton(0),
                ),
              ),

              _numPadButton(0),

              InkWell(
                splashColor: hexaCodeToColor(AppColors.primary).withOpacity(0.25),
                highlightColor: hexaCodeToColor(AppColors.primary).withOpacity(0.25),
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                onTap: () => backSpace(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: SizedBox(
                    width: 50,
                    child: Icon(Iconsax.tag_cross, size: 30, color: hexaCodeToColor(AppColors.midNightBlue))
                  ),
                ),
              )
            ]
          ),

          const SizedBox(height: 25,)

        ],
      ),
    );
  }

  Widget _textHeader() {
    return SizedBox(
      height: 125,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MyText(
          text: isFirst == true ? "Enhance the security of your account by creating a PIN code" : "Repeat a PIN code to continue",
          color: AppColors.midNightBlue,
        ),
      ),
    );
  }

  Widget _dotPin() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: (pinEntered.isNotEmpty) 
            ?
            Icon(Iconsax.record_circle1, color: hexaCodeToColor(AppColors.primary),)
            :
            Icon(
              Iconsax.record_circle1, color: hexaCodeToColor("#9EA5B1"),
            )
          ),

          Padding(
            padding: const EdgeInsets.all(3.0),
            child: (pinEntered.length >= 2) 
            ?
            Icon(Iconsax.record_circle1, color: hexaCodeToColor(AppColors.primary),)
            :
            Icon(
              Iconsax.record_circle1, color: hexaCodeToColor("#9EA5B1"),
            )
          ),

          Padding(
            padding: const EdgeInsets.all(3.0),
            child: (pinEntered.length >= 3) 
            ?
            Icon(Iconsax.record_circle1, color: hexaCodeToColor(AppColors.primary),)
            :
            Icon(
              Iconsax.record_circle1, color: hexaCodeToColor("#9EA5B1"),
            )
          ),

          Padding(
            padding: const EdgeInsets.all(3.0),
            child: (pinEntered.length >= 4) 
            ?
            Icon(Iconsax.record_circle1, color: hexaCodeToColor(AppColors.primary),)
            :
            Icon(
              Iconsax.record_circle1, color: hexaCodeToColor("#9EA5B1"),
            )
          ),
          
        ],
      ),
    );
  }

  Widget _numPadButton(int item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          InkWell(
            splashColor: hexaCodeToColor(AppColors.primary).withOpacity(0.25),
            highlightColor: hexaCodeToColor(AppColors.primary).withOpacity(0.25),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onTap: () {
              pinEntered.length == pinLength ?
              null :
              numberClicked(item);

              pinSetup!();
            },
            child: SizedBox(
              width: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyText(
                  text: item.toString(), 
                  color: AppColors.midNightBlue,
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
