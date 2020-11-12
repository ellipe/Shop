import 'package:Shop/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// provider
import '../providers/product.dart';
import '../providers/products.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _isInit = true;
  bool _isLoading = false;

  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final productData =
            Provider.of<Products>(context, listen: false).findById(productId);
        _editedProduct = productData;
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();

    super.dispose();
  }

  String title;
  String imageUrl;

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    var _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();
    _isLoading = true;
    final productProvider = Provider.of<Products>(context, listen: false);
    if (_editedProduct.id == null) {
      try {
        await productProvider.addProduct(_editedProduct);
      } catch (e) {
        print('Error handled in widget, created a showDialog should be useful');
        print(e);
      } finally {
        Navigator.of(context).pop();
        _isLoading = false;
      }
      
    } else {
      productProvider.updateProduct(_editedProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              })
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            isFavorite: _editedProduct.isFavorite,
                            id: _editedProduct.id,
                            title: value,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Title can\'t be empty';
                          }
                          return null;
                        },
                        initialValue: _editedProduct.title,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            isFavorite: _editedProduct.isFavorite,
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value),
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Price can\'t be empty';
                          }

                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }

                          if (double.parse(value) <= 0) {
                            return 'Please enter a value bigger than 0';
                          }
                          return null;
                        },
                        initialValue: _editedProduct.price.toString(),
                      ),
                      TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Description',
                          ),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              isFavorite: _editedProduct.isFavorite,
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: value,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Description can\'t be empty';
                            }

                            if (value.length < 10) {
                              return 'Description must be at least of 10 characters.';
                            }
                            return null;
                          },
                          initialValue: _editedProduct.description),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Center(
                                    child: Text('X',
                                        style: TextStyle(
                                          fontSize: 80,
                                        )),
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Image URL',
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                setState(() {
                                  _saveForm();
                                });
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  isFavorite: _editedProduct.isFavorite,
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: value,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter an image url.';
                                }

                                if (!value.startsWith('http') &&
                                    !value.startsWith('http')) {
                                  return 'Please enter a valid URL';
                                }

                                if (!value.endsWith('png') &&
                                    !value.endsWith('jpg') &&
                                    !value.endsWith('bmp')) {
                                  return 'Please enter a valid image URL';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
    );
  }
}
