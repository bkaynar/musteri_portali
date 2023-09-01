import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'navbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:musteri_portali/core/variables.dart';

class TahisListesi extends StatelessWidget {
  const TahisListesi({super.key});

  @override
  Widget build(BuildContext context) {
    return tahis();
  }
}

class tahis extends StatefulWidget {
  const tahis({super.key});

  @override
  State<tahis> createState() => _tahisState();
}

class _tahisState extends State<tahis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Navbar(),
      appBar: AppBar(
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'BOTAŞ',
            ),
            Visibility(
              visible: true,
              child: Text(
                'Müşteri Portalı -> Tahis Listesi',
                style: TextStyle(fontSize: 10.0, letterSpacing: 1),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 210, 20, 26),
      ),
      body: const Tablolama(),
    );
  }
}

class Tablolama extends StatefulWidget {
  const Tablolama({super.key});

  @override
  State<Tablolama> createState() => _TablolamaState();
}

class _TablolamaState extends State<Tablolama> {
  List<dynamic> tahisler = [];

  Future<void> veriCek() async {
    final response = await http.get(Uri.parse(
      'http://10.0.2.2:8080/tahis/getByMusteriId/${musteriId}',
    ));

    if (response.statusCode == 200) {
      setState(() {
        tahisler.clear();
        tahisler = json.decode(response.body);
        print(tahisler.toString());
      });
      setState(() {});
    }
  }

  final List<String> items = List<String>.generate(10, (i) => '$i');
  @override
  void initState() {
    super.initState();
    veriCek();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0;
                  i <= tahisler.length - 1;
                  i++) // Original card + 15 new cards
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          imza_tarihi: tahisler[i]['imza_tarihi'],
                          baslangic_tarihi: tahisler[i]['baslangic_tarihi'],
                          bitis_tarihi: tahisler[i]['bitis_tarihi'],
                          botas_odeyecegi_tutar: tahisler[i]
                              ['botas_odeyecegi_tutar'],
                          musteri_odeyecegi_tutar: tahisler[i]
                              ['musteri_odeyecegi_tutar'],
                          damga_vergisi: tahisler[i]['damga_vergisi'],
                        ),
                      ),
                    ),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        title: Text(
                          "Baslangıç Tarihi:${tahisler[i]['baslangic_tarihi'].toString().substring(0, 10)}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Bitiş Tarihi:${(tahisler[i]['bitis_tarihi'].toString().substring(0, 10))}",
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Icon(Icons.more_vert_sharp),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  var imza_tarihi;
  var baslangic_tarihi;
  var bitis_tarihi;
  var botas_odeyecegi_tutar;
  var musteri_odeyecegi_tutar;
  var damga_vergisi;

  DetailPage({
    required this.imza_tarihi,
    required this.baslangic_tarihi,
    required this.bitis_tarihi,
    required this.botas_odeyecegi_tutar,
    required this.musteri_odeyecegi_tutar,
    required this.damga_vergisi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'BOTAŞ',
            ),
            Visibility(
              visible: true,
              child: Text(
                'Müşteri Portalı',
                style: TextStyle(fontSize: 10.0, letterSpacing: 1),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 210, 20, 26),
      ),
      body: Column(children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Container(
          height: 60,
          child: CupertinoListTile(
            title: Text(
              'Başlangıç Tarihi:',
              style: TextStyle(fontSize: 28),
            ),
            subtitle: Text(
              '$baslangic_tarihi.'.toString().substring(0, 10),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 60,
          child: CupertinoListTile(
            title: Text(
              'Bitiş Tarihi:',
              style: TextStyle(fontSize: 28),
            ),
            subtitle: Text(
              '$bitis_tarihi.'.toString().substring(0, 10),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 60,
          child: CupertinoListTile(
            title: Text(
              'İmza Tarihi:',
              style: TextStyle(fontSize: 28),
            ),
            subtitle: Text(
              '$imza_tarihi.'.toString().substring(0, 10),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 60,
          child: CupertinoListTile(
            title: Text(
              'Müşteri Ödeyeceği Tutar:',
              style: TextStyle(fontSize: 28),
            ),
            subtitle: Text(
              '$musteri_odeyecegi_tutar ₺',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 60,
          child: CupertinoListTile(
            title: Text(
              'Botaş Ödeyeceği Tutar:',
              style: TextStyle(fontSize: 28),
            ),
            subtitle: Text(
              '$botas_odeyecegi_tutar ₺',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 60,
          child: CupertinoListTile(
            title: Text(
              'Damga Vergisi:',
              style: TextStyle(fontSize: 28),
            ),
            subtitle: Text(
              '$damga_vergisi ₺',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
