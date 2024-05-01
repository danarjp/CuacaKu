import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as HTTP;
import 'package:intl/intl.dart';
import 'package:weather_app/api_service.dart';
import 'package:weather_app/edit.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/signUp.dart';
import 'package:weather_app/lokasi.dart';
import 'package:weather_app/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/ip.dart';
import 'package:weather_app/homePage.dart';
import 'package:weather/weather.dart';
import 'package:lottie/lottie.dart';


/*
class edit extends StatefulWidget {
  edit(int? user_id);

  @override
  State<edit> createState() => _editState();
}

class _editState extends State<edit> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> weatherData = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static Future<int?> getuser_id() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<void> _getData() async {
    try {
      int? user_id = await getuser_id();
      final response = await HTTP.get(
        Uri.parse(myIp + ":80/myweather/readprofile.php?user_id=$user_id"),
      );
      if (response.statusCode == 200) {
        setState(() =>
            data = List<Map<String, dynamic>>.from(jsonDecode(response.body)));
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in _getData: $error');
    }
  }

  Future<void> getWeather() async {
    try {
      int? user_id = await getuser_id();
      final response = await HTTP.get(
        Uri.parse(myIp + ":80/myweather/read.php?user_id=$user_id"),
      );
      if (response.statusCode == 200) {
        setState(() => weatherData =
            List<Map<String, dynamic>>.from(jsonDecode(response.body)));
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in getWeather: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("pppp"),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await getWeather();

            return null;
          },
          child: Center(
            child: ListView.builder(
                itemCount: (weatherData).length,
                itemBuilder: (context, index) {
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
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
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Container(
                              child: Column(children: [
                                Text(
                                  weatherData[index]['name'] ?? 'Unknown',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                                Text(
                                  weatherData[index]['weather']?[0]
                                              ['description']
                                          ?.toString()
                                          ?.replaceFirstMapped(
                                            RegExp(r'^\w', caseSensitive: true),
                                            (match) =>
                                                match.group(0)!.toUpperCase(),
                                          ) ??
                                      'unknown',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 30),
                                      height: 180,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${weatherData[index]['main']?['temp']?.toStringAsFixed(0) ?? "0"}',
                                              style: TextStyle(
                                                fontSize: 50,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      height: 180,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '°C',
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Text('temp'),
                                  GestureDetector(
                                    child: Icon(Icons.delete),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
};
*/