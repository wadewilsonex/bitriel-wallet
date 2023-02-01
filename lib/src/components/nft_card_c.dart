import 'dart:ui';

import 'package:wallet_apps/index.dart';

class NFTCard extends StatelessWidget {
  const NFTCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          margin: const EdgeInsets.only(left: paddingSize, right: paddingSize),
          height: MediaQuery.of(context).size.width * 0.6,
          width: MediaQuery.of(context).size.width * 0.55,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
            ),
            color: Colors.grey,
            image: DecorationImage(
              image: AssetImage("assets/nfts/1.png"),
              fit: BoxFit.cover,
            )
          ),
        ),

        Container(
          padding: const EdgeInsets.only(left: paddingSize, top: 5, right: paddingSize),
          height: MediaQuery.of(context).size.width * 0.22,
          width: MediaQuery.of(context).size.width * 0.55,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.grey.shade300)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const MyText(
                    text: "BAYC Honorary",
                    hexaColor: AppColors.primaryColor,
                    fontSize: 15,
                    textAlign: TextAlign.start,
                  ),

                  Row(
                    children: [
                      Image(
                        image: const AssetImage("assets/SelendraCircle-Blue.png"),
                        width: 2.5.vmax,
                      ),
                      const MyText(
                        text: " 1.25",
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),

                ]
              ),
              const MyText(
                  text: "Honorary Border APE #2",
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox()
            ],
          )
        )
      ]
    );
  }
}

class NFTDetail extends StatelessWidget {
  final String price;
  final String creator;
  final String image;
  final String name;
  final String creatorImage;
  
  const NFTDetail({
    Key? key, 
    required this.creator,
    required this.name,
    required this.price,
    required this.image,
    required this.creatorImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            appbar(context),
            purchase(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Divider(),

                    MyText(
                      text: name,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.start,
                      fontSize: 21,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const MyText(
                      text: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc',
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.start,
                      hexaColor: AppColors.greyCode,
                      pBottom: 10,
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter purchase() {
    return SliverToBoxAdapter(
      child: ListTile(
        trailing: GestureDetector(
          onTap: () {
            
          },
          child: Container(
            alignment: Alignment.center,
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(4, 2),
                  color: Colors.grey.shade300,
                  blurRadius: 20,
                ),
              ],
              color: hexaCodeToColor(AppColors.primaryColor),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const MyText(
              text: 'Purchase',
              hexaColor: AppColors.whiteHexaColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: MyText(
          text: creator,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
          fontSize: 19,
        ),
        leading: const CircleAvatar(backgroundImage: AssetImage('assets/nfts/1.png')),
      ),
    );
  }

  SliverAppBar appbar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      expandedHeight: 500,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 55,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        alignment: Alignment.center,
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: [
                              Colors.grey.shade200.withOpacity(0.6),
                              Colors.grey.shade100.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/SelendraCircle-Blue.png'),
                              
                              MyText(
                                text: '$price SEL',
                                hexaColor: AppColors.whiteHexaColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(10),
        child: Container(
          width: double.infinity,
          height: 25,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Color(0xfff4f6f8),
          ),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Container(
                width: 80,
                height: 4,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CircleAvatar(
            backgroundColor: hexaCodeToColor(AppColors.primaryColor),
            radius: 19,
            child: const Icon(
              Iconsax.share,
              color: Colors.white,
            ),
          ),
        ),
      ],
      title: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 19,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Iconsax.arrow_left_2,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

