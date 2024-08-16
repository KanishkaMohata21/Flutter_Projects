import 'package:flutter/material.dart';
import 'package:grocery_list/data/categories.dart';
import 'package:grocery_list/models/category.dart';
import 'package:grocery_list/models/grocery_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  String? _enteredName;
  int _enteredQuantity = 1;
  Category _selectedCategory = categories[Categories.vegetable]!;

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _selectedCategory = categories[Categories.vegetable]!;
      _enteredQuantity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Item'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        labelStyle: const TextStyle(color: Colors.white),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.parse(value) < 1) {
                          return 'Please enter a valid quantity';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<Category>(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: const TextStyle(color: Colors.white),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      value: _selectedCategory,
                      items: categories.entries.map((entry) {
                        return DropdownMenuItem<Category>(
                          value: entry.value,
                          child: Text(
                            entry.value.title,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        );
                      }).toList(),
                      onChanged: (Category? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState!.save();
                        
                        final url = Uri.https('backend-practice-cbac2-default-rtdb.firebaseio.com', '/list.json');
                        
                        try {
                          final response = await http.post(
                            url,
                            headers: {
                              'Content-Type': 'application/json',
                            },
                            body: json.encode({
                              'name': _enteredName!,
                              'quantity': _enteredQuantity,
                              'category': _selectedCategory.title,
                            }),
                          );

                          if (response.statusCode == 200) {
                            // Successfully added the item
                            Navigator.of(context).pop(GroceryItem(
                              id: json.decode(response.body)['name'],
                              name: _enteredName!,
                              quantity: _enteredQuantity,
                              category: _selectedCategory,
                            ));
                          } else {
                            // Handle error
                            print('Failed to add item. Status code: ${response.statusCode}');
                          }
                        } catch (error) {
                          print('Error: $error');
                        }
                      }
                    },
                    child: const Text('Add Item'),
                  ),
                  TextButton(
                    onPressed: _resetForm,
                    child: const Text('Reset', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
