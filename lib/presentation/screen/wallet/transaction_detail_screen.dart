import 'package:bitriel_wallet/index.dart';

class TransactionDetail extends StatelessWidget {

  const TransactionDetail({
    Key? key,
  }) : super(key: key);

  final double logoSize = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: hexaCodeToColor(AppColors.cardColor),
      appBar: AppBar(
        forceMaterialTransparency: true,
        elevation: 0,
        centerTitle: true,
        backgroundColor: hexaCodeToColor(AppColors.cardColor),
        title: MyTextConstant(
          text: "Bitcoin (BTC)",
          fontSize: 26,
          color2: hexaCodeToColor(AppColors.midNightBlue),
          fontWeight: FontWeight.w600,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Iconsax.arrow_left_2,
            size: 30,
            color: hexaCodeToColor(AppColors.midNightBlue),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [

            Column(
              children: [

                const SizedBox(height: 75),

                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25.0, left: 25.0, bottom: 38),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 40.0,
                          ),

                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                MyTextConstant(
                                  text: 'Sent',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color2: hexaCodeToColor(AppColors.red),
                                ),
                              ],
                            ),
                          ),
                                      
                          //========= Date & Time Transaction =========
                          _dateTimeTrx(),

                          Divider(
                            thickness: 1.5,
                            color: Colors.grey[300],
                          ),

                          //========= Amount & Fee Transaction =========
                          _amountTrx(),

                          Divider(
                            thickness: 1.5,
                            color: Colors.grey[300],
                          ),

                          //========= ID, Sender, Receiver Transaction =========
                          _infoTrx(),
                          
                        ]
                      )
                    ),
                  ),
                )
              ],
            ),

            Positioned(
              top: 35.0,
              child: Container(
                height: 75.0,
                width: 75.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/logo/bitriel-logo.png'),
                  )
                ),
              ),
            )
            
          ],
        ),
      ),
    );
  }

  Widget _dateTimeTrx() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            MyTextConstant(
              text: 'Date',
              fontWeight: FontWeight.w600,
              color2: hexaCodeToColor(AppColors.grey),
            ),

            MyTextConstant(
              text: 'Aug 19, 2019',
              fontSize: 18,
              color2: hexaCodeToColor(AppColors.midNightBlue),
            ),
            
            
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            MyTextConstant(
              text: 'Time',
              fontWeight: FontWeight.w600,
              color2: hexaCodeToColor(AppColors.grey),
            ),

            MyTextConstant(
              text: '11:38 AM',
              fontSize: 18,
              color2: hexaCodeToColor(AppColors.midNightBlue),
            ),

          ],
        )
      ],
    );
  }

  Widget _amountTrx() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 10),
        
        MyTextConstant(
          text: 'Total Amount',
          fontWeight: FontWeight.w600,
          color2: hexaCodeToColor(AppColors.grey),
        ),

        MyTextConstant(
          text: '0.021 BTC',
          fontSize: 18,
          color2: hexaCodeToColor(AppColors.midNightBlue),
        ),

        const SizedBox(height: 10),

        MyTextConstant(
          text: 'Total amount (\$)',
          fontWeight: FontWeight.w600,
          color2: hexaCodeToColor(AppColors.grey),
        ),

        MyTextConstant(
          text: '\$204.48',
          fontSize: 18,
          color2: hexaCodeToColor(AppColors.midNightBlue),
        ),

        const SizedBox(height: 10),

        MyTextConstant(
          text: 'Gas fee',
          fontWeight: FontWeight.w600,
          color2: hexaCodeToColor(AppColors.grey),
        ),

        MyTextConstant(
          text: '0,0015 BTC',
          fontSize: 18,
          color2: hexaCodeToColor(AppColors.midNightBlue),
        ),

        const SizedBox(height: 10),

        MyTextConstant(
          text: 'Status',
          fontWeight: FontWeight.w600,
          color2: hexaCodeToColor(AppColors.grey),
        ),

        Row(
          children: [
            MyTextConstant(
              text: 'Transaction confirmed',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color2: hexaCodeToColor(AppColors.primary),
            ),

            const SizedBox(width: 5),

            Icon(Iconsax.export_3, color: hexaCodeToColor(AppColors.primary),)

          ],
        ),

        const SizedBox(height: 10),

      ],
    );
  }

  Widget _infoTrx() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 10),
        
        MyTextConstant(
          text: 'Transaction ID',
          fontWeight: FontWeight.w600,
          color2: hexaCodeToColor(AppColors.grey),
        ),

        MyTextConstant(
          text: '3M8w2knJKsr3jqMatYiyuraxVvZA',
          fontSize: 18,
          color2: hexaCodeToColor(AppColors.midNightBlue),
        ),

        const SizedBox(height: 10),

        MyTextConstant(
          text: 'From',
          fontWeight: FontWeight.w600,
          color2: hexaCodeToColor(AppColors.grey),
        ),

        MyTextConstant(
          text: '0x0b06d4JH48e5DK3jm4a3af69BnVO51c12i8',
          fontSize: 18,
          color2: hexaCodeToColor(AppColors.midNightBlue),
          textAlign: TextAlign.start,
        ),

        const SizedBox(height: 10),

        MyTextConstant(
          text: 'To',
          fontWeight: FontWeight.w600,
          color2: hexaCodeToColor(AppColors.grey),
        ),

        MyTextConstant(
          text: '3M8w2knJKsr3jqM3aatYiyuraxVvZAmuZy24lK8',
          fontSize: 18,
          color2: hexaCodeToColor(AppColors.midNightBlue),
          textAlign: TextAlign.start,
        ),

      ],
    );
  }


}