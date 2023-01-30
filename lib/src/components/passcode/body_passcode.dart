import 'package:wallet_apps/index.dart';

class PasscodeBody extends StatelessWidget{
  
  final String? titleStatus;
  final String? subStatus;
  final PassCodeLabel? label;
  final bool? isFirst;
  final List<TextEditingController>? lsControl;
  final Function? pinIndexSetup;
  final Function? clearPin;
  final bool? is4digits;
  final bool? isNewPass;
  final Function? onPressedDigit;

  PasscodeBody({
    Key? key, 
    this.titleStatus,
    this.subStatus,
    this.isNewPass = false,
    this.label, this.isFirst, this.lsControl, this.pinIndexSetup, this.clearPin, this.is4digits, this.onPressedDigit
  }) : super(key: key);

  final outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(11.4.vmax),
    borderSide: const BorderSide(
      color: Colors.transparent,
    ),
  );

  @override
  Widget build(BuildContext context){
     
    return Scaffold(
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      appBar: secondaryAppBar(
        context: context, 
        title: MyText(
          text: "Passcode",
          fontSize: 2.4,
          fontWeight: FontWeight.w600,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
        )
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: paddingSize),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [

            // Show AppBar Only In Landing Pages

            if(label != null) Expanded(child: Container(),) 
            else Container(),

            if (titleStatus == null ) MyText(
              text: isFirst! ? 'PIN' : 'Verify PIN',
              fontSize: 3.2,
              fontWeight: FontWeight.bold,
            ) 
            // For Change PIN
            else MyText(
              text: titleStatus,
              hexaColor: titleStatus == "Invalid PassCode" ? AppColors.redColor : isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),

            SizedBox(
              height: 5.vmax,
            ),
            
            if (subStatus == null) Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (label == PassCodeLabel.fromSplash)
                passCodeContents[1]
                else 
                passCodeContents[0]
              ],
            ) 
            // For Change PIN
            else MyText(
              text: subStatus,
              hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.darkGrey,
              fontWeight: FontWeight.bold,
            ), 

            SizedBox(height: 5.vmax),

            is4digits == false ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                
                ReusePinNum(outlineInputBorder, lsControl![0]),
                ReusePinNum(outlineInputBorder, lsControl![1]),
                ReusePinNum(outlineInputBorder, lsControl![2]),
                ReusePinNum(outlineInputBorder, lsControl![3]),
                ReusePinNum(outlineInputBorder, lsControl![4]),
                ReusePinNum(outlineInputBorder, lsControl![5]),
              ],
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                
                ReusePinNum(outlineInputBorder, lsControl![0]),
                ReusePinNum(outlineInputBorder, lsControl![1]),
                ReusePinNum(outlineInputBorder, lsControl![2]),
                ReusePinNum(outlineInputBorder, lsControl![3]),
              ],
            ),

            SizedBox(height: 5.vmax),

            TextButton(
              style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
              onPressed: () {
                onPressedDigit!();
              }, 
              child: MyText(
                text: is4digits == false ? "Switch to 4 digits passcode" : "Switch to 6 digits passcode",
                color2: isFirst! == true || isNewPass == true ? hexaCodeToColor(AppColors.primaryColor) : hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0),
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 2.vmax),
            ReuseNumPad(pinIndexSetup!, clearPin!),
            
            SizedBox(height: 10.vmax),
          ],
        ),
      )
    );
  }
  
  final List<RichText> passCodeContents = [

    RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'Assign a security ', 
            style: TextStyle(
              fontSize: 2.8.vmax,
              color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)
            )
          ),
          TextSpan(
            text: 'PIN ',
            style: TextStyle(
              fontSize: 2.8.vmax,
              fontWeight: FontWeight.bold,
              color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)
            )
          ),
          TextSpan(
            text: 'that will be required when opening in the future', 
            style: TextStyle(
              fontSize: 2.8.vmax,
              color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)
            )
          ),
        ],
      ),
    ),

    RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'Enter ', 
            style: TextStyle(
              fontSize: 2.8.vmax,
              color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)
            )
          ),
          TextSpan(
            text: 'pin ',
            style: TextStyle(
              fontSize: 2.8.vmax,
              color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)
            )
          ),
          TextSpan(
            text: 'code', 
            style: TextStyle(
              fontSize: 2.8.vmax,
              color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)
            )
          ),
        ],
      ),
    ),
  ];
}


class ReusePinNum extends StatelessWidget {
  final OutlineInputBorder outlineInputBorder;

  final TextEditingController textEditingController;

  const ReusePinNum(this.outlineInputBorder, this.textEditingController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      enabled: false,
      obscureText: true,
      textAlign: TextAlign.center,
      maxLines: 1,
      minLines: 1,
      scrollPadding: EdgeInsets.zero,
      decoration: InputDecoration(
        constraints: BoxConstraints.expand(width: 7.14.vmax, height: 7.14.vmax),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 0.1.vmax),//EdgeInsets.only(bottom: 7.5.vmax, left: 1.vmax),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1.2.vmax),
          gapPadding: 0
        ),
        filled: true,
        // border: OutlineInputBorder(),
        fillColor: Colors.white30
      ),
      style: TextStyle(
        letterSpacing: 0,
        wordSpacing: 0,
        height: 1.2,
        fontWeight: FontWeight.bold,
        fontSize: 5.vmax,
        color: hexaCodeToColor(AppColors.secondary),
        decoration: TextDecoration.none
      ),
    );
    // return SizedBox(
    //   width: 20.0,
    //   height: 20.0,
    //   child: TextField(
    //     controller: textEditingController,
    //     enabled: false,
    //     obscureText: true,
    //     textAlign: TextAlign.center,
    //     decoration: InputDecoration(
    //       contentPadding: EdgeInsets.only(bottom: -50.sp, left: -7.sp),
    //       border: outlineInputBorder,
    //       filled: true,
    //       fillColor: hexaCodeToColor(AppColors.passcodeColor),
    //     ),
    //     style: TextStyle(
    //       fontWeight: FontWeight.bold,
    //       fontSize: 40.sp,
    //       color: hexaCodeToColor(
    //         AppColors.secondary,
    //       ),
    //     ),
    //   ),
    // );
  }
}

class ReuseNumPad extends StatelessWidget {

  final Function pinIndexSetup;
  final Function clearPin;

  const ReuseNumPad(this.pinIndexSetup, this.clearPin, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildNumberPad(context),
    );
  }

  Widget _buildNumberPad(context) {
    return Column(
      children: <Widget>[

        Row(
          children: <Widget>[
            ReuseKeyBoardNum(1, () {
              pinIndexSetup('1');
            }),
            SizedBox(width: 2.71.vmax),
            ReuseKeyBoardNum(2, () {
              pinIndexSetup('2');
            }),
            SizedBox(width: 2.71.vmax),
            ReuseKeyBoardNum(3, () {
              pinIndexSetup('3');
            }),
          ],
        ),

        SizedBox(height: 1.4.vmax),
        Row(
          children: <Widget>[
            ReuseKeyBoardNum(4, () {
              pinIndexSetup('4');
            }),
            SizedBox(width: 2.71.vmax),
            ReuseKeyBoardNum(5, () {
              pinIndexSetup('5');
            }),
            SizedBox(width: 2.71.vmax),
            ReuseKeyBoardNum(6, () {
              pinIndexSetup('6');
            }),
          ],
        ),

        SizedBox(height: 1.4.vmax),
        Row(
          children: <Widget>[
            ReuseKeyBoardNum(7, () {
              pinIndexSetup('7');
            }),
            SizedBox(width: 2.71.vmax),
            ReuseKeyBoardNum(8, () {
              pinIndexSetup('8');
            }),
            SizedBox(width: 2.71.vmax),
            ReuseKeyBoardNum(9, () {
              pinIndexSetup('9');
            }),
          ],
        ),
        
        SizedBox(height: 1.4.vmax),
        Row(
          children: <Widget>[
            
            Expanded(child: Container()),
            // ReuseKeyBoardNum(null, null, child: Container()),
            SizedBox(width: 2.71.vmax),
            ReuseKeyBoardNum(0, () {
              pinIndexSetup('0');
            }),
            SizedBox(width: 2.71.vmax),
            ReuseKeyBoardNum(
              null, 
              () {
                clearPin();
              },
              child: Transform.rotate(
                angle: 70.6858347058,
                child: Icon(Iconsax.shield_cross, color: hexaCodeToColor(isDarkMode ? AppColors.lowWhite : AppColors.lightGreyColor), size: 2.85.vmax),
              ),
            )
          ],
        )
      ],
    );
  }
}

class ReuseKeyBoardNum extends StatelessWidget {

  final int? n;
  final Widget? child;
  final Function()? onPressed;

  const ReuseKeyBoardNum(this.n, this.onPressed, {Key? key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.14.vmax))
          ),
          backgroundColor: MaterialStateProperty.all(isDarkMode ? Colors.white.withOpacity(0.06) : hexaCodeToColor(AppColors.whiteColorHexa))
        ),
        onPressed: onPressed,
        child: child == null ? Text(
          '$n',
          style: TextStyle(
            fontSize: 2.4.vmax * MediaQuery.of(context).textScaleFactor,
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ) : child!,
      )
    );
  }
}
