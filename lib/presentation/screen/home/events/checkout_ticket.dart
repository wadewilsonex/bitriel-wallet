import 'package:action_slider/action_slider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/data/models/event_model.dart';
import 'package:wallet_apps/constants/ui_helper.dart';
import 'package:wallet_apps/presentation/screen/home/events/payment_option.dart';

class OrderConfirmScreen extends StatefulWidget {
  final Event event;
  const OrderConfirmScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<OrderConfirmScreen> createState() => _OrderConfirmScreenState();
}

class _OrderConfirmScreenState extends State<OrderConfirmScreen> {

  int qty = 1;

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
          fontSize: 20,
          fontWeight: FontWeight.bold,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2, size: 30,),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              // height: MediaQuery.of(context).size.height,
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
                        Positioned(top: 125, left: 0, right: 0, child: buildInfoOrder(),),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(paddingSize),
                child: ActionSlider.standard(
                  sliderBehavior: SliderBehavior.stretch,
                  actionThresholdType: ThresholdType.release,
                  backgroundColor: Colors.white,
                  toggleColor: hexaCodeToColor(isDarkMode ? AppColors.defiMenuItem : AppColors.orangeColor),
                  action: (controller) async {
                    controller.loading(); //starts loading animation
                    await Future.delayed(const Duration(seconds: 1));
                    controller.success(); //starts success animation

                    if(!mounted) return;
                    Navigator.push(context, Transition(child: PaymentOptions(qty: qty, price: widget.event.price,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                    
                    // await Future.delayed(const Duration(seconds: 1));
                    controller.reset(); //resets the slider
                  },
                  child: const MyText(text: 'Slide to confirm & pay', hexaColor: AppColors.textColor,),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget buildHeaderImage() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 150,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        child: widget.event.image.contains("https") ? Image.network(widget.event.image, fit: BoxFit.fill,) : Image.asset(widget.event.image, fit: BoxFit.fill,),
      ),
    );
  }

  Widget buildInfoOrder() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: paddingSize * 2, horizontal: paddingSize),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
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

          _increaseAmount(),

          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              MyText(text:'Service fee', fontWeight: FontWeight.bold),
              MyText(text: "SEL 0.0 ≈ \$0.00",),
            ],
          ),
          const SizedBox(height: 15.0),
          Container(width: MediaQuery.of(context).size.width, height: 1.0, color: Colors.grey),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyText(text:'TOTAL', fontWeight: FontWeight.bold),
              MyText(text:'SEL ${(widget.event.priceToken + 0.00) * qty} ≈ \$${(widget.event.price + 0.00) * qty}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _increaseAmount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        MyText(text: 'Ticket X$qty', fontWeight: FontWeight.bold),

        Row(
          children: [
            qty != 1 ?
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.orangeColor),
                ),
                width: 25,
                height: 25,
                child: const Center(
                  child: Center(
                    child: Icon(Iconsax.minus, color: Colors.white,),
                ),
                ),
              ),
              onTap: (){
                setState(() {
                  if(qty > 0 ) qty--;
                });
              },
            ) : Container(),

            const SizedBox(width: 15.0),

            MyText(text: "$qty",),
            
            const SizedBox(width: 15.0),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.orangeColor),
                ),
                width: 25,
                height: 25,
                child: const Center(
                    child: Icon(Iconsax.add, color: Colors.white,),
                ),
              ),
              onTap: (){
                setState(() {
                  qty++;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildPriceInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightBg),
      // width: MediaQuery.of(context).size.width,
      child: ActionSlider.standard(
        sliderBehavior: SliderBehavior.stretch,
        actionThresholdType: ThresholdType.release,
        backgroundColor: Colors.white,
        toggleColor: hexaCodeToColor(isDarkMode ? AppColors.defiMenuItem : AppColors.orangeColor),
        action: (controller) async {
          controller.loading(); //starts loading animation
          await Future.delayed(const Duration(seconds: 3));
          controller.success(); //starts success animation
          await Future.delayed(const Duration(seconds: 1));
          controller.reset(); //resets the slider
        },
        child: const MyText(text: 'Slide to confirm & pay', hexaColor: AppColors.textColor,),
      ),
    );
  }
  
}