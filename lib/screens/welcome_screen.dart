import 'package:flutter/material.dart';
import 'package:messenger_app/main.dart';
import 'package:messenger_app/screens/registration_screen.dart';
import 'package:messenger_app/screens/signin_screen.dart';

import '../widgets/my_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String screenRoute = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Image.asset('images/logo.png'),
              height: 180,
            ),
            const Center(
              child: Text(
                'Message Me',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff2e386b),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            MyButton(
              TextColor: Colors.black,
              backColor: Colors.yellow[900]!,
              onPressed: () {
                Navigator.pushNamed(context, SignInScreen.signinRoute);
              },
              text: 'Sign In',
            ),
            MyButton(
              TextColor: Colors.white,
              backColor: Colors.blue[900]!,
              onPressed: () {
                Navigator.pushNamed(
                    context, RegistrationScreen.registrationRoute);
              },
              text: 'Sign Up',
            ),
          ],
        ),
      ),
    );
  }
}
