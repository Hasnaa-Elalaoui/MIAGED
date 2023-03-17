import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:startup_name/api/firestore.dart';

import 'MenuPage.dart';

class LoginPage extends StatelessWidget {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('MIAGED'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Veuillez saisir un login';
                }
              },
              controller: loginController,
              decoration: InputDecoration(
                labelText: 'Login',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Veuillez saisir un mot de passe';
                }
              },
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Se connecter'),
              onPressed: () async {
                String login = loginController.text;
                String password = passwordController.text;
                showDialog(
                    // loading dialog
                    barrierDismissible: false,
                    context: context,
                    builder: (_) {
                      return Dialog(
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 15,
                              ),
                              Text('Chargement...')
                            ],
                          ),
                        ),
                      );
                    });
                bool isLoggedIn = await Firestore.logUser(login, password);
                if (isLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuPage()),
                  );
                } else {
                  Fluttertoast.showToast(
                    gravity: ToastGravity.BOTTOM,
                    msg: 'Identifiant ou mot de passe incorrect',
                    backgroundColor: Colors.red,
                    webBgColor: '#FF0000',
                    textColor: Colors.white,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
