import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/models/grocery_item.dart';
import '../data/categories.dart';
import 'new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
   List<GroceryItem> _groceryItems = [];
   var _isLoading = true;
   String? _error;

  initState(){
    super.initState();
    _loadItems();
  }

  _loadItems()async{
    final url = Uri.https('shopping-list-a5342-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(url);
    if(response.statusCode >= 400){
      setState(() {
        _error = 'Failed to fetch data. Please try again later.';
      });
    }
    final Map<String, dynamic> listData = json.decode(response.body);
    List<GroceryItem> listItem = [];
    for(final item in listData.entries){
      final category = categories.entries.firstWhere(
          (catItem) => catItem.value.title == item.value['category']).value;
      listItem.add(
        GroceryItem(id: item.key, name: item.value['name'], quantity: item.value['quantity'], category: category)
      );
    }
    setState(() {
      _groceryItems = listItem;
      _isLoading = false;
    });

  }

  _addNewItem() async{
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if(newItem == null){
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  _removeItem(GroceryItem item) {
    final removedExpenseIndex = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} removed'), duration: Duration(seconds: 3), action: SnackBarAction(label: 'Undo', onPressed: (){
          setState(() {
            _groceryItems.insert(removedExpenseIndex, item);
          });
      }),),
    );
  }
  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text('No items added yet.'));
    if(_isLoading){
      content = Center(child: CircularProgressIndicator(),);
    }
    if(_groceryItems.isNotEmpty){
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(_groceryItems[index].id),
            onDismissed: (direction) {
              _removeItem(_groceryItems[index]);
            },
            child: ListTile(
              title: Text(_groceryItems[index].name),
              leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[index].category.color,
              ),
              trailing: Text(_groceryItems[index].quantity.toString()),
            ),
          );
        },
      );
    }

    if(_error != null){
      content = Center(child: Text(_error!),);
    }
    return Scaffold(
      appBar: AppBar(title: Text('Your Grocery List'), actions: [
        IconButton(onPressed: _addNewItem, icon: Icon(Icons.add),),
      ],),

      body: content
    );
  }
}
