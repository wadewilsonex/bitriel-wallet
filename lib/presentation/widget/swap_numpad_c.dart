

// KeyPad widget
// This widget is reusable and its buttons are customizable (color, size)
import 'package:bitriel_wallet/index.dart';

class SwapNumPad extends StatelessWidget {
  final double buttonSize;
  final Color buttonColor;
  final TextEditingController controller;

  const SwapNumPad({
    Key? key,
    this.buttonSize = 70,
    required this.buttonColor,
    required this.controller,
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
                controller: controller,
                onPressed: (){
                  controller.text += "1";
                  // onTabNum!("1");
                },
              ),
              
              const SizedBox(width: 10),

              NumberButton(
                number: "2",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  controller.text += "2";
                  // onTabNum!("2");
                },
              ),
                            
              const SizedBox(width: 10),

              NumberButton(
                number: "3",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  controller.text += "3";
                  // onTabNum!("3");
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
                controller: controller,
                onPressed: (){
                  controller.text += "4";
                  // onTabNum!("4");
                },
              ),
                            
              const SizedBox(width: 10),

              NumberButton(
                number: "5",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  controller.text += "5";
                  // onTabNum!("5");
                },
              ),
                            
              const SizedBox(width: 10),

              NumberButton(
                number: "6",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  controller.text += "6";
                  // onTabNum!("6");
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
                controller: controller,
                onPressed: (){
                  controller.text += "7";
                  // onTabNum!("7");
                },
              ),
                            
              const SizedBox(width: 10),

              NumberButton(
                number: "8",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  controller.text += "8";
                  // onTabNum!("8");
                },
              ),
                            
              const SizedBox(width: 10),

              NumberButton(
                number: "9",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  controller.text += "9";
                  // onTabNum!("9");
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
                number:".",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  controller.text += ".";
                },
              ),
                            
              const SizedBox(width: 10),

              NumberButton(
                number: "0",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  controller.text += "0";
                  // onTabNum!("0");
                },
              ),
                            
              const SizedBox(width: 10),

              NumberButton(
                onLongPressed: () async {
                  while(controller.text.isNotEmpty){
                    await Future.delayed(const Duration(milliseconds: 50), (){

                      // delete();
                    });
                  }
                },
                onPressed: (){
                  // delete();
                },
                icon: Transform.rotate(
                  angle: 70.6858347058,
                  child: Icon(Iconsax.shield_cross, color: hexaCodeToColor(AppColors.midNightBlue), size: 30 * MediaQuery.of(context).textScaleFactor),
                ),
                size: buttonSize,
                color: buttonColor,
                controller: controller,
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
  final TextEditingController controller;
  final Widget? icon;
  final Function()? onPressed;
  final Function()? onLongPressed;

  const NumberButton({
    Key? key,
    this.number,
    required this.size,
    required this.color,
    required this.controller,
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