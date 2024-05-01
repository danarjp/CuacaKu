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
import 'package:weather/weather.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> weatherData = [];
  final formkey = GlobalKey<FormState>();
  TextEditingController kota = TextEditingController();

  //get user_id
  static Future<int?> getuser_id() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  //panggil cuaca
  Future<void> getWeather() async {
    int? user_id = await getuser_id();
    final response = await HTTP.get(
      Uri.parse(myIp + ":80/myweather/read.php?user_id=$user_id"),
    );
    if (response.statusCode == 200) {
      if (response.body.contains("kebusek")) {}
      setState(() => weatherData =
          List<Map<String, dynamic>>.from(jsonDecode(response.body)));
    } else {
      throw Exception('Failed to load data');
    }
  }

  String _getWheaterAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/animations/clear.json';

    switch (mainCondition.toLowerCase()) {
      case '01d': //clear siang
        return 'assets/animations/clear.json';
      case '01n': //clear malam
        return 'assets/animations/clear-night.json';
      case '02d': //few clouds siang
        return 'assets/animations/fewclouds.json';
      case '02n': //few clouds malam
        return 'assets/animations/fewclouds-night.json';
      case '03d': //scattered clouds siang
      case '03n': //scattered clouds malam
      case '04d': //broken clouds siang
      case '04n': //broken clouds malam
        return 'assets/animations/scatteredclouds.json';
      case '09d': //showe rain siang
      case '10d': //rain siang
        return 'assets/animations/rain.json';
      case '09n': //shoower rain malam
      case '10n': //rain malam
        return 'assets/animations/rain-night.json';
      case '11d': //thunderstorm siang
        return 'assets/animations/thunderstormrain.json';
      case '11n': //thunderstorm malam
        return 'assets/animations/thunderstormrain-night.json';
      case '13d': //snow siang
      case '13n': //snow malam
      case '50d': //mist siang
      case '50n': //mist malam
        return 'assets/animations/mist.json';
      default:
        return 'assets/animations/fewclouds.json';
    }
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  Future _simpan() async {
    int? user_id = await getuser_id();
    final response =
        await HTTP.post(Uri.parse(myIp + ":80/myweather/lokasi.php"), body: {
      "kota": kota.text,
      "user_id": user_id.toString(),
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
        body: PageView.builder(
          itemCount: weatherData.length,
          itemBuilder: (context, index) {
            return RefreshIndicator(
              onRefresh: () async {
                await getWeather();

                return null;
              },
              child: Container(
                padding: EdgeInsets.only(top: 20),
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
                  child: ListView(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    child: Text(
                                      weatherData[index]['name'] ?? 'Unknown',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          ?.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 60),
                              Container(
                                height: 100,
                                width: 150,
                                child: Lottie.asset(
                                    _getWheaterAnimation(weatherData[index]
                                            ['weather']?[0]['icon'] ??
                                        '01d'),
                                    fit: BoxFit.cover),
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
                                              fontSize: 125,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 30),
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
                              Text(
                                weatherData[index]['weather']?[0]['description']
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
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color.fromRGBO(223, 249, 255, 0.3)),
                                child: Text(
                                  'Humidity ' +
                                      '${weatherData[index]['main']?['humidity']?.toStringAsFixed(0) ?? "0"}' +
                                      '%',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 60),
                              Container(
                                width: 350,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color.fromRGBO(223, 249, 255, 0.3)),
                                padding: EdgeInsets.all(20),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 150,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Terasa seperti',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.7),
                                              ),
                                            ),
                                            Text(
                                              '${weatherData[index]['main']?['feels_like']?.toStringAsFixed(0) ?? "0"}' +
                                                  '°C',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Keceptan angin',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.7),
                                              ),
                                            ),
                                            Text(
                                              '${weatherData[index]['wind']?['speed']?.toStringAsFixed(0) ?? "0"}' +
                                                  'm/s',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Temperatur min',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.7),
                                              ),
                                            ),
                                            Text(
                                              '${weatherData[index]['main']?['temp_min']?.toStringAsFixed(0) ?? "0"}' +
                                                  '°C',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Humidity',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.7),
                                              ),
                                            ),
                                            Text(
                                              '${weatherData[index]['main']?['humidity']?.toStringAsFixed(0) ?? "0"}' +
                                                  '%',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Pressure',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.7),
                                              ),
                                            ),
                                            Text(
                                              '${weatherData[index]['main']?['pressure']?.toStringAsFixed(0) ?? "0"}' +
                                                  'mbar',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Temperatur max',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.7),
                                              ),
                                            ),
                                            Text(
                                              '${weatherData[index]['main']?['temp_max']?.toStringAsFixed(0) ?? "0"}' +
                                                  '°C',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        //menu
        floatingActionButton: PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              //tambah kota
              PopupMenuItem(
                child: IconButton(
                  icon: Icon(Icons.add_circle_rounded),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext) => AlertDialog(
                        backgroundColor: Color.fromRGBO(223, 249, 255, 0.3),
                        title: Text(
                          'Tambah kota',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(255, 255, 255, 1.0),
                          ),
                        ),
                        content: Form(
                          key: formkey,
                          child: TextFormField(
                            controller: kota,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              filled: true,
                              fillColor: Color.fromRGBO(235, 243, 255, 0.3),
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
                        ),
                        actions: [
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
                                if (formkey.currentState!.validate()) {
                                  _simpan().then(
                                    (value) {
                                      if (value) {
                                        final snackBar = SnackBar(
                                            content: const Text(
                                                "Kota berhasil ditambahkan"));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        final snackBar = SnackBar(
                                            content: const Text(
                                                "Kota gagal ditambahkan"));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                  );
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => HomePage())),
                                      (route) => false);
                                }
                              },
                              child: Text("Simpan")),
                        ],
                      ),
                    );
                  },
                ),
              ),

              //delete
              PopupMenuItem(
                child: IconButton(
                  icon: Icon(Icons.person_2_rounded),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromRGBO(223, 249, 255, 0.5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Manage Lokasi",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: weatherData.length,
                                    itemBuilder: (context, index) {
                                      MainAxisAlignment.center;
                                      return Column(
                                        children: [
                                          Container(
                                            height: 90,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color.fromRGBO(
                                                        134, 182, 246, 0.7),
                                                    Color.fromRGBO(
                                                        23, 107, 135, 0.7),
                                                    Color.fromRGBO(
                                                        54, 84, 134, 0.7),
                                                  ], // Ganti dengan warna gradasi yang diinginkan
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  width: 70,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        weatherData[index]
                                                                ['name'] ??
                                                            'Tidak Diketahui',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 25,
                                                        child: Lottie.asset(
                                                            _getWheaterAnimation(
                                                                weatherData[index]
                                                                            [
                                                                            'weather']
                                                                        ?[
                                                                        0]['icon'] ??
                                                                    '01d'),
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 50,
                                                  child: Text(
                                                    '${weatherData[index]['main']?['temp']?.toStringAsFixed(0) ?? "0"}' +
                                                        '°',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                Container(
                                                  child: GestureDetector(
                                                    child: Icon(
                                                      Icons.delete_rounded,
                                                      color: Color.fromRGBO(
                                                          187, 33, 22, 0.7),
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ];
          },
        ),
      ),
    );
  }

/*
  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              " ${DateFormat("d,m,y").format(now)}",
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "HTTPs://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text("${_weather?.temperature?.celsius?.toStringAsFixed(0)}° c");
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).height * 0.80,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° c",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° c",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Humadity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }*/
}
