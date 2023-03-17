import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_name/models/user.dart';

import 'LoginPage.dart';
import '../api/firestore.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  bool loaded = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      currentDate: _selectedDate,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      print(
          formattedDate); //formatted date output using intl package =>  2021-03-16
      setState(() {
        _selectedDate = picked;
        birthdateController.text = formattedDate;
      });
    }
  }

  updateControllers(User user) {
    loginController.text = user.login;
    passwordController.text = user.password;
    addressController.text = user.address;
    postalCodeController.text =
        user.postal_code.toString();
    birthdateController.text =
        DateFormat('yyyy-MM-dd').format(user.birthdate);
    cityController.text = user.city;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Mon Profil'),
        actions: [
          TextButton(
            onPressed: () async {
                // gather new user data from the form
                var patchedUser = User(
                    login: loginController.text,
                    password: passwordController.text,
                    postal_code: int.parse(postalCodeController.text),
                    address: addressController.text,
                    city: cityController.text,
                    birthdate: DateTime.parse(birthdateController.text)
                );
                // retrieve userId from localStorage
                final prefs = await SharedPreferences.getInstance();
                final userId = prefs.getString('userId');
                if(userId != null) {
                  await Firestore.updateUser(userId, patchedUser.toMap());
                  updateControllers(patchedUser);
                }
            },
            child: Text(
              'Valider',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: Firestore.getCurrentUser(),
            builder: (context, snapshot) {
              print('data :' + snapshot.data.toString());
              if (snapshot.hasData) {
                if (!loaded) {
                  updateControllers(snapshot.data!);
                  loaded = true;
                }
                return Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: loginController,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelText: 'Login',
                            labelStyle: TextStyle(color: Colors.grey)),
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.grey)),
                      ),
                      TextFormField(
                        controller: birthdateController,
                        //editing controller of this TextField
                        decoration: InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            labelText: "Birthdate" //label text of field
                            ),
                        readOnly: true,
                        //set it true, so that user will not able to edit text
                        onTap: () async {
                          _selectDate(context);
                        },
                      ),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                        ),
                      ),
                      TextFormField(
                        controller: postalCodeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: 'Postal Code',
                        ),
                      ),
                      TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                          labelText: 'City',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('userId');
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                                (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Background color
                        ),
                        child: Text(
                          'Se déconnecter',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Text("loading...");
              }
            }),
      ),

    );
  }
}
