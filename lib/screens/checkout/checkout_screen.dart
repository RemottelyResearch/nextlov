import 'package:flutter/material.dart';
import 'package:nextlov/common/price_card.dart';
import 'package:nextlov/models/cart_manager.dart';
import 'package:nextlov/models/checkout_manager.dart';
import 'package:nextlov/models/credit_card.dart';
import 'package:nextlov/models/user_manager.dart';
import 'package:nextlov/screens/checkout/components/cpf_field.dart';
import 'package:nextlov/screens/checkout/components/credit_card_widget.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final CreditCard creditCard = CreditCard();

  @override
  Widget build(BuildContext context) {
    final userManager = context.watch<UserManager>();

    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Consumer<CheckoutManager>(
            builder: (_, checkoutManager, __) {
              if (checkoutManager.loading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Processando seu pagamento...',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16),
                      )
                    ],
                  ),
                );
              }

              return Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    CreditCardWidget(creditCard),
                    CpfField(),
                    PriceCard(
                      buttonText: 'Finalizar Pedido',
                      onPressed: () {
                        // if (formKey.currentState.validate()) {
                        // formKey.currentState.save();
                        //   print(creditCard.toString());
                        //   print(userManager.user.cpf);
                        //   checkoutManager.checkout(
                        //     creditCard: creditCard,
                        //     onStockFail: (e) {
                        //       Navigator.of(context).popUntil(
                        //           (route) => route.settings.name == '/cart');
                        //     },
                        //     onPayFail: (e) {
                        //       scaffoldKey.currentState.showSnackBar(SnackBar(
                        //         content: Text('$e'),
                        //         backgroundColor: Colors.red,
                        //       ));
                        //     },
                        //     onSuccess: (order) {
                        //       Navigator.of(context).popUntil(
                        //           (route) => route.settings.name == '/');
                        //       Navigator.of(context)
                        //           .pushNamed('/confirmation', arguments: order);
                        //     },
                        //   );
                        // } // TODO RETURN THIS
                        creditCard.setNumber('4333 3333 3333 3331');
                        creditCard.setHolder('João Carlos');
                        creditCard.setCVV('800');
                        creditCard.setExpirationDate('12/2027');
                        print(creditCard.toString());
                        print(userManager.userModel.cpf);
                        checkoutManager.checkout(
                          creditCard: creditCard,
                          onStockFail: (e) {
                            Navigator.of(context).popUntil(
                                (route) => route.settings.name == '/cart');
                          },
                          onPayFail: (e) {
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('$e'),
                              backgroundColor: Colors.red,
                            ));
                          },
                          onSuccess: (order) {
                            Navigator.of(context).popUntil(
                                (route) => route.settings.name == '/');
                            Navigator.of(context)
                                .pushNamed('/confirmation', arguments: order);
                          },
                        );
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
