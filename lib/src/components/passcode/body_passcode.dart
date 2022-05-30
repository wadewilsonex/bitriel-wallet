import 'package:wallet_apps/index.dart';

class PasscodeBody extends StatelessWidget{
  
  final bool? isFirst;
  final List<TextEditingController>? lsControl;
  final Function? pinIndexSetup;
  final Function? clearPin;

  PasscodeBody({this.isFirst, this.lsControl, this.pinIndexSetup, this.clearPin});

  final outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(80),
    borderSide: const BorderSide(
      color: Colors.transparent,
    ),
  );

  Widget build(BuildContext context){
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
          ),
          Text(
            isFirst! ? 'PIN!' : 'Verify PIN!',
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(
            height: 15,
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Assign a security ', 
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white
                    )
                  ),
                  TextSpan(
                    text: 'PIN ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    )
                  ),
                  TextSpan(
                    text: 'that will be required when opening in the future', 
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white
                    )
                  ),
                ],
              ),
            ),
          ), 
          const SizedBox(height: 80),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ReusePinNum(outlineInputBorder, lsControl![0]),
              ReusePinNum(outlineInputBorder, lsControl![1]),
              ReusePinNum(outlineInputBorder, lsControl![2]),
              ReusePinNum(outlineInputBorder, lsControl![3]),
              ReusePinNum(outlineInputBorder, lsControl![4]),
              ReusePinNum(outlineInputBorder, lsControl![5]),
            ],
          ),

          const SizedBox(height: 80),
          ReuseNumPad(pinIndexSetup!, clearPin!)
        ],
      )
    );
  }
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
          contentPadding: const EdgeInsets.only(bottom: -25.0, left: -1.5),
          border: outlineInputBorder,
          filled: true,
          fillColor: hexaCodeToColor(AppColors.passcodeColor),
        ),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 45,
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
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 29),
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
                    child: Icon(Iconsax.shield_cross, color: hexaCodeToColor(AppColors.bgdColor), size: 29),
                  ),
                )
              ],
            )
          ],
        ),
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
            fontSize: 24 * MediaQuery.of(context).textScaleFactor,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ) : child!,
      )
    );
  }
}
