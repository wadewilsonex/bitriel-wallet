import 'package:bitriel_wallet/presentation/pincode/pin.dart';
import 'package:bitriel_wallet/presentation/widget/text_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class PincodeBody extends StatelessWidget {
  final String? titleStatus;
  final String? subStatus;
  final PinCodeLabel? label;

  /// [0] = is4Digit
  ///
  /// [1] = isFirstPin
  final ValueNotifier<List<bool?>>? valueChange;
  // final ValueNotifier<bool>? isFirst;
  // final bool? is4digits;
  final List<ValueNotifier<String>>? lsControl;
  final Function? pinIndexSetup;
  final Function? clearPin;
  final bool? isNewPass;
  final Function? onPressedDigit;

  const PincodeBody({
    Key? key,
    this.titleStatus,
    this.subStatus,
    this.isNewPass = false,
    this.label,
    // this.isFirst,
    // this.is4digits,
    this.valueChange,
    this.lsControl,
    this.pinIndexSetup,
    this.clearPin,
    this.onPressedDigit
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarPassCode(context),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (titleStatus == null)
                ValueListenableBuilder(
                  valueListenable: valueChange!,
                  builder: (builder, value, wg) {
                    return MyTextConstant(
                      text: value[1]! ? 'Enter PIN' : 'Verify PIN',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    );
                  }
                )
              // For Change PIN
              else
                MyTextConstant(
                  text: titleStatus,
                  // color2: AppUtils.colorFor(titleStatus == "Invalid PIN"
                  //     ? AppColors.redColor
                  //     : isDarkMode
                  //         ? AppColors.whiteColorHexa
                  //         : AppColors.blackColor),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              const SizedBox(
                height: 50,
              ),
              if (subStatus == null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (
                      label == PinCodeLabel.fromSplash ||
                      label == PinCodeLabel.fromSendTx ||
                      label == PinCodeLabel.fromBackUp ||
                      label == PinCodeLabel.fromSignMessage
                    )
                    const MyTextConstant(
                      fontSize: 17,
                      text: "Verify PIN code to continue",
                    )
                    else
                      const MyTextConstant(
                        fontSize: 17,
                        text:
                            "Assign a security PIN that will be required when opening in the future Verify PIN code to continue",
                      )
                  ],
                )
              // For Change PIN
              else
                MyTextConstant(
                  text: subStatus,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              const SizedBox(height: 50),
              ValueListenableBuilder(
                  valueListenable: valueChange!,
                  builder: (builder, value, wg) {
                    if (kDebugMode) {
                      print("valueChange!");
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: value[0] == false
                          ? [
                              DotPin(txt: lsControl![0]),
                              DotPin(txt: lsControl![1]),
                              DotPin(txt: lsControl![2]),
                              DotPin(txt: lsControl![3]),
                              DotPin(txt: lsControl![4]),
                              DotPin(txt: lsControl![5]),
                            ]
                          : [
                              DotPin(txt: lsControl![0]),
                              DotPin(txt: lsControl![1]),
                              DotPin(txt: lsControl![2]),
                              DotPin(txt: lsControl![3]),
                            ],
                    );
                  }),
              const Expanded(
                child: SizedBox(),
              ),
              reuseNumPad(1, pinIndexSetup!, clearPin!),
              const SizedBox(height: 19),
              reuseNumPad(4, pinIndexSetup!, clearPin!),
              const SizedBox(height: 19),
              reuseNumPad(7, pinIndexSetup!, clearPin!),
              const SizedBox(height: 19),
              reuseNumPad(0, pinIndexSetup!, clearPin!),
              const SizedBox(height: 19),
            ],
          ),
        ));
  }

  PreferredSizeWidget appBarPassCode(final BuildContext context) {
    return AppBar(
      elevation: 0,
      title: const MyTextConstant(
        text: "Passcode",
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Iconsax.arrow_left_2,
          size: 30,
          color: Colors.black,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onPressedDigit!();
          },
          child: ValueListenableBuilder(
            valueListenable: valueChange!,
            builder: (context, value, wg) {
              return MyTextConstant(
                text:
                    value[0] == false ? "Use 4-digits PIN" : "Use 6-digits PIN",
                // color2: value[1] == true || isNewPass == true
                //     ? hexaCodeToColor(AppColors.primaryColor)
                //     : hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0),
                fontWeight: FontWeight.w700,
              );
            },
          ),
        ),
      ],
    );
  }
}

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
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: txt!,
                builder: (context, value, wg) {
                  return value.isEmpty
                      ? const SizedBox()
                      : const Icon(
                          Icons.circle,
                          color: Color(0xFFF29F05),
                        );
                }),
          ),
          Container(
            height: 5,
            decoration: const BoxDecoration(color: Color(0xFFF29F05)),
          ),
        ],
      ),
    );
  }
}

Widget reuseNumPad(int startNumber, Function pinIndexSetup, Function clearPin) {
  return Row(
    children: <Widget>[
      startNumber != 0
          ? ReuseKeyBoardNum(
              n: startNumber,
              onPressed: pinIndexSetup,
            )
          : const Expanded(
              child: SizedBox(),
            ),
      const SizedBox(width: 19),

      ReuseKeyBoardNum(
        n: startNumber != 0 ? ++startNumber : startNumber,
        onPressed: pinIndexSetup,
      ),
      const SizedBox(width: 19),

      // If startNumber != 0: Mean Among number 1-9
      // Else Mean Back Or Remove 1 Pin Button
      ReuseKeyBoardNum(
        n: startNumber != 0 ? (++startNumber) : -1,
        onPressed: startNumber != 0 ? pinIndexSetup : clearPin,
        child: startNumber == 0
            ? Transform.rotate(
                angle: 70.6858347058,
                child: const Icon(Iconsax.shield_cross, size: 30),
              )
            : null,
      ),
    ],
  );
}

class ReuseKeyBoardNum extends StatelessWidget {
  final int? n;
  final Function? onPressed;
  final Widget? child;

  const ReuseKeyBoardNum({super.key, this.n, this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 55,
        child: TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
              backgroundColor: MaterialStateProperty.all(Colors
                  .white) //isDarkMode ? Colors.white.withOpacity(0.06) : hexaCodeToColor(AppColors.whiteColorHexa))
              ),
          onPressed: () {
            if (n == -1) {
              onPressed!();
            } else {
              onPressed!('$n');
            }
          },
          child: child ??
              Text(
                '$n',
                style: const TextStyle(
                  fontSize: 30, // * MediaQuery.of(context).textScaleFactor,
                  color: Colors.white, //isDarkMode ?  : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}
