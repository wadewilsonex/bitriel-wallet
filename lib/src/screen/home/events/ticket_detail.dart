import 'package:wallet_apps/index.dart';

class TicketDetail extends StatelessWidget {
  final String price;
  final String creator;
  final ImageProvider<Object> image;
  final String name;
  final String description;
  final String startDate;
  final String status;

  const TicketDetail({
    Key? key,
    required this.creator,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.startDate,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            appbar(context),
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

                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.1),
                          radius: 20,
                          child: Icon(
                            Iconsax.calendar_1,
                            color: hexaCodeToColor(AppColors.primaryColor),
                            size: 22,
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        MyText(
                          text: AppUtils.timeStampToDateTime(startDate, middleStyle: " "),
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.1),
                          radius: 20,
                          child: Icon(
                            Iconsax.location,
                            color: hexaCodeToColor(AppColors.primaryColor),
                            size: 22,
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            MyText(
                              text: "AIA Stadium",
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.start,
                            ),

                            MyText(
                              text: "KMall, Phnom Penh",
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const Divider(),

                    orgProfile(),

                    const SizedBox(
                      height: 10,
                    ),

                    const MyText(
                      text: "About Event",
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.start,
                      fontSize: 18,
                      bottom: 10,
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
      bottomNavigationBar: status == "Active" ? bottomNavigationBar : null,
    );
  }

  Widget get bottomNavigationBar {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: hexaCodeToColor(AppColors.whiteColorHexa),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
        border: Border.all(
          color: hexaCodeToColor(AppColors.primaryColor),
        ),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          const SizedBox(width: 10,),

          Row(
            children: [
              ClipRRect(
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Image.asset('assets/SelendraCircle-Blue.png', height: 20.sp, width: 20.sp,),

                        MyText(
                          text: ' $price SEL',
                          hexaColor: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),

                        MyText(
                          text: ' ≈ USD \$$price',
                          hexaColor: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          ElevatedButton(
            onPressed: () {
              
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(hexaCodeToColor(AppColors.whiteColorHexa)),
              backgroundColor: MaterialStateProperty.all<Color>(hexaCodeToColor(AppColors.primaryColor)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                )
              ),
            ),
            child: const MyText(
                text: 'Buy Ticket',
                hexaColor: AppColors.whiteHexaColor,
                fontWeight: FontWeight.w700,
              ),
          ),
          // Container(
          //   height: 50,
          //   padding: const EdgeInsets.all(8),
          //   margin: const EdgeInsets.all(paddingSize),
          //   alignment: Alignment.center,
          //   decoration: BoxDecoration(
          //     color: hexaCodeToColor(AppColors.primaryColor),
          //     borderRadius: BorderRadius.circular(100),
          //   ),
          //   child: const Padding(
          //     padding: EdgeInsets.symmetric(horizontal: paddingSize),
          //     child: MyText(
          //       text: 'Buy Ticket',
          //       hexaColor: AppColors.whiteHexaColor,
          //       fontWeight: FontWeight.w700,
          //     ),
          //   ),
          // ),

          const SizedBox(width: 10,),

        ],
      ),
    );
  }

  Widget orgProfile() {
    return Consumer<AppProvider>(
      builder: (context, pro, wg) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: creator,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                fontSize: 17,
              ),

              const MyText(
                text: "Organizer",
                textAlign: TextAlign.start,
                hexaColor: AppColors.greyCode,
              ),
              
            ],
          ),
          leading: CircleAvatar(backgroundImage: FileImage(File('${pro.dirPath}/nfts/2.png'))),
        );
      }
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
                  image: image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
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
      actions: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 19,
            child: Icon(
              Iconsax.share,
              color: Colors.black,
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