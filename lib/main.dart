import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joinquotation/models/lists.dart';

import 'package:joinquotation/pages/homePage.dart';
import 'package:joinquotation/pages/profilePage.dart';
import 'package:joinquotation/pages/settingsPage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:joinquotation/pages/signPage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // variables
  int _themeColor = ColorsList[0]["hex"];
  String _emojiAvatar = "🦊";
  final PageController _pageController = PageController(initialPage: 1);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _userID = "";

  // functions
  void _switchTheme(BuildContext context, int Color) {
    Navigator.pop(context);
    setState(() {
      _themeColor = Color;
    });
  }

  void _handleEmoji(String emoji) {
    setState(() {
      _emojiAvatar = emoji;
    });
  }

  void _onPageChanged(bool prev) {
    HapticFeedback.lightImpact();
    if (prev)
      _pageController.previousPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn);
    else
      _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn);
  }

  void _handleSignIn(Map user, bool registered) async {
    print(user);
    print(registered);
    if (!registered) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user["emailAddress"],
          password: user["password"],
        );
        await firestore
            .collection("users")
            .doc(credential.user!.uid)
            .collection("account")
            .doc("nickname")
            .set({
          "user": {"nickname": user["username"]}
        });
        await firestore
            .collection("users")
            .doc(credential.user!.uid)
            .collection("account")
            .doc("quotes")
            .set({"quotes": []});
        setState(() {
          _userID = credential.user!.uid;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    } else {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user["emailAddress"],
          password: user["password"],
        );
        setState(() {
          _userID = credential.user!.uid;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotation',
      theme: ThemeData(
        textTheme: GoogleFonts.spaceMonoTextTheme(
          Theme.of(context).textTheme,
        ),
        indicatorColor: Color(0xff078080),
        scaffoldBackgroundColor: Color(0xfff6f6f6),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
        primaryColor: Color(_themeColor),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: _handleRoutes(context)),
    );
  }

  PageView _handleRoutes(context) {
    if (_userID != "") {
      return PageView(
          controller: _pageController,
          allowImplicitScrolling: false,
          padEnds: true,
          children: [
            HomePage(
              onPageChanged: _onPageChanged,
            ),
            ProfilePage(
              themeColor: _themeColor,
              switchTheme: _switchTheme,
              emojiAvatar: _emojiAvatar,
              onPageChanged: _onPageChanged,
              handleEmoji: _handleEmoji,
              handleBottomSheet: (context) => print("close"),
              userID: _userID,
            ),
            SettingsPage(
              onPageChanged: _onPageChanged,
            )
          ]);
    } else {
      return PageView(
        children: [SignPage(handleSignIn: _handleSignIn)],
      );
    }
  }
}
