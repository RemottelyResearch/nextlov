import 'dart:ui';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:nextlov/helpers/send_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword(this.emailAddress);
  String emailAddress;
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              initialValue: widget.emailAddress,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              // cursorColor: AppColors.accentColor,
              decoration: const InputDecoration(
                hintText: "E - M A I L",
                hintStyle: TextStyle(
                  // color: AppColors.textColor,
                  fontFamily: 'Astronaut_PersonalUse',
                  fontSize: 18,
                ),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => widget.emailAddress = value,
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                auth
                    .sendPasswordResetEmail(email: widget.emailAddress)
                    .then((email) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => SendEmail(widget.emailAddress),
                    ),
                  );
                }).catchError((onError) {
                  Flushbar(
                    title: 'ATENÇÃO!',
                    message: "${onError.toString()}",
                    flushbarPosition: FlushbarPosition.TOP,
                    flushbarStyle: FlushbarStyle.GROUNDED,
                    isDismissible: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    duration: const Duration(seconds: 5),
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ).show(context);
                });
              },
              // style: ElevatedButton.styleFrom(
              //   primary: Colors.black,
              //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              //   textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              child: Text('Enviar Verificacao por email'),
            ),
            // SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //     //   MaterialPageRoute(
            //     //     builder: (context) => AuthAppPage(),
            //     //   ),
            //     // );
            //   },
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.red,
            //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            //     textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            //   ),
            //   child: Text(
            //     'Voltar',
            //     style: TextStyle(
            //       fontSize: 16,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
