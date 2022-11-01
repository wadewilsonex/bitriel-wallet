import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart' as getx;
import 'package:http/http.dart' as http;
import 'package:transition/transition.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/home/transaction/success_transfer/success_transfer.dart';

class PaymentController extends getx.GetxController {
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(BuildContext context, {required num qty, required String wallet}) async {
    try {
      paymentIntentData = await createPaymentIntent(context, qty, wallet);
      print("paymentIntentData $paymentIntentData");

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

        displayPaymentSheet(context, qty, wallet );

      }
    } catch (e, s) {
      print('exception:$e$s');
      Navigator.of(context).pop();
    }
  }

  displayPaymentSheet(BuildContext context, num qty, String wallet) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      // getx.Get.snackbar('Payment', 'Payment Successful',
      //     snackPosition: getx.SnackPosition.BOTTOM,
      //     backgroundColor: Colors.green,
      //     colorText: Colors.white,
      //     margin: const EdgeInsets.all(10),
      //     duration: const Duration(seconds: 2));

      Navigator.pushAndRemoveUntil(context, Transition(child: SuccessTransfer(qty: qty, fromAddress: wallet, isDebitCard: true,)), (route) => false);
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from Stripe: ${e.error.localizedMessage}");
        Navigator.of(context).pop();
      } else {
        print("Unforeseen error: ${e}");
        Navigator.of(context).pop();
      }
    } catch (e) {
      print("exception:$e");
      Navigator.of(context).pop();
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(BuildContext context, num qty, String wallet) async {
    try {
      Map<String, dynamic> body = {
        'quantity': qty,
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
      Navigator.of(context).pop();
    }
  }

}