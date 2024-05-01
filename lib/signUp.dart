import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Login.dart';
import 'package:weather_app/ip.dart';
import 'package:lottie/lottie.dart';

class signUp extends StatefulWidget {
  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController profile = TextEditingController();

  Future _signUp() async {
    final response = await http.post(
      Uri.parse(myIp + ":80/myweather/signUp.php"),
      body: {
        "username": username.text,
        "email": email.text,
        "profile": profile.text,
        "password": password.text,
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(13, 17, 23, 1.0),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
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
                children: [
                  SafeArea(
                      child: SizedBox(
                    height: 20,
                  )),
                  Container(
                      width: 150,
                      height: 150,
                      child: Lottie.asset('assets/animations/fewclouds.json')),
                  SizedBox(
                    height: 0,
                  ),
                  Text(
                    'Sign in to Cuaca',
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
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Username",
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
                              controller: username,
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
                                  return "Username tidak boleh kosong";
                                }
                              },
                            ),
                            SizedBox(height: 20.0),
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
                                  return "Email tidak boleh kosong";
                                }
                              },
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
                                if (formKey.currentState!.validate()) {
                                  _signUp().then((value) {
                                    if (value) {
                                      final snackBar = SnackBar(
                                        content: const Text(
                                            'Data berhasil disimpan'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      // Navigasi ke halaman Login setelah signUp berhasil
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => Login()),
                                        (route) => false,
                                      );
                                    } else {
                                      final snackBar = SnackBar(
                                        content:
                                            const Text('Data gagal disimpan'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      // Tidak melakukan navigasi jika signUp gagal
                                    }
                                  });
                                }
                              },
                              child: Text('Sign in'),
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
                          'Sudah punya akun?',
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
                                      builder: (context) => Login()));
                            },
                            child: Text(
                              "Login disini",
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
      ),
    );
  }
}
