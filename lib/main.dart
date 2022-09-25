import 'package:flutter/material.dart';
import 'package:messenger_app/screens/chat_screen.dart';
import 'package:messenger_app/screens/registration_screen.dart';
import 'package:messenger_app/screens/signin_screen.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messenger App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      /*
      home: const //ChatScreen(),
          //SignInScreen(),
          // //RegistrationScreen(),
          WelcomeScreen(),
          */
      initialRoute: _auth.currentUser != null
          ? ChatScreen.chatRoute
          : WelcomeScreen.screenRoute,
      routes: {
        WelcomeScreen.screenRoute: (context) => WelcomeScreen(),
        SignInScreen.signinRoute: (context) => SignInScreen(),
        RegistrationScreen.registrationRoute: (context) => RegistrationScreen(),
        ChatScreen.chatRoute: (context) => ChatScreen(),
      },
    );
  }
}
