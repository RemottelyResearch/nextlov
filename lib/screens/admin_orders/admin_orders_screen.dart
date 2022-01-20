import 'package:flutter/material.dart';
import 'package:nextlov/common/custom_drawer/custom_drawer.dart';
import 'package:nextlov/common/custom_icon_button.dart';
import 'package:nextlov/common/empty_card.dart';
import 'package:nextlov/common/order/order_tile.dart';
import 'package:nextlov/models/admin_orders_manager.dart';
import 'package:nextlov/models/order.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AdminOrdersScreen extends StatefulWidget {
  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen>
    with TickerProviderStateMixin {
  final PanelController panelController = PanelController();
  bool closed = true;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    super.initState();
  }

  void _handleOnPressed() {
    setState(() {
      panelController.isPanelOpen
          ? panelController.close()
          : panelController.open();
      panelController.isPanelOpen
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Todos os Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, ordersManager, __) {
          final filteredOrders = ordersManager.filteredOrders;

          return SlidingUpPanel(
            onPanelOpened: () {
              setState(() {
                _animationController.reverse();
              });
            },
            onPanelClosed: () {
              setState(() {
                _animationController.forward();
              });
            },
            backdropColor: Colors.black,
            backdropEnabled: true,
            controller: panelController,
            body: Column(
              children: <Widget>[
                if (ordersManager.userFilter != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Pedidos de ${ordersManager.userFilter.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          iconData: Icons.close,
                          color: Colors.white,
                          onTap: () {
                            ordersManager.setUserFilter(null);
                          },
                        )
                      ],
                    ),
                  ),
                if (filteredOrders.isEmpty)
                  const Expanded(
                    child: EmptyCard(
                      title: 'Nenhuma venda realizada!',
                      iconData: Icons.border_clear,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (_, index) {
                          return OrderTile(
                            filteredOrders[index],
                            showControls: true,
                          );
                        }),
                  ),
                const SizedBox(
                  height: 120,
                ),
              ],
            ),
            minHeight: 40,
            maxHeight: 250,
            panel: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (panelController.isPanelClosed) {
                      setState(() {
                        panelController.open();
                      });
                    } else {
                      setState(() {
                        panelController.close();
                      });
                    }
                  },
                  child: Container(
                    height: 40,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(),
                        ),
                        Flexible(
                          flex: 3,
                          child: Center(
                            child: Text(
                              'Filtros',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              splashColor: Colors.greenAccent,
                              icon: AnimatedIcon(
                                icon: AnimatedIcons.close_menu,
                                progress: _animationController,
                              ),
                              onPressed: () => _handleOnPressed(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Status.values.map((s) {
                      return CheckboxListTile(
                        title: Text(Order.getStatusText(s)),
                        dense: true,
                        activeColor: Theme.of(context).primaryColor,
                        value: ordersManager.statusFilter.contains(s),
                        onChanged: (v) {
                          ordersManager.setStatusFilter(status: s, enabled: v);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
