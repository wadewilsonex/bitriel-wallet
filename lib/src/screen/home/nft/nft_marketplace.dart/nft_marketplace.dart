import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/nft_card_c.dart';
import 'package:wallet_apps/src/components/nft_image_animation.dart';

class NFTMarketPlace extends StatelessWidget {
  const NFTMarketPlace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            
            Image.asset("assets/logo/bitriel-logo-gold.png", height: 40.sp, width: 40.sp,),

            SizedBox(width: 1.5.w,),

            const MyText(
              text: "NFT",
              fontWeight: FontWeight.bold,
              fontSize: 20,
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
                            // SizedBox(height: 30),
                            ImageListView(
                              startIndex: 1,
                              duration: 25,
                            ),
                            SizedBox(height: 10),
                            ImageListView(
                              startIndex: 11,
                              duration: 45,
                            ),
                            SizedBox(height: 10),
                            ImageListView(
                              startIndex: 21,
                              duration: 65,
                            ),
                            SizedBox(height: 10),
                            ImageListView(
                              startIndex: 31,
                              duration: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 24,
                    right: 24,
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


  Widget _exclusiveNFTs(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Container(
          margin: const EdgeInsets.all(paddingSize),
          child: const MyText(
            text: "Exclusive bitriel NFT",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )
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
                      child: const NFTDetail(
                        creator: "BAYC Honoray", 
                        name: "Honorary Border APE #2",
                        price: "1.25", 
                        image: "assets/nfts/1.png",
                        creatorImage: "assets/nfts/1.png",
                      ),
                      transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                    )
                  );
                },
                child: const NFTCard()
              );
            },
          ),
        ),
        
      ],
    );
  }

  Widget _trendingNFTs(BuildContext context){
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
                    text: "See All", 
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
                      child: const NFTDetail(
                        creator: "BAYC Honoray", 
                        name: "Honorary Border APE #2",
                        price: "1.25", 
                        image: "assets/nfts/1.png",
                        creatorImage: "assets/nfts/1.png",
                      ),
                      transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                    )
                  );
                },
                child: const NFTCard()
              );
            },
          ),
        ),
        
      ],
    );
  }
}
