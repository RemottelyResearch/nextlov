import 'package:flutter/material.dart';
import 'package:nextlov/common/search_dialog.dart';
// import 'package:nextlov/models/category_manager.dart';
import 'package:nextlov/models/product_manager.dart';
import 'package:nextlov/models/user_manager.dart';
import 'package:nextlov/screens/products/components/product_list_tile.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen(this.categoryId);

  final String categoryId;

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final PageController pageController = PageController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ProductManager productManager = Provider.of(context, listen: false);
    productManager.loadAllCategoryProducts(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    // final userManager = context.watch<UserManager>();
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ProductManager>(
          builder: (_, productManager, __) {
            if (productManager.search.isEmpty) {
              return const Text('Produtos');
            } else {
              return LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                          context: context,
                          builder: (_) => SearchDialog(productManager.search));
                      if (search != null) {
                        productManager.search = search;
                      }
                    },
                    child: Container(
                      width: constraints.biggest.width,
                      child: Text(
                        productManager.search,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          Consumer<ProductManager>(
            builder: (_, productManager, __) {
              if (productManager.search.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                        context: context,
                        builder: (_) => SearchDialog(productManager.search));
                    if (search != null) {
                      productManager.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    productManager.search = '';
                  },
                );
              }
            },
          ),
          Consumer<UserManager>(
            builder: (_, userManager, __) {
              if (userManager.adminEnabled) {
                return IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/edit_product',
                      arguments: {
                        'categoryId': widget.categoryId,
                        // 'product': product
                      },
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          final filteredCategoryProducts = productManager.filteredCategoryProducts;
          return ListView.builder(
              itemCount: filteredCategoryProducts.length,
              itemBuilder: (_, index) {
                return ProductListTile(
                    filteredCategoryProducts[index], widget.categoryId);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
