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
    this.titleStatus,
    this.subStatus,
    this.isNewPass = false,
    this.label, this.isFirst, this.lsControl, this.pinIndexSetup, this.clearPin, this.is4digits, this.onPressedDigit});

  final outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(80),
    borderSide: const BorderSide(
      color: Colors.transparent,
    ),
  );

  Widget build(BuildContext context){
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      body: Container(
        // color: Colors.red,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: paddingSize),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [

            // Show AppBar Only In Landing Pages
            if(label != PassCodeLabel.fromCreateSeeds && label != PassCodeLabel.fromImportSeeds) MyAppBar(
              title: "Passcode",
              onPressed: () {
                Navigator.pop(context);
              },
            ) 
            else Container(),

            if(label != null) Expanded(child: Container(),) 
            else Container(),

            if (titleStatus == null ) MyText(
              text: isFirst! ? 'PIN!' : 'Verify PIN!',
              color: AppColors.whiteColorHexa,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ) 
            // For Change PIN
            else MyText(
              text: titleStatus,
              color: titleStatus == "Invalid PassCode" ? AppColors.redColor : AppColors.whiteColorHexa,
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
              color: AppColors.whiteColorHexa,
              fontWeight: FontWeight.bold,
            ), 

            SizedBox(height: 5.h),

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

            SizedBox(height: 5.h),

            TextButton(
              onPressed: () {
                onPressedDigit!();
              }, 
              child: MyText(
                text: is4digits == false ? "Use 4 digits passcode" : "Use 6 digits passcode",
                color2: isFirst! == true || isNewPass == true ? hexaCodeToColor(AppColors.primaryColor) : hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0),
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 2.h),
            ReuseNumPad(pinIndexSetup!, clearPin!),
            
            SizedBox(height: 10.h),
          ],
        ),
      )
    );
  }

  

  List<RichText> passCodeContents = [

    RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'Assign a security ', 
            style: TextStyle(
              fontSize: 17.sp,
              color: Colors.white
            )
          ),
          TextSpan(
            text: 'PIN ',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white
            )
          ),
          TextSpan(
            text: 'that will be required when opening in the future', 
            style: TextStyle(
              fontSize: 17.sp,
              color: Colors.white
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
              color: Colors.white
            )
          ),
          TextSpan(
            text: 'pin ',
            style: TextStyle(
              fontSize: 17.sp,
              color: Colors.white
            )
          ),
          TextSpan(
            text: 'code', 
            style: TextStyle(
              fontSize: 17.sp,
              color: Colors.white
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

  const ReusePinNum(this.outlineInputBorder, this.textEditingController);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20.0,
      height: 20.0,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: -16.0.sp, left: -5.sp),
          border: outlineInputBorder,
          filled: true,
          fillColor: hexaCodeToColor(AppColors.passcodeColor),
        ),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 29.sp,
          color: hexaCodeToColor(
            AppColors.secondary,
          ),
        ),
      ),
    );
  }
}

class ReuseNumPad extends StatelessWidget {

  final Function pinIndexSetup;
  final Function clearPin;

  const ReuseNumPad(this.pinIndexSetup, this.clearPin);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildNumberPad(context),
    );
  }

  Widget _buildNumberPad(context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context, listen: false).isDark;
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ReuseKeyBoardNum(1, () {
                pinIndexSetup('1');
              }),
              SizedBox(width: 19),
              ReuseKeyBoardNum(2, () {
                pinIndexSetup('2');
              }),
              SizedBox(width: 19),
              ReuseKeyBoardNum(3, () {
                pinIndexSetup('3');
              }),
            ],
          ),

          SizedBox(height: 10),
          Row(
            children: <Widget>[
              ReuseKeyBoardNum(4, () {
                pinIndexSetup('4');
              }),
              SizedBox(width: 19),
              ReuseKeyBoardNum(5, () {
                pinIndexSetup('5');
              }),
              SizedBox(width: 19),
              ReuseKeyBoardNum(6, () {
                pinIndexSetup('6');
              }),
            ],
          ),

          SizedBox(height: 10),
          Row(
            children: <Widget>[
              ReuseKeyBoardNum(7, () {
                pinIndexSetup('7');
              }),
              SizedBox(width: 19),
              ReuseKeyBoardNum(8, () {
                pinIndexSetup('8');
              }),
              SizedBox(width: 19),
              ReuseKeyBoardNum(9, () {
                pinIndexSetup('9');
              }),
            ],
          ),
          
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(child: Container()),
              // ReuseKeyBoardNum(null, null, child: Container()),
              SizedBox(width: 19),
              ReuseKeyBoardNum(0, () {
                pinIndexSetup('0');
              }),
              SizedBox(width: 19),
              ReuseKeyBoardNum(
                null, 
                () {
                  clearPin();
                },
                child: Transform.rotate(
                  angle: 70.6858347058,
                  child: Icon(Iconsax.shield_cross, color: hexaCodeToColor(AppColors.lowWhite), size: 20.sp),
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

  const ReuseKeyBoardNum(this.n, this.onPressed, {this.child});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
          ),
          backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.06))
        ),
        onPressed: onPressed,
        child: child == null ? Text(
          '$n',
          style: TextStyle(
            fontSize: 16.sp * MediaQuery.of(context).textScaleFactor,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ) : child!,
      )
    );
  }
}
