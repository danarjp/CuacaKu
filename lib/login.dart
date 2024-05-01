import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/ip.dart';
import 'package:weather_app/signUp.dart';
import 'package:weather_app/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  static Future<void> saveuser_id(int user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', user_id);
  }

  Future<List> _login() async {
    final response =
        await http.post(Uri.parse(myIp + ":80/myweather/login.php"), body: {
      "email": email.text,
      "password": password.text,
    });
    print(response.body);
    if (response.statusCode == 200) {
      if (response.body.contains("Login berhasil")) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final int user_id = responseData['user_id'];
        await saveuser_id(user_id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
      return [];
    } else {
      final snackBar = SnackBar(
        content: const Text('Login gagal'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw Exception('Gagal melakukan login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(134, 182, 246, 1.0),
              Color.fromRGBO(23, 107, 135, 1.0),
              Color.fromRGBO(54, 84, 134, 1.0),
            ], // Ganti dengan warna gradasi yang diinginkan
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 150,
                    height: 150,
                    child: Lottie.asset('assets/animations/fewclouds.json',
                        fit: BoxFit.cover)),
                SizedBox(
                  height: 0,
                ),
                Text(
                  'Login to Cuaca',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 320,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(223, 249, 255, 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Email",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: email,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              filled: true,
                              fillColor: Color.fromRGBO(13, 17, 23, 0.3),
                              hintStyle: TextStyle(color: Colors.blue),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(208, 205, 191, 0.7),
                                    width: 0.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(29, 94, 206, 1.0),
                                    width: 2),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Password",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: password,
                            style: TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              filled: true,
                              fillColor: Color.fromRGBO(13, 17, 23, 0.3),
                              hintStyle: TextStyle(color: Colors.blue),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(208, 205, 191, 0.7),
                                    width: 0.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(29, 94, 206, 1.0),
                                    width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password tidak boleh kosong";
                              }
                            },
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 3, 185, 97),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                minimumSize: Size(double.infinity, 45)),
                            onPressed: () {
                              _login().then((_) {}).catchError((error) {
                                // Tangani error jika diperlukan
                              });
                            },
                            child: Text('Login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 320,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(223, 249, 255, 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun?',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => signUp()));
                          },
                          child: Text(
                            "signUp disini",
                            style: TextStyle(
                                color: Color.fromRGBO(29, 94, 206, 1.0),
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
