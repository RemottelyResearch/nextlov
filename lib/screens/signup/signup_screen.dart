import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:nextlov/helpers/send_email.dart';
import 'package:nextlov/helpers/validators.dart';
import 'package:nextlov/models/user_model.dart';
import 'package:nextlov/models/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final UserModel user = UserModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Nome Completo'),
                      enabled: !userManager.loading,
                      validator: (name) {
                        if (name.isEmpty)
                          return 'Campo obrigatório';
                        else if (name.trim().split(' ').length <= 1)
                          return 'Preencha seu Nome completo';
                        return null;
                      },
                      onSaved: (name) => user.name = name,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      enabled: !userManager.loading,
                      validator: (email) {
                        if (email.isEmpty)
                          return 'Campo obrigatório';
                        else if (!emailValid(email.replaceAll(' ', '')))
                          return 'E-mail inválido';
                        return null;
                      },
                      onSaved: (email) => user.email = email,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Senha'),
                      obscureText: true,
                      enabled: !userManager.loading,
                      validator: (pass) {
                        if (pass.isEmpty)
                          return 'Campo obrigatório';
                        else if (pass.length < 6) return 'Senha muito curta';
                        return null;
                      },
                      onSaved: (pass) => user.password = pass,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Repita a Senha'),
                      obscureText: true,
                      enabled: !userManager.loading,
                      validator: (pass) {
                        if (pass.isEmpty)
                          return 'Campo obrigatório';
                        else if (pass.length < 6) return 'Senha muito curta';
                        return null;
                      },
                      onSaved: (pass) => user.confirmPassword = pass,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      color: Theme.of(context).primaryColor,
                      disabledColor:
                          Theme.of(context).primaryColor.withAlpha(100),
                      textColor: Colors.white,
                      onPressed: userManager.loading
                          ? null
                          : () {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();

                                if (user.password != user.confirmPassword) {
                                  scaffoldKey.currentState
                                      .showSnackBar(const SnackBar(
                                    content: Text('Senhas não coincidem!'),
                                    backgroundColor: Colors.red,
                                  ));
                                  return;
                                }

                                userManager.signUp(
                                    user: user,
                                    onSuccess: (FirebaseUser currentUser) {
                                      Navigator.of(context).pop();
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            title: const Text(
                                              "Verifique seu email!",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            content: ElevatedButton(
                                              onPressed: () async {
                                                // if (!currentUser
                                                //     .isEmailVerified) {
                                                await currentUser
                                                    .sendEmailVerification()
                                                    .then((email) {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SendEmail(currentUser
                                                              .email),
                                                    ),
                                                  );
                                                }).catchError((onError) {
                                                  Flushbar(
                                                    title: 'ATENÇÃO!',
                                                    message:
                                                        "${onError.toString()}",
                                                    flushbarPosition:
                                                        FlushbarPosition.TOP,
                                                    flushbarStyle:
                                                        FlushbarStyle.GROUNDED,
                                                    isDismissible: true,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    duration: const Duration(
                                                        seconds: 5),
                                                    icon: const Icon(
                                                      Icons.shopping_cart,
                                                      color: Colors.white,
                                                    ),
                                                  ).show(context);
                                                });
                                                // } else {
                                                //   Navigator.of(context).pop();
                                                // }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.blue,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 30,
                                                        vertical: 20),
                                                textStyle: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              child: const Text(
                                                'Enviar verificação por email',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    onFail: (e) {
                                      scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text('Falha ao cadastrar: $e'),
                                        backgroundColor: Colors.red,
                                      ));
                                    });
                              }
                            },
                      child: userManager.loading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : const Text(
                              'Criar Conta',
                              style: TextStyle(fontSize: 15),
                            ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
