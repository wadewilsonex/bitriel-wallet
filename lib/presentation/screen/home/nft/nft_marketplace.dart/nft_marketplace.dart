import 'package:wallet_apps/index.dart';

class NFTMarketPlace extends StatelessWidget {
  const NFTMarketPlace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, pro, wg) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
            iconTheme: IconThemeData(
              color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
            ),
            elevation: 0,
            bottomOpacity: 0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                
                Image.file(File("${pro.dirPath}/logo/bitriel-logo-gold.png"), height: 40.sp, width: 40.sp,),

                const SizedBox(width: 2,),

                const MyText(
                  text: "NFTs",
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  textAlign: TextAlign.start,
                ),

                Expanded(
                  child: Container(),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Iconsax.close_circle,
                  size: 30,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  color: const Color(0xff010101),
                  height: 30.h,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        top: -40.vmax,
                        child: ShaderMask(
                          blendMode: BlendMode.dstOut,
                          shaderCallback: (rect) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withOpacity(0.2),
                                Colors.black.withOpacity(0.4),
                                Colors.black,
                              ],
                              stops: const [0, 0.62, 0.67, 0.85, 1],
                            ).createShader(rect);
                          },
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                              children: const <Widget>[
                                ImageListView(
                                  startIndex: 1,
                                  duration: 25,
                                ),
                                SizedBox(height: 10),
                                ImageListView(
                                  startIndex: 1,
                                  duration: 45,
                                ),
                                SizedBox(height: 10),
                                ImageListView(
                                  startIndex: 1,
                                  duration: 65,
                                ),
                                SizedBox(height: 10),
                                ImageListView(
                                  startIndex: 1,
                                  duration: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: paddingSize,
                        right: paddingSize,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            MyText(
                              text: 'Art with NFTs',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              hexaColor: AppColors.whiteHexaColor,
                            ),
          
                            MyText(
                              text: 'A place to explore NFTs and art of different level.',
                              fontWeight: FontWeight.w600,
                              hexaColor: AppColors.greyCode,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                _exclusiveNFTs(context),
          
                _trendingNFTs(context),
              ],
            ),
          ),
        );
      }
    );
  }


  Widget _exclusiveNFTs(BuildContext context){
    return Consumer<AppProvider>(
      builder: (context, pro, wg) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              margin: const EdgeInsets.all(paddingSize),
              child: const MyText(
                text: "Exclusive Bitriel NFTs",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )
            ),

            SizedBox(
              height: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                itemCount: 9,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        Transition(
                          child: NFTDetail(
                            creator: "Riel Tiger",
                            name: "Khmer Art #${1 + index}",
                            price: "1.25",
                            image: "${pro.dirPath}/nfts/rieltiger/${1 + index}.png",
                            creatorImage: "${pro.dirPath}/nfts/rieltiger/riel-tiger.jpg",
                          ),
                          transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                        )
                      );
                    },
                    child: NFTCard(image: "${pro.dirPath}/nfts/rieltiger/${1 + index}.png", title: "Riel Tiger", creator: "Khmer Art #${1 + index}",)
                  );
                },
              ),
            ),
            
          ],
        );
      }
    );
  }

  Widget _trendingNFTs(BuildContext context){
    return Consumer<AppProvider>(
      builder: (context, pro, wg) {
        return Column(
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: paddingSize),
                  child: const MyText(
                    text: "Trending Collection",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: paddingSize / 2, horizontal: paddingSize),
                  child: Row(
                    children: const [
                      MyText(
                        text: "Popular this week",
                        hexaColor: AppColors.greyCode,
                      ),
                      
                      Spacer(),
                      
                      MyText(
                        text: "View All", 
                        hexaColor: AppColors.primaryColor,
                      ),
                    ],
                  ),
                )
              ],
            ),

            SizedBox(
              height: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context, 
                        Transition(
                          child: NFTDetail(
                            creator: "Riel Tiger", 
                            name: "Khmer Art #${1 + index}",
                            price: "1.25", 
                            image: "${pro.dirPath}/nfts/rieltiger/${1 + index}.png",
                            creatorImage: "${pro.dirPath}/nfts/rieltiger/riel-tiger.jpg",
                          ),
                          transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                        )
                      );
                    },
                    child: NFTCard(image: "${pro.dirPath}/nfts/rieltiger/${1 + index}.png", title: "Riel Tiger", creator: "Khmer Art #${1 + index}",)
                  );
                },
              ),
            ),
            
          ],
        );
      }
    );
  }
}
