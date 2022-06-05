import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';

// KeyPad widget
// This widget is reusable and its buttons are customizable (color, size)
class NumPad extends StatelessWidget {
  final double buttonSize;
  final Color buttonColor;
  final TextEditingController controller;
  final Function delete;
  final Function onSubmit;

  const NumPad({
    Key? key,
    this.buttonSize = 70,
    required this.buttonColor,
    required this.delete,
    required this.onSubmit,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingSize),
      child: Column(
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
                  // controller.text += "1";
                  delete("1");
                },
              ),
              NumberButton(
                number: "2",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  // controller.text += "2";
                  delete("2");
                },
              ),
              NumberButton(
                number: "3",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  // controller.text += "3";
                  delete("3");
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
                  // controller.text += "4";
                  delete("4");
                },
              ),
              NumberButton(
                number: "5",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  // controller.text += "5";
                  delete("5");
                },
              ),
              NumberButton(
                number: "6",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  // controller.text += "6";
                  delete("6");
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
                  // controller.text += "7";
                  delete("7");
                },
              ),
              NumberButton(
                number: "8",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  // controller.text += "8";
                  delete("8");
                },
              ),
              NumberButton(
                number: "9",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  // controller.text += "9";
                  delete("9");
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
                number:",",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  controller.text += ",";
                },
              ),
              NumberButton(
                number: "0",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
                onPressed: (){
                  controller.text += "0";
                },
              ),
              NumberButton(
                onPressed: (){
                   delete();
                },
                icon: Transform.rotate(
                  angle: 70.6858347058,
                  child: Icon(Iconsax.shield_cross, color: hexaCodeToColor(AppColors.lowWhite), size: 27),
                ),
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
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
  final Function() onPressed;

  const NumberButton({
    Key? key,
    this.number,
    required this.size,
    required this.color,
    required this.controller,
    required this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      height: size,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
          ),
          backgroundColor: MaterialStateProperty.all(color),
        ),
        onPressed: () {
          onPressed();
        },
        child: Center(
          child: icon ?? Text(
            number.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              color: Colors.white, 
              fontSize: 16
            ),
          ),
        ),
      ),
    );
  }
}