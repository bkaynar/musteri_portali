import 'package:flutter/material.dart';
import 'navbar.dart';
import 'package:musteri_portali/core/variables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int musteriId = 0;
  var musteriAdi = '';
  var kullaniciMail = '';
  @override
  void initState() {
    super.initState();
    _getMusteriId();
    _getMusteriAdi();
  }

  Future<void> _getMusteriId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      musteriId = prefs.getInt('musteriId') ?? 0;
    });
  }

  Future<void> _getMusteriAdi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      musteriAdi = prefs.getString('musteriAdi') ?? "";
    });
  }

  Future<void> _getKullaniciMail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      kullaniciMail = prefs.getString('kullaniciMail') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Navbar(),
      appBar: AppBar(
        title: Text('BOTAŞ MÜŞTERİ PORTALI'),
        backgroundColor: const Color.fromARGB(255, 210, 20, 26),
      ),
      body: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<Map<String, dynamic>> veriFuture;

  Future<Map<String, dynamic>> veriCek() async {
    final response = await http.get(Uri.parse(
      'http://10.0.2.2:8080/sozlesme/getMusteriyillikSozlesme/2023/${musteriId}',
    ));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Map<String, dynamic>.from(jsonData);
    } else {
      throw Exception('Veri getirilemedi.');
    }
  }

  @override
  void initState() {
    super.initState();
    veriFuture = veriCek();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: veriFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Hata: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('Veri bulunamadı.');
            } else {
              final veri = snapshot.data!;

              double ysmMiktar = veri['ysmMiktar'];
              double azamiYillikMiktar = veri['azamiYillikMiktar'];
              double aatOrani = veri['aatOrani'];
              double aatMiktar = ysmMiktar * aatOrani;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 350,
                    height: 135,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'YSM Miktar',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          '$ysmMiktar sm3',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 350,
                    height: 135,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Azami Yıllık Miktar',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          '$azamiYillikMiktar sm3',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 350,
                    height: 135,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'AAT Oranı',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          '%$aatOrani',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 350,
                    height: 135,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'AAT Miktarı',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          '$aatMiktar sm3',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
