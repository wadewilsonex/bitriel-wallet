import 'package:wallet_apps/index.dart';
import 'package:pinput/pinput.dart';

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


  @override
  Widget build(BuildContext context){
     
    return Scaffold(
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        title: MyText(
          text: "Passcode",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2),
        ),

        actions: [
          TextButton(
            onPressed: () {
              onPressedDigit!();
            }, 
            child: MyText(
              text: is4digits == false ? "Use 4-digits PIN" : "Use 6-digits PIN",
              color2: isFirst! == true || isNewPass == true ? hexaCodeToColor(AppColors.primaryColor) : hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],

      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: paddingSize),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [

            // Show AppBar Only In Landing Pages

            // if(label != null) Expanded(child: Container(),) 
            // else Container(),

            SizedBox(height: 10.h),

            if (titleStatus == null ) MyText(
              text: isFirst! ? 'Set up PIN' : 'Verify PIN',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ) 
            // For Change PIN
            else MyText(
              text: titleStatus,
              hexaColor: titleStatus == "Invalid PIN" ? AppColors.redColor : isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),

            SizedBox(
              height: 5.h,
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

            SizedBox(height: 5.h),

            is4digits == false ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                
                ReusePinNum(lsControl![0]),
                ReusePinNum(lsControl![1]),
                ReusePinNum(lsControl![2]),
                ReusePinNum(lsControl![3]),
                ReusePinNum(lsControl![4]),
                ReusePinNum(lsControl![5]),
              ],
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                
                ReusePinNum(lsControl![0]),
                ReusePinNum(lsControl![1]),
                ReusePinNum(lsControl![2]),
                ReusePinNum(lsControl![3]),
              ],
            ),

            Expanded(child: Container(),),

            ReuseNumPad(pinIndexSetup!, clearPin!),
            
            SizedBox(height: 10.h),
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
              fontSize: 17.sp,
              color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)
            )
          ),
          TextSpan(
            text: 'PIN ',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)
            )
          ),
          TextSpan(
            text: 'that will be required when opening in the future', 
            style: TextStyle(
              fontSize: 17.sp,
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
              fontSize: 17.sp,
              color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)
            )
          ),
          TextSpan(
            text: 'pin ',
            style: TextStyle(
              fontSize: 17.sp,
              color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)
            )
          ),
          TextSpan(
            text: 'code', 
            style: TextStyle(
              fontSize: 17.sp,
              color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)
            )
          ),
        ],
      ),
    ),
  ];
}


class ReusePinNum extends StatelessWidget {

  final TextEditingController textEditingController;

  const ReusePinNum(this.textEditingController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final borderColor = hexaCodeToColor(AppColors.primaryColor);

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
        fontSize: 30.sp,
        color: hexaCodeToColor(AppColors.primaryColor),
      ),
      decoration: const BoxDecoration(),
    );

    final preFilledWidget = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 3,
          decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );

    return Pinput(
      length: 1,
      obscureText: true,
      pinAnimationType: PinAnimationType.slide,
      controller: textEditingController,
      defaultPinTheme: defaultPinTheme,
      showCursor: false,
      preFilledWidget: preFilledWidget,
      useNativeKeyboard: false,
    );

    // return Flexible(
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: TextField(
    //       controller: textEditingController,
    //       enabled: false,
    //       obscureText: true,
    //       textAlign: TextAlign.center,
    //       maxLines: 1,
    //       minLines: 1,
    //       decoration: InputDecoration(
    //         isDense: true,
    //         // contentPadding: EdgeInsets.only(bottom: 53.sp, left: 7.sp),
    //         // border: InputBorder.none,
    //         border: OutlineInputBorder(
    //           borderRadius: BorderRadius.circular(8),
    //           gapPadding: 0
    //         ),
    //         filled: true,
    //         // border: OutlineInputBorder(),
    //         fillColor: Colors.white30
    //       ),
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         fontSize: 30.sp,
    //         color: hexaCodeToColor(AppColors.secondary)
    //       ),
    //     ),
    //   ),
    // );

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
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ReuseKeyBoardNum(1, () {
                pinIndexSetup('1');
              }),
              const SizedBox(width: 19),
              ReuseKeyBoardNum(2, () {
                pinIndexSetup('2');
              }),
              const SizedBox(width: 19),
              ReuseKeyBoardNum(3, () {
                pinIndexSetup('3');
              }),
            ],
          ),

          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              ReuseKeyBoardNum(4, () {
                pinIndexSetup('4');
              }),
              const SizedBox(width: 19),
              ReuseKeyBoardNum(5, () {
                pinIndexSetup('5');
              }),
              const SizedBox(width: 19),
              ReuseKeyBoardNum(6, () {
                pinIndexSetup('6');
              }),
            ],
          ),

          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              ReuseKeyBoardNum(7, () {
                pinIndexSetup('7');
              }),
              const SizedBox(width: 19),
              ReuseKeyBoardNum(8, () {
                pinIndexSetup('8');
              }),
              const SizedBox(width: 19),
              ReuseKeyBoardNum(9, () {
                pinIndexSetup('9');
              }),
            ],
          ),
          
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(child: Container()),
              // ReuseKeyBoardNum(null, null, child: Container()),
              const SizedBox(width: 19),
              ReuseKeyBoardNum(0, () {
                pinIndexSetup('0');
              }),
              const SizedBox(width: 19),
              ReuseKeyBoardNum(
                null, 
                () {
                  clearPin();
                },
                child: Transform.rotate(
                  angle: 70.6858347058,
                  child: Icon(Iconsax.shield_cross, color: hexaCodeToColor(isDarkMode ? AppColors.lowWhite : AppColors.lightGreyColor), size: 20.sp),
                ),
              )
            ],
          )
        ],
      ),
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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
          ),
          backgroundColor: MaterialStateProperty.all(isDarkMode ? Colors.white.withOpacity(0.06) : hexaCodeToColor(AppColors.whiteColorHexa))
        ),
        onPressed: onPressed,
        child: child == null ? Text(
          '$n',
          style: TextStyle(
            fontSize: 16.sp * MediaQuery.of(context).textScaleFactor,
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ) : child!,
      )
    );
  }
}
