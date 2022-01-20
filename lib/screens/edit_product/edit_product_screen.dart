import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nextlov/models/category_manager.dart';
import 'package:nextlov/models/category_model.dart';
// import 'package:nextlov/models/category_manager.dart';
import 'package:nextlov/models/product.dart';
import 'package:nextlov/models/product_manager.dart';
import 'package:nextlov/screens/edit_product/components/images_form.dart';
import 'package:nextlov/screens/edit_product/components/sizes_form.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(
    this.getMap,
    // Product p, this.categoryId
  );
  // : editing = getMap['product'] != null,
  //   product = getMap['product'] != null ? getMap['product'].clone() : Product();

  final Map<String, dynamic> getMap;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //  product =
    final Product prod = getMap['product'] as Product;
    final bool editing = getMap['product'] != null;
    final Product product =
        getMap['product'] != null ? prod.clone() : Product();
    final String categoryId = getMap['categoryId'] as String;
    final primaryColor = Theme.of(context).primaryColor;
    // final arguments =
    //     ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    // final productManager = context.watch<ProductManager>();
    // final categoryManager = context.watch<CategoryManager>();
    // print('OIOIOI:' + categoryManager.);
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar Produto' : 'Criar Produto'),
          centerTitle: true,
          actions: <Widget>[
            if (editing)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  context.read<ProductManager>().deleteCategoryProduct(product, categoryId);
                  Navigator.of(context).pop();
                },
              )
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              ImagesForm(product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                        hintText: 'Título',
                        border: InputBorder.none,
                      ),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      validator: (name) {
                        if (name.length < 6) return 'Título muito curto';
                        return null;
                      },
                      onSaved: (name) => product.name = name,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ...',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                          hintText: 'Descrição', border: InputBorder.none),
                      maxLines: null,
                      validator: (desc) {
                        if (desc.length < 10) return 'Descrição muito curta';
                        return null;
                      },
                      onSaved: (desc) => product.description = desc,
                    ),
                    SizesForm(product),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<Product>(
                      builder: (_, product, __) {
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: !product.loading
                                ? () async {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();

                                      await product.save(
                                          categoryId: categoryId);

                                      context
                                          .read<ProductManager>()
                                          .updateCategoryProduct(product);

                                      Navigator.of(context).pop();
                                    }
                                  }
                                : null,
                            textColor: Colors.white,
                            color: primaryColor,
                            disabledColor: primaryColor.withAlpha(100),
                            child: product.loading
                                ? CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  )
                                : const Text(
                                    'Salvar',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
