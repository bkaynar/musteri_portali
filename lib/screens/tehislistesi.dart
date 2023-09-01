import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musteri_portali/screens/tehisekleme.dart';
import 'navbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:musteri_portali/core/variables.dart';

class TehisListesi extends StatelessWidget {
  const TehisListesi({super.key});

  @override
  Widget build(BuildContext context) {
    return tehis();
  }
}

class tehis extends StatefulWidget {
  const tehis({super.key});

  @override
  State<tehis> createState() => _tehisState();
}

class _tehisState extends State<tehis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Navbar(),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add_box_outlined,
              size: 32,
            ),
            tooltip: 'Comment Icon',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TehisEkleme(),
                ),
              );
            },
          ),
        ],
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
                'Müşteri Portalı -> Tehis Listesi',
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
  List<dynamic> tehisler = [];

  Future<void> veriCek() async {
    final response = await http.get(Uri.parse(
      'http://10.0.2.2:8080/tehis/getByMusteriId/${musteriId}',
    ));

    if (response.statusCode == 200) {
      setState(() {
        tehisler.clear();
        final jsonData = utf8
            .decode(response.bodyBytes); // UTF-8 kodlamasını kullanarak çözümle
        tehisler = json.decode(jsonData);
        print(tehisler.toString());
      });
      setState(() {});
    }
  }

  final List<String> items = List<String>.generate(10, (i) => '$i');
  @override
  void initState() {
    // TODO: implement initState
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
                  i <= tehisler.length - 1;
                  i++) // Original card + 15 new cards
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          imza_tarihi: tehisler[i]['imza_tarihi'],
                          baslangic_tarihi: tehisler[i]['baslangic_tarihi'],
                          bitis_tarihi: tehisler[i]['bitis_tarihi'],
                          serbest_tuketici: tehisler[i]['serbestTuketici']
                              ['st_adi'],
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
                          "Başlangıç Tarihi:${(tehisler[i]['baslangic_tarihi'].toString().substring(0, 10))}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Bitiş Tarihi:${(tehisler[i]['bitis_tarihi'].toString().substring(0, 10))}",
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
  var serbest_tuketici;

  DetailPage({
    required this.imza_tarihi,
    required this.baslangic_tarihi,
    required this.bitis_tarihi,
    required this.serbest_tuketici,
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
              '$baslangic_tarihi'.toString().substring(0, 10),
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
              '$bitis_tarihi'.toString().substring(0, 10),
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
              '$imza_tarihi'.toString().substring(0, 10),
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
              'Serbest Tüketici Adı:',
              style: TextStyle(fontSize: 28),
            ),
            subtitle: Text(
              '$serbest_tuketici'.toString().substring(0, 10),
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
