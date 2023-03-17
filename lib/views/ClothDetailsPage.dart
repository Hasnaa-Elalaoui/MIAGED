import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:startup_name/api/firestore.dart';

import '../models/cloth.dart';
import 'MenuPage.dart';

class ClothDetailPage extends StatelessWidget {
  final Cloth cloth;

  const ClothDetailPage({Key? key, required this.cloth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloth Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              cloth.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cloth.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Brand: ${cloth.brand}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Size: ${cloth.size}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Price: \$${cloth.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  cloth.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    var isAdded = await Firestore.addToCart(cloth);
                    // if cloth has been correclty added to cart
                    if (isAdded) {
                      Fluttertoast.showToast(
                        gravity: ToastGravity.BOTTOM,
                        msg: 'Votre article a bien été ajouté',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MenuPage()),
                      );
                    } else {
                      Fluttertoast.showToast(
                        gravity: ToastGravity.BOTTOM,
                        msg: 'Article déjà dans le panier',
                        backgroundColor: Colors.orangeAccent,
                        webBgColor: '#FFAB40FF',
                        textColor: Colors.white,
                      );
                    }
                  },
                  child: Text('Ajouter au panier'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
