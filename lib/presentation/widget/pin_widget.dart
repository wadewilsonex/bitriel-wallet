import 'package:bitriel_wallet/index.dart';

class DotPin extends StatelessWidget {

  final ValueNotifier<String>? txt;

  const DotPin({super.key, this.txt});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Column(
        children: [
          
          // Expanded(
          //   child: ValueListenableBuilder(
          //     valueListenable: txt!, 
          //     builder: (context, value, wg){
          //       print("DotPin ValueListenableBuilder");
          //       return value.isEmpty ? const SizedBox() : const Icon(Icons.circle, color: Color(0xFFF29F05),);
          //     }
          //   ),
          // ),

          Expanded(
            child: ValueListenableBuilder(
              valueListenable: txt!, 
              builder: (context, value, wg){
                return txt!.value.isEmpty ? const SizedBox() : Icon(Icons.circle, color: hexaCodeToColor(AppColors.primary));
              }
            ),
          ),
    
          Container(
            height: 5,
            decoration: BoxDecoration(
              color: hexaCodeToColor(AppColors.primary).withOpacity(0.5)
            ),
          ),

        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ReuseNumPad extends StatelessWidget {

  int startNumber;
  final Function? pinIndexSetup;
  final Function? clearPin;

  ReuseNumPad({
    super.key,
    this.startNumber = -1,
    this.pinIndexSetup,
    this.clearPin,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[

        startNumber != 0 ? ReuseKeyBoardNum(
          n: startNumber,
          onPressed: pinIndexSetup,
        ) : const Expanded(child: SizedBox(),),
        const SizedBox(width: 19),

        ReuseKeyBoardNum(
          n: startNumber != 0 ? ++startNumber : startNumber,
          onPressed: pinIndexSetup,
        ),
        const SizedBox(width: 19),

        // If startNumber != 0: Mean Among number 1-9
        // Else Mean Back Or Remove 1 Pin Button
        ReuseKeyBoardNum(
          n: (startNumber != 0) ? (++startNumber) : -1,
          onPressed: startNumber != 0 ? pinIndexSetup : clearPin,
          child: startNumber == 0 ? Transform.rotate(
            angle: 70.6858347058,
            child: Icon(Iconsax.shield_cross, color: hexaCodeToColor(isDarkMode ? AppColors.lowWhite : AppColors.lightGreyColor), size: 30),
          ) : null,
        ),
        
      ],
    );
  }
}

class ReuseKeyBoardNum extends StatelessWidget {

  final int? n;
  final Function? onPressed;
  final Widget? child;

  const ReuseKeyBoardNum({super.key, this.n, this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          if (n == -1){
            // Clear All
            await onPressed!();
          }
          else {
            onPressed!(context, '$n');
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white
          ),
          child: child ?? Text(
            '$n',
            style: const TextStyle(
              fontSize: 30,// * MediaQuery.of(context).textScaleFactor,
              color: Colors.black,//isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}