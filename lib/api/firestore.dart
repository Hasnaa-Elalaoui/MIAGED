import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_name/models/cloth.dart';
import 'package:startup_name/models/user.dart';

import '../models/cart.dart';

class Firestore {

  // check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    return userId != null ? true : false;
  }

  // retrieve the user from data base and store userId in local storage
  static Future<bool> logUser(String login, String password) async {
    var matchedUsers = (await FirebaseFirestore.instance
        .collection('users')
        .where("login", isEqualTo: login)
        .where("password", isEqualTo: password)
        .get())
        .docs
        .length;
    if (matchedUsers > 0){
       String userId = (await getRefUserByLogin(login)).id;
       final prefs = await SharedPreferences.getInstance();
       await prefs.setString('userId', userId);
       return true;
    }
    return false;
  }

  static Future<List<Cloth>> getAllClothes() async {
    return (await FirebaseFirestore.instance
        .collection("clothes")
        .get())
        .docs
        .map((item) => Cloth.fromMap(item.data()))
        .toList();
  }

  static Future<Cloth> getClothById(String clothId) async {
    var data = (await FirebaseFirestore.instance
        .collection('clothes')
        .doc(clothId)
        .get())
        .data();

    return Cloth.fromMap(data!);
  }

  // get all clothes id from user cart
  static Future<List<Cloth>> getClothesFromUserCart() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';

    Cart cart = await getCartFromUserId(userId);

    return getClothesFromArray(cart.clothesIds);
  }

  // get all clothes object from clothes ids
  static Future<List<Cloth>> getClothesFromArray(List<String> clothesIds) async {
    List<Cloth> clothesList = [];
    for (var clothId in clothesIds) {
      clothesList.add(await getClothById(clothId));
    }
    return clothesList;
  }

  static Future<Cart> getCartFromUserId(String userId) async {
    var data = (await FirebaseFirestore.instance
        .collection('carts')
        .where("userId", isEqualTo: userId)
        .get())
        .docs;
    var carts = data.map((item) => Cart.fromMap(item.data()));
    return carts.first;
  }

  // get cart ref (database document) from user id
  static Future<DocumentSnapshot> getCartRefFromUserId(String userId) async {
    return (await FirebaseFirestore.instance
        .collection('carts')
        .where("userId", isEqualTo: userId)
        .get())
        .docs[0];
  }

  // get user ref (database document) by login
  static Future<DocumentSnapshot> getRefUserByLogin(String login) async {
    return (await FirebaseFirestore.instance
        .collection('users')
        .where("login", isEqualTo: login)
        .get())
        .docs[0];
  }

  // get cloth ref (database document) by name
  static Future<DocumentSnapshot> getClothRefByName(String name) async {
    return (await FirebaseFirestore.instance
        .collection('clothes')
        .where("name", isEqualTo: name)
        .get())
        .docs[0];
  }

  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    var data = (await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get())
        .data();
    return User.fromMap(data!);
  }

  static Future updateUser(String documentId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(documentId)
        .update(data);
  }

  // add cloth to cart :
  // - retrieve user cart
  // - retrieve cart document id
  // - retrieve cloth document id
  // - if cloth does not exists in cart, add it to user cart then return true
  // - if already in cart, return false
  static Future<bool> addToCart(Cloth cloth) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    Cart cart = await getCartFromUserId(userId);
    String documentId = (await getCartRefFromUserId(userId)).id;
    String clothId = (await getClothRefByName(cloth.name)).id;
    if (!cart.clothesIds.contains(clothId)) {
      cart.clothesIds.add(clothId);
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(documentId)
          .update(cart.toMap());
      return true;
    } else {
      return false;
    }
  }

  // delete cloth from cart :
  // - retrieve user cart
  // - retrieve cart document id
  // - retrieve cloth document id
  // - if cloth does exists in cart, delete it from user cart
  static Future deleteFromCart(Cloth cloth) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    Cart cart = await getCartFromUserId(userId);
    String documentId = (await getCartRefFromUserId(userId)).id;
    String clothId = (await getClothRefByName(cloth.name)).id;
    if (cart.clothesIds.contains(clothId)) {
      cart.clothesIds.remove(clothId);
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(documentId)
          .update(cart.toMap());
    }
  }
}