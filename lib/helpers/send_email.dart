import 'package:flutter/material.dart';
// import 'package:remottely/views/control/auth_app_page.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:ui';

class SendEmail extends StatefulWidget {
  SendEmail(this.emailAddress);
  String emailAddress;
  @override
  _SendEmailState createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     child:             Center(
  //             child: Container(
  //               child: Text('verifique sua caixa de email'),
  //             ),
  //           ),
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      // ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 64),
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              ),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'verifique a caixa de email de\n',
                  style: const TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: widget.emailAddress,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    // TextSpan(text: ' world!'),
                  ],
                ),
              ),
              // child: Text(
              //   'verifique a caixa de email de\n${widget.emailAddress}',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .popUntil((route) => route.settings.name == '/');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              child: const Text(
                'Voltar',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
