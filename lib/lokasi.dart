import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as HTTP;
import 'package:weather_app/ip.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/signUp.dart';
import 'package:weather_app/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class lokasi extends StatefulWidget {
  const lokasi({super.key});
  @override
  State<lokasi> createState() => _lokasiState();
}

class _lokasiState extends State<lokasi> {
  final formkey = GlobalKey<FormState>();
  TextEditingController kota = TextEditingController();
  static Future<int?> getuser_id() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future _simpan() async {
    int? userId = await getuser_id();
    final response =
        await HTTP.post(Uri.parse(myIp + ":80/myweather/lokasi.php"), body: {
      "kota": kota.text,
      "user_id": userId.toString(),
    });
    print(response.body);
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
        appBar: AppBar(
          title: Text("Tambah Lokasi"),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: formkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: kota,
                    decoration: InputDecoration(hintText: "Masukkan kota"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Kota tidak boleh kosong";
                      }
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          _simpan().then((value) {
                            if (value) {
                              final snackBar = SnackBar(
                                  content:
                                      const Text("Kota berhasil ditambahkan"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              final snackBar = SnackBar(
                                  content:
                                      const Text("Kota gagal ditambahkan"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          });
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => HomePage())),
                              (route) => false);
                        }
                      },
                      child: Text("Simpan"))
                ],
              )),
        ),
      ),
    );
  }
}
