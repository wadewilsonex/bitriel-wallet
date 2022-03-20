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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Text(
          isFirst! ? 'Enter 6-Digits Code' : 'Re-enter 6-Digits Code',
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
        ),

        const SizedBox(
          height: 5,
        ),
        const SizedBox(
          height: 5,
        ),
        const SizedBox(height: 60),

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
        ReuseNumPad(pinIndexSetup!, clearPin!)
      ],
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
      width: 40.0,
      height: 40.0,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 1.0),
          border: outlineInputBorder,
          filled: true,
          fillColor: Colors.grey[300],
        ),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 42,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ReuseKeyBoardNum(1, () {
                  pinIndexSetup('1');
                }),
                ReuseKeyBoardNum(2, () {
                  pinIndexSetup('2');
                }),
                ReuseKeyBoardNum(3, () {
                  pinIndexSetup('3');
                }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ReuseKeyBoardNum(4, () {
                  pinIndexSetup('4');
                }),
                ReuseKeyBoardNum(5, () {
                  pinIndexSetup('5');
                }),
                ReuseKeyBoardNum(6, () {
                  pinIndexSetup('6');
                }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ReuseKeyBoardNum(7, () {
                  pinIndexSetup('7');
                }),
                ReuseKeyBoardNum(8, () {
                  pinIndexSetup('8');
                }),
                ReuseKeyBoardNum(9, () {
                  pinIndexSetup('9');
                }),
              ],
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const SizedBox(
                  width: 60.0,
                  child: MaterialButton(
                    onPressed: null,
                    child: SizedBox(),
                  ),
                ),
                ReuseKeyBoardNum(0, () {
                  pinIndexSetup('0');
                }),
                SizedBox(
                  width: 60,
                  child: MaterialButton(
                    height: 60,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                    onPressed: () {
                      clearPin();
                    },
                    child: Icon(
                      Icons.backspace,
                      color: isDarkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ReuseKeyBoardNum extends StatelessWidget {
  final int n;
  final Function() onPressed;

  const ReuseKeyBoardNum(this.n, this.onPressed);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70.0,
      alignment: Alignment.center,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        color: hexaCodeToColor(AppColors.secondary),
        padding: const EdgeInsets.all(8.0),
        onPressed: onPressed,
        height: 90,
        child: Text(
          '$n',
          style: TextStyle(
            fontSize: 24 * MediaQuery.of(context).textScaleFactor,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
