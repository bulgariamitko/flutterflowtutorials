// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=9ATIaW58DGA
// replace - [{"Name of App State for email": "useremail"}, {"Name of App State for Stripe Sub ID": "stripeSubId"}, {"Name of App State for Stripe Active sub (bool)": "sub"}]
// support my work - https://github.com/sponsors/bulgariamitko

import '/backend/api_requests/api_calls.dart';

Future<void> checkSub() async {
  // If the email is not provided, return a custom response or error message.
  if (FFAppState().useremail.isEmpty) {
    return;
  }

  dynamic customerRes = await StripeAPIGroup.getCustomerCall.call(
    email: FFAppState().useremail,
  );

  if (customerRes != null && customerRes.jsonBody.isNotEmpty) {
    // var jsonResponse = jsonDecode(customerRes.jsonBody);
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
        continue;
      }

      if (activeSub != null && activeSub.jsonBody.isNotEmpty) {
        // var subResponse = jsonDecode(activeSub.jsonBody);
        dynamic subResponse = activeSub.jsonBody;
        List<dynamic> subscriptions = subResponse['data'];

        for (var subscription in subscriptions) {
          String subStatus = subscription['status'];
          if (subStatus == 'active') {
            FFAppState().stripeSubId = subscription['id'];
            FFAppState().sub = true;
            return;
          }
        }
      }
    }
  }
}