// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=9ATIaW58DGA
// replace - [{"Name of App State for email": "useremail"}, {"Name of App State for Stripe Sub ID": "stripeSubId"}, {"Name of App State for Stripe Active sub (bool)": "sub"}]
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import '/backend/api_requests/api_calls.dart';

Future<void> checkSub() async {
  // If the email is not provided, return a custom response or error message.
  print(['App', FFAppState().email]);
  if (FFAppState().email.isEmpty) {
    print(['Email not provided 3 ' + FFAppState().email]);
    return;
  }

  dynamic customerRes = await StripeAPIGroup.getCustomerCall.call(
    email: FFAppState().email,
  );

  // Initialize sub as false
  FFAppState().sub = false;

  if (customerRes != null && customerRes.jsonBody.isNotEmpty) {
    print(['customerRes', customerRes.jsonBody]);
    dynamic jsonResponse = customerRes.jsonBody;
    List<dynamic> customers = jsonResponse['data'];

    for (var customer in customers) {
      String customerId = customer['id'];
      dynamic activeSub;

      if (FFAppState().stripeSubId.isNotEmpty &&
          FFAppState().stripeSubId.contains('cus_')) {
        activeSub = await StripeAPIGroup.getSubscriptionCall.call(
          customer: FFAppState().stripeSubId,
        );
      } else if (customerId.contains('cus_')) {
        activeSub = await StripeAPIGroup.getSubscriptionCall.call(
          customer: customerId,
        );
      } else {
        // Break out of the loop if the customerId doesn't contain 'cus_'
        print('Customer ID does not contain "cus_". Skipping this customer.');
        continue;
      }

      if (activeSub != null && activeSub.jsonBody.isNotEmpty) {
        dynamic subResponse = activeSub.jsonBody;
        List<dynamic> subscriptions = subResponse['data'];

        for (var subscription in subscriptions) {
          String subStatus = subscription['status'];
          if (subStatus == 'active') {
            FFAppState().stripeSubId = subscription['id'];
            // Set sub as true if active subscription is found
            FFAppState().sub = true;
            print(['Sub', FFAppState().stripeSubId, FFAppState().sub]);
            return;
          }
        }
      }
    }
  }
}