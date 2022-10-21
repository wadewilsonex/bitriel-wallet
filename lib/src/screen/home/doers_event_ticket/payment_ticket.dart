import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/event_model.dart';
import 'package:wallet_apps/src/constants/textstyle.dart';
import 'package:wallet_apps/src/constants/ui_helper.dart';
import 'package:wallet_apps/src/screen/home/doers_event_ticket/payment_option.dart';
import 'package:wallet_apps/src/utils/date_utils.dart';

class OrderConfirmScreen extends StatefulWidget {
  final Event event;
  const OrderConfirmScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<OrderConfirmScreen> createState() => _OrderConfirmScreenState();
}

class _OrderConfirmScreenState extends State<OrderConfirmScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        title: MyText(
          text: "Checkout",
          fontWeight: FontWeight.bold,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const MyText(text: "ORDER SUMMARY", fontSize: 16, fontWeight: FontWeight.bold, textAlign: TextAlign.start,),

                    UIHelper.verticalSpace(16),

                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Stack(
                        children: [
                          buildHeaderImage(),
                          Positioned(top: 100, left: 0, right: 0, child: buildInfoOrder(),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: buildPriceInfo(),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderImage() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: Image.network(
          widget.event.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildInfoOrder() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: paddingSize * 2, horizontal: paddingSize),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        color: isDarkMode ? hexaCodeToColor(AppColors.defiMenuItem) : hexaCodeToColor(AppColors.lightBg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(text: widget.event.name, fontSize: 18, fontWeight: FontWeight.bold, textAlign: TextAlign.start,),

          MyText(text: widget.event.organizer, textAlign: TextAlign.start,),

          UIHelper.verticalSpace(16),

          Container(width: MediaQuery.of(context).size.width, height: 1.0, color: Colors.grey),

          const SizedBox(height: 15.0),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyText(text: 'Price per ticket', fontWeight: FontWeight.bold),
              MyText(text: "SEL ${widget.event.priceToken} ≈ \$${widget.event.price}",),
            ],
          ),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              MyText(text:'Service fee', fontWeight: FontWeight.bold),
              MyText(text: "SEL 0.01 ≈ \$0.10",),
            ],
          ),
          const SizedBox(height: 15.0),
          Container(width: MediaQuery.of(context).size.width, height: 1.0, color: Colors.grey),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyText(text:'TOTAL', fontWeight: FontWeight.bold),
              MyText(text:'${widget.event.priceToken + 0.01} ≈ \$${widget.event.price + 0.11}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPriceInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightBg),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("Price", style: subtitleStyle),
              UIHelper.verticalSpace(8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "SEL ${widget.event.priceToken + 0.01} ≈ \$${widget.event.price + 0.11}", style: titleStyle.copyWith(fontSize: 16, color: hexaCodeToColor(AppColors.orangeColor))),
                      // const TextSpan(text: "/per person", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: hexaCodeToColor(AppColors.orangeColor),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              Navigator.push(context, Transition(child: const PaymentOptions(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
            },
            child: Text(
              "CONFIRM & PAY",
              style: titleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
  
}