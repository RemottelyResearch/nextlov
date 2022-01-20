import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextlov/models/category_manager.dart';
import 'package:nextlov/models/category_model.dart';
import 'package:provider/provider.dart';

import 'components/images_form.dart';

class EditCategoryScreen extends StatelessWidget {
  EditCategoryScreen(CategoryModel c)
      : editing = c != null,
        categoryModel = c != null ? c.clone() : CategoryModel();

  final CategoryModel categoryModel;
  final bool editing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: categoryModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar Categoria' : 'Criar Categoria'),
          centerTitle: true,
          actions: <Widget>[
            if (editing)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context.read<CategoryManager>().delete(categoryModel);
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
              ImagesForm(categoryModel),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      initialValue: categoryModel.name,
                      decoration: const InputDecoration(
                        hintText: 'Título',
                        border: InputBorder.none,
                      ),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      validator: (name) {
                        if (name.isEmpty) return 'Insira um nome';
                        return null;
                      },
                      onSaved: (name) => categoryModel.name = name,
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
                    TextFormField(
                      initialValue: categoryModel.basePrice != null
                          ? categoryModel.basePrice.toStringAsFixed(2)
                          : '',
                      decoration: const InputDecoration(
                        hintText: 'Preço Base',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.digitsOnly,
                      // ],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      validator: (basePrice) {
                        if (basePrice.isEmpty) return 'Insira um valor base';
                        return null;
                      },
                      onSaved: (basePrice) =>
                          categoryModel.basePrice = double.parse(basePrice),
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
                      initialValue: categoryModel.description,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                          hintText: 'Descrição', border: InputBorder.none),
                      maxLines: null,
                      validator: (desc) {
                        if (desc.isEmpty) return 'Insira uma descrição';
                        return null;
                      },
                      onSaved: (desc) => categoryModel.description = desc,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<CategoryModel>(
                      builder: (_, categoryModel, __) {
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: !categoryModel.loading
                                ? () async {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();

                                      await categoryModel.save();

                                      context
                                          .read<CategoryManager>()
                                          .update(categoryModel);

                                      Navigator.of(context).pop();
                                    }
                                  }
                                : null,
                            textColor: Colors.white,
                            color: primaryColor,
                            disabledColor: primaryColor.withAlpha(100),
                            child: categoryModel.loading
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
