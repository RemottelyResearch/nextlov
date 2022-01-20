import 'package:flutter/material.dart';
import 'package:nextlov/common/order/order_product_tile.dart';
import 'package:nextlov/models/order.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voltar'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 4),
          const Text(
            'Pedido Realizado com\nSucesso!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            margin: const EdgeInsets.all(16),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          const Text(
                            'Número do pedido: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            order.formattedId,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            'Valor da compra: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'R\$ ${order.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: order.items.map((e) {
                    return OrderProductTile(e);
                  }).toList(),
                )
              ],
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
