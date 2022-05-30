import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/theme/color.dart';

class VerifyPassphraseBody extends StatelessWidget {
  final String? rd1, rd2, rd3;
  final Function? verify;
  final String seed;

  const VerifyPassphraseBody({
    Key? key, 
    this.rd1,
    this.rd2,
    this.rd3,
    this.verify,
    required this.seed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    var correctHeight = height - padding.top - padding.bottom;

    return Scaffold(
        backgroundColor: hexaCodeToColor(AppColors.darkBgd),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? correctHeight
                  : MediaQuery.of(context).size.height * 2,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 25),
                                MyText(
                                  text: 'Verify Seed',
                                  color: AppColors.whiteColorHexa,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),

                                SizedBox(height: 25),
                                MyText(
                                  text: 'Almost done. Please input the words in the numerical order.',
                                  color: AppColors.bgdColor,
                                  fontSize: 16,
                                  textAlign: TextAlign.start,  
                                ),

                                SizedBox(height: 100),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: getColumn(seed, 0),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: getColumn(seed, 1),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: getColumn(seed, 2),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),


                                SizedBox(height: 100),
                                MyFlatButton(
                                  hasShadow: false,
                                  textButton: "Continue",
                                  action: () {
                                    DialogComponents().dialogCustom(
                                      context: context,
                                      contents: "You have successfully create your account.",
                                      textButton: "Completed",
                                      image: Image.asset("assets/logo/success.png")
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ),
        ));
  }

  List<Widget> getColumn(String seed, int pos) {
    var list = <Widget>[];
    var se = seed.split(' ');
    var colSize = se.length ~/ 3;

    for (var i = 0; i < colSize; i++) {
      list.add(Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        // color: grey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: i * 3 + pos + 1 < 10
              ? Text(
                  '  ' + (i * 3 + pos + 1).toString() + '.  ' + se[i * 3 + pos],
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                )
              : Text(
                  (i * 3 + pos + 1).toString() + '.  ' + se[i * 3 + pos],
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
        ),
      ));
    }
    return list;
  }

}
