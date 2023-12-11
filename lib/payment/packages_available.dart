import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../shared/bottom_nav.dart';

class PackagesAvailable extends StatefulWidget {
  const PackagesAvailable({super.key});

  @override
  State<PackagesAvailable> createState() => _PackagesAvailableState();
}

class _PackagesAvailableState extends State<PackagesAvailable> {
  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Available Packages'),
          centerTitle: true,
        ),
        bottomNavigationBar: const BottomNavBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () async {
                    await makePayment();
                  },
                  child: courseTile(context, 'Basic Science', 1000)),

              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: TextButton(
              //     onPressed: () async {
              //      await makePayment();
              //     },
              //     child: const Text('clickme'),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Container courseTile(BuildContext context, String courseName, int price) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.withOpacity(0.8),
            Colors.deepPurple.withOpacity(0.6),
            Colors.deepPurple.withOpacity(.3),
            Colors.deepPurple.withOpacity(.3),
            Colors.deepPurple.withOpacity(0.6),
            Colors.deepPurple.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Colors.white, strokeAlign: BorderSide.strokeAlignOutside),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(courseName), Text('$price')],
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('2500', 'INR');

      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "GB", currencyCode: "INR", testEnv: true
      );

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'teacher',
                  googlePay: gpay
              ))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        if (kDebugMode) {
          print("Payment Successfully");
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51OAcwsSGBnUWlyB8icW3d5Sos8nSUNMB8q8vF1ba8CxfokL7lGjsrTJoieCiJEhMuGLPHepXFZcMPHStB3dTXACS00Mb3S78i1',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
