import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/models/createKey_m.dart';
import 'package:wallet_apps/theme/color.dart';

class VerifyPassphraseBody extends StatelessWidget {

  final CreateKeyModel? createKeyModel;
  final Function? verify;
  final Function? onTap;
  final Function? remove3Seeds;

  const VerifyPassphraseBody({
    Key? key, 
    this.createKeyModel,
    this.verify,
    this.onTap,
    this.remove3Seeds
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.darkBgd),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                SizedBox(height: 50),
                MyText(
                  text: 'Verify Seed',
                  color: AppColors.whiteColorHexa,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
  
                SizedBox(height: 25),
                MyText(
                  text: 'Almost done. Please input the words in the numerical order.',
                  color: AppColors.bgdColor,
                  fontSize: 18,
                  textAlign: TextAlign.start,  
                ),
  
                SizedBox(height: 100),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: getColumn(context, createKeyModel!.tmpSeed!, 0),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: getColumn(context, createKeyModel!.tmpSeed!, 1),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: getColumn(context, createKeyModel!.tmpSeed!, 2),
                          ),
                        ],
                      ),
                    ],
                  )
                ),
  
                if (createKeyModel!.tmpThreeNum!.isNotEmpty) Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: createKeyModel!.tmpThreeNum!.length,
                      itemBuilder: (context, i){
                        return Component().seedContainer(context, createKeyModel!.lsSeeds![int.parse(createKeyModel!.tmpThreeNum![i])], int.parse(createKeyModel!.tmpThreeNum![i]), i, onTap);
                      }
                    ),
                  ),
                ),
  
                // Display Refresh Button When User Fill Out All
                if (createKeyModel!.tmpThreeNum!.length == 0)
                TextButton(
                  onPressed: (){
                    remove3Seeds!();
                  }, 
                  child: MyText(
                    text: "Re-do",
                    color2: Colors.white,
                  )
                ),
  
                Flexible(child: Container()),
                MyGradientButton(
                  edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                  textButton: "Continue",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () {
                    verify!();
                  },
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  List<Widget> getColumn(BuildContext context, String seed, int pos) {
    
    var list = <Widget>[];
    var se = seed.split(' ');
    var colSize = se.length ~/ 3;

    for (var i = 0; i < colSize; i++) {
      list.add(
        Container(
          width: MediaQuery.of(context).size.width / 3 - 34,
          padding: EdgeInsets.only(top: 8, bottom: 8),
          alignment: Alignment.center,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          // color: grey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: (i * 3 + pos + 1) < 10
              ? Text(
                '  ' + (i * 3 + pos + 1).toString() + '. ' + se[i * 3 + pos],
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              )
              : Text(
                (i * 3 + pos + 1).toString() + '. ' + se[i * 3 + pos],
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
          ),
        )
      );
    }
    return list;
  }

}
