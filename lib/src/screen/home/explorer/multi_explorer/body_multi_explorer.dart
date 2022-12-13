

import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/explorer_item_c.dart';
import 'package:wallet_apps/src/models/explore.m.dart';
import 'package:wallet_apps/src/screen/home/ads_webview/ads_webview.dart';

class ExplorerBody extends StatelessWidget {
  const ExplorerBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          height: MediaQuery.of(context).size.height,
          // padding: const EdgeInsets.only(left: paddingSize, right: paddingSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              MyText(
                bottom: 2.h,
                text: "Multi-Chain Explorer",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),

              GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: paddingSize,
                ),
                shrinkWrap: true,
                itemCount: explorerList.length,
                itemBuilder: (context, index){
                  return ExplorerItem(
                    image: explorerList[index]['asset'],
                    title: explorerList[index]['title'],
                    action: () {
                      Navigator.push(
                        context, 
                        Transition(child: AdsWebView(item: explorerList[index]), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                      );
                    },
                  );
                },
              ),
              
            ],
          ),
        )
      ),
    );
  }
}