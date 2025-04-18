import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  addNewItem() async{
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

    return Scaffold(
      appBar: AppBar(title: Text('Your Grocery List'), actions: [
        IconButton(onPressed: addNewItem, icon: Icon(Icons.add),),
      ],),

      body: content
    );
  }
}
