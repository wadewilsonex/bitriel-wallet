

import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/explorer_item_c.dart';
import 'package:wallet_apps/src/models/explore.m.dart';
import 'package:wallet_apps/src/screen/home/ads_webview/adsWebView.dart';

class ExplorerBody extends StatelessWidget {
  const ExplorerBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: paddingSize, right: paddingSize, top: paddingSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: "Multi-Chain Explorer",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColorHexa
              ),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
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