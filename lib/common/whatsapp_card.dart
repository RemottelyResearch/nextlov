import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/cart_manager.dart';
import '../models/user_manager.dart';

class WhatsappCard extends StatelessWidget {
  const WhatsappCard({
    @required this.buttonText,
    @required this.onPressed,
    @required this.cartDoubt,
  });

  final String buttonText;
  final bool onPressed;
  final bool cartDoubt;

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();

    final userManager = context.watch<UserManager>();

    String generateMessage() {
      String msg = '';
      if (cartDoubt) {
        String produtos = '';
        for (int i = 0; i < cartManager.items.length; i++) {
          // ignore: use_string_buffers
          produtos +=
              '${'- ${cartManager.items[i].product.name}\n'}${'  - Medida: ${cartManager.items[i].size}\n'}${'  - Valor: ${cartManager.items[i].unitPrice.toStringAsFixed(2)}\n'}${'  - Quantidade: ${cartManager.items[i].quantity}\n'}';
        }
        if (cartManager.isAddressValid) {
          msg =
              '${'Nome do cliente: ${userManager.userModel.name}\n'}${'Subtotal: R\$ ${cartManager.productsPrice.toStringAsFixed(2)}\n'}Entrega: valor a negociar!\n\nProdutos:\n${'$produtos\n'}Endereço de entrega:\n${'${cartManager.address.street}, ${cartManager.address.number}.\n${cartManager.address.district}.\n'}${'${cartManager.address.city} - ${cartManager.address.state}.'}';
        } else {
          msg =
              '${'Nome do cliente: ${userManager.userModel.name}\n'}${'Subtotal: R\$ ${cartManager.productsPrice.toStringAsFixed(2)}\n'}Entrega: valor a negociar!\n\nProdutos:\n${'$produtos\n'}Endereço de entrega:\nEndereço não informado!';
        }
      } else {
        msg =
            'Bom dia, queria tirar algumas dúvidas sobre os produtos da Selim Jóias.';
      }
      return 'whatsapp://send?phone=+5561991200684&text=$msg';
    }

    Future<void> launchWhatsapp() async {
      String url = generateMessage();
      if (kIsWeb) {
        // js.context.callMethod("open", [url]);
      } else {
        await canLaunch(url) ? launch(url) : print("can't open whatsapp");
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.green;
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                ),
              ),
              onPressed: onPressed
                  ? () async {
                      await launchWhatsapp();
                    }
                  : null,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
