import 'package:flutter/material.dart';

import '../api/firestore.dart';
import '../models/cloth.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Cloth> cartItems = [];

  @override
  void initState() {
    super.initState();
    getClothesFromCart();
  }

  void getClothesFromCart() async {
    cartItems = await Firestore.getClothesFromUserCart();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Panier'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length + 1,
        itemBuilder: (context, index) {
          if (index < cartItems.length) {
            return CartItemTile(
              item: cartItems[index],
              onDelete: () async {
                await Firestore.deleteFromCart(cartItems[index]);
                setState(() {
                  cartItems.removeAt(index);
                });
              },
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total : \$$totalPrice',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final Cloth item;
  final VoidCallback onDelete;

  const CartItemTile({Key? key, required this.item, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        child: Image.network(item.imageUrl),
        width: 50,
      ),
      title: Text(item.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Size: ${item.size}'),
          Text('\$${item.price}'),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
