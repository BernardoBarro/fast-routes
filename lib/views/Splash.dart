import 'package:fast_routes/views/LoginandRegister.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Future.delayed(const Duration(seconds: 4)).then((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginandRegister()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.all(16),
            color: Color.fromRGBO(57, 57, 57, 1),
            child: Center(
                child: Container(
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.cover,
                width: 300,
                height: 400,
              ),
            ))),
      ),
    );
  }
}
