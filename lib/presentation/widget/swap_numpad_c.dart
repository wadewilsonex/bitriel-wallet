

// KeyPad widget
// This widget is reusable and its buttons are customizable (color, size)
import 'package:bitriel_wallet/index.dart';

class SwapNumPad extends StatelessWidget {
  final double buttonSize;
  final Color buttonColor;
  final String valInput;
  final Function delete;
  final Function formatCurrency;

  const SwapNumPad({
    Key? key,
    this.buttonSize = 70,
    required this.buttonColor,
    required this.valInput,
    required this.delete,
    required this.formatCurrency
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(paddingSize),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // implement the number keys (from 0 to 9) with the NumberButton widget
            // the NumberButton widget is defined in the bottom of this file
            children: [
              NumberButton(
                number: "1",
                size: buttonSize,
                color: buttonColor,
                onPressed: (){
                  formatCurrency("1");
                },
              ),
              
              const SizedBox(width: 10),

              NumberButton(
                number: "2",
                size: buttonSize,
                color: buttonColor,
                onPressed: (){
                  formatCurrency("2");
                },
              ),
                            
              const SizedBox(width: 10),

              NumberButton(
                number: "3",
                size: buttonSize,
                color: buttonColor,
                onPressed: (){
                  formatCurrency("3");
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NumberButton(
                number: "4",
                size: buttonSize,
                color: buttonColor,
                onPressed: (){
                  formatCurrency("4");
                },
              ),
                            
              const SizedBox(width: 10),

              NumberButton(
                number: "5",
                size: buttonSize,
                color: buttonColor,
                onPressed: (){
                  formatCurrency("5");
                },
              ),
                            
              const SizedBox(width: 10),

              NumberButton(
                number: "6",
                size: buttonSize,
                color: buttonColor,
                onPressed: (){
                  formatCurrency("6");
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NumberButton(
                number: "7",
                size: buttonSize,
                color: buttonColor,
                onPressed: (){
                  formatCurrency("7");
                },
              ),
                            
              const SizedBox(width: 10),

              NumberButton(
                number: "8",
                size: buttonSize,
                color: buttonColor,
                onPressed: (){
                  formatCurrency("8");
                },
              ),
                            
              const SizedBox(width: 10),

              NumberButton(
                number: "9",
                size: buttonSize,
                color: buttonColor,
                onPressed: (){
                  formatCurrency("9");
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // this button is used to delete the last number
              NumberButton(
                number: ".",
                size: buttonSize,
                color: buttonColor,
                onPressed: (){
                  formatCurrency(".");
                },
              ),
                            
              const SizedBox(width: 10),

              NumberButton(
                number: "0",
                size: buttonSize,
                color: buttonColor,
                onPressed: (){
                  formatCurrency("0");
                },
              ),
                            
              const SizedBox(width: 10),

              NumberButton(
                onPressed: (){
                  delete();
                },
                icon: Transform.rotate(
                  angle: 70.6858347058,
                  child: Icon(Iconsax.shield_cross, color: hexaCodeToColor(AppColors.midNightBlue), size: 30 * MediaQuery.of(context).textScaleFactor),
                ),
                size: buttonSize,
                color: buttonColor,
              ),
            ],
          ),

          const SizedBox(height: 10)
        ],
      ),
    );
  }
}

// define NumberButton widget
// its shape is round
class NumberButton extends StatelessWidget {
  final String? number;
  final double size;
  final Color color;
  final Widget? icon;
  final Function()? onPressed;
  final Function()? onLongPressed;

  const NumberButton({
    Key? key,
    this.number,
    required this.size,
    required this.color,
    required this.onPressed,
    this.onLongPressed,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onLongPress: onLongPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
          ),
          backgroundColor: MaterialStateProperty.all(color),
        ),
        onPressed: () {
          onPressed!();
        },
        child: Center(
          child: icon ?? Text(
            number.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              color: hexaCodeToColor(AppColors.midNightBlue), 
              fontSize: 23 * MediaQuery.of(context).textScaleFactor,
            ),
          ),
        ),
      ),
    );
  }
}