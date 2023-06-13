import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyD_oyxrxUGyDsP7lezhQUyx2gqkSyZsLcA",
            authDomain: "ff-source-code.firebaseapp.com",
            projectId: "ff-source-code",
            storageBucket: "ff-source-code.appspot.com",
            messagingSenderId: "880136316624",
            appId: "1:880136316624:web:adee75899a03af9331e0d5"));
  } else {
    await Firebase.initializeApp();
  }
}
