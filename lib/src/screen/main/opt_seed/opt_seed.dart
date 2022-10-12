import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:wallet_apps/index.dart';

class OPTVerification extends StatefulWidget {
  final String? phoneNumber;
  const OPTVerification({ Key? key, this.phoneNumber }) : super(key: key);

  @override
  OPTVerificationState createState() => OPTVerificationState();
}

class OPTVerificationState extends State<OPTVerification> {
  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;
  bool _onEditing = true;

  String _code = '';

  late Timer _timer;
  int _start = 60;
  int _currentIndex = 0;

  void resend() {
    if(!mounted) return;
    setState(() {
      _isResendAgain = true;
    });

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) { 
      if(!mounted) return;
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  verify() {
    if(!mounted) return;
    setState(() {
      _isLoading = true;
    });

    const oneSec = Duration(milliseconds: 2000);
    _timer = Timer.periodic(oneSec, (timer) { 
      if(!mounted) return;
      setState(() {
        _isLoading = false;
        _isVerified = true;
      });
    });
  }

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if(!mounted) return;
      setState(() {
        _currentIndex++;

        if (_currentIndex == 2) {
          _currentIndex = 0;
        }
      });
    });

    super.initState();
  }

  @override 
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedOpacity(
                        opacity: _currentIndex == 0 ? 1 : 0, 
                        duration: const Duration(seconds: 1),
                        curve: Curves.linear,
                        child: Image.network('https://ouch-cdn2.icons8.com/pi1hTsTcrgVklEBNOJe2TLKO2LhU6OlMoub6FCRCQ5M/rs:fit:784:666/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvMzAv/MzA3NzBlMGUtZTgx/YS00MTZkLWI0ZTYt/NDU1MWEzNjk4MTlh/LnN2Zw.png',),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedOpacity(
                        opacity: _currentIndex == 1 ? 1 : 0, 
                        duration: const Duration(seconds: 1),
                        curve: Curves.linear,
                        child: Image.network('https://ouch-cdn2.icons8.com/ElwUPINwMmnzk4s2_9O31AWJhH-eRHnP9z8rHUSS5JQ/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNzkw/Lzg2NDVlNDllLTcx/ZDItNDM1NC04YjM5/LWI0MjZkZWI4M2Zk/MS5zdmc.png',),
                      ),
                    )
                  ]
                ),
              ),
              const SizedBox(height: 30,),
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: const MyText(text: "Verification", fontWeight: FontWeight.bold, fontSize: 22,)),
              const SizedBox(height: 30,),
              FadeInDown(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 500),
                child: MyText(text: "Please enter the 4 digit code sent to \n ${widget.phoneNumber}")
              ),
              const SizedBox(height: 30,),

              // Verification Code Input
              FadeInDown(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 500),
                child: VerificationCode(
                  length: 4,
                  textStyle: TextStyle(fontSize: 20, color: isDarkMode ? Colors.white : Colors.black),
                  underlineColor: hexaCodeToColor(AppColors.orangeColor),
                  keyboardType: TextInputType.number,
                  underlineUnfocusedColor: isDarkMode ? Colors.white : Colors.black,
                  onCompleted: (value) {
                    setState(() {
                      _code = value;
                    });
                  }, 
                  onEditing: (bool value) {
                    setState(() {
                      _onEditing = value;
                    });
                  },
                ),
              ),


              const SizedBox(height: 20,),
              FadeInDown(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(text: "Don't recieve the OTP?", color2: Colors.grey.shade500,),
                    TextButton(
                      onPressed: () {
                        if (_isResendAgain) return;
                        resend();
                      }, 
                      child: MyText(text: _isResendAgain ? "Try again in $_start".toString() : "Resend", hexaColor: AppColors.orangeColor,)
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50,),
              FadeInDown(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 500),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                  onPressed: _code.length < 4 ? () => {} : () { verify(); },
                  color: hexaCodeToColor(AppColors.orangeColor),
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: _isLoading ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 3,
                      color: Colors.black,
                    ),
                  ) : _isVerified ? const Icon(Icons.check_circle, color: Colors.white, size: 30,) : const Text("Verify", style: TextStyle(color: Colors.white),),
                ),
              )
          ],)
        ),
      )
    );
  }
}