import 'package:flutter/material.dart';
import 'package:grocery_list/data/categories.dart';
import 'package:grocery_list/models/grocery_item.dart';
import 'package:grocery_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final url = Uri.https('backend-practice-cbac2-default-rtdb.firebaseio.com', '/list.json');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);
        
        if (data != null) {
          final List<GroceryItem> loadedItems = [];
          data.forEach((id, itemData) {
            final category = categories.values.firstWhere((cat) => cat.title == itemData['category']);
            loadedItems.add(GroceryItem(
              id: id,
              name: itemData['name'],
              quantity: itemData['quantity'],
              category: category,
            ));
          });
          setState(() {
            _groceryItems = loadedItems;
          });
        } else {
          setState(() {
            _groceryItems = []; // No data found, initialize with an empty list
          });
        }
      } else {
        print('Failed to load items. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching items: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteItem(String id) async {
    final url = Uri.https('backend-practice-cbac2-default-rtdb.firebaseio.com', '/list/$id.json');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          _groceryItems.removeWhere((item) => item.id == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item deleted successfully')),
        );
      } else {
        print('Failed to delete item. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting item: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'What do you want?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => _addNewItem(context),
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _groceryItems.isEmpty
              ? const Center(
                  child: Text(
                    'No items added yet!',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: _groceryItems.length,
                  itemBuilder: (ctx, index) {
                    final item = _groceryItems[index];
                    return Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _deleteItem(item.id);
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        title: Text(
                          item.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        leading: Container(
                          width: 24,
                          height: 24,
                          color: item.category.color,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.quantity.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                _deleteItem(item.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _addNewItem(BuildContext context) async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx) => const NewItem()),
    );

    if (newItem != null) {
      setState(() {
        _groceryItems.add(newItem);
      });
    }
  }
}
