import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';

class PaymentController extends GetxController {
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment({required String qty, required String wallet}) async {
    try {
      paymentIntentData = await createPaymentIntent(qty, wallet);
      print("paymentIntentData $paymentIntentData");


      // final paymentIntent = await Stripe.instance.confirmPayment(
      //   paymentIntentClientSecret: "pi_3LwNfZDSrtf20FA52lwqFCsi_secret_9PMGVSdY6TfYkXCVY859hxaoE",
      // );

      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Prospects',
          customerId: paymentIntentData!['customer'],
          paymentIntentClientSecret: paymentIntentData!['clientSecret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
        ));

        Stripe.instance.confirmPayment(
          paymentIntentData!['clientSecret'].toString(), 
          const PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData(
              billingDetails: BillingDetails( name: 'Jenny Rosen',),
            ),
          ),
        );
        
        displayPaymentSheet();
        
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Get.snackbar('Payment', 'Payment Successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2));
      // Get.to(const HomePage());
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        print("Unforeseen error: ${e}");
      }
    } catch (e) {
      print("exception:$e");
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String qty, String wallet) async {
    try {
      Map<String, dynamic> body = {
        'quantity': calculateAmount(qty),
        'user_address': wallet,
      };
      var response = await http.post(
        Uri.parse("${dotenv.get("URL_PAYMENT")}/create-payment-intent"),
        body: json.encode(body),
        headers: PostRequest().conceteHeader()
      );
      print("${jsonDecode(response.body)}");
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}