import 'package:flutter/material.dart';
import 'package:musteri_portali/screens/navbar.dart';
import 'stuketiciekleme.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:musteri_portali/core/variables.dart';

void main() {
  const SerbestTuketiciBildirimi();
}

class SerbestTuketiciBildirimi extends StatelessWidget {
  const SerbestTuketiciBildirimi({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: STuketiciBildirimi(),
    );
  }
}

class STuketiciBildirimi extends StatefulWidget {
  const STuketiciBildirimi({super.key});

  @override
  State<STuketiciBildirimi> createState() => _STuketiciBildirimiState();
}

class _STuketiciBildirimiState extends State<STuketiciBildirimi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Tablolama(),
      drawer: Navbar(),
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
                  builder: (context) => STEkleme(),
                ),
              );
            },
          ),
        ],
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'BOTAŞ',
            ),
            Visibility(
              visible: true,
              child: Text(
                'Müşteri Portalı -> Serbest Tüketici Bildirimi',
                style: TextStyle(fontSize: 10.0, letterSpacing: 1),
              ),
            )
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 210, 20, 26),
      ),
    );
  }
}

class Tablolama extends StatefulWidget {
  @override
  State<Tablolama> createState() => _TablolamaState();
}

class _TablolamaState extends State<Tablolama> {
  List<dynamic> stler = [];

  Future<void> veriCek() async {
    final response = await http.get(Uri.parse(
      'http://10.0.2.2:8080/serbesttuketici/getByMusteriId/${musteriId}',
    ));

    if (response.statusCode == 200) {
      setState(() {
        stler.clear();
        stler = json.decode(response.body);
        print(stler.toString());
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
                  i <= stler.length - 1;
                  i++) // Original card + 15 new cards
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                            st_adi: stler[i]['st_adi'],
                            hacim: stler[i]['hacim'],
                            epdkSektoru: stler[i]['epdk_sektoru'],
                            istasyon_adi: stler[i]['istasyon']['istasyon_adi']),
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
                          //"Teslim Noktası:${stler[i]['st_adi']}",
                          "Serbest Tüketici Adı:Ankara Eğitim Okulları",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          //"EPDK Sektörü:${(stler[i]['epdk_sektoru'])}",
                          "EPDK Sektörü:Eğitim",
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
  var st_adi;
  var hacim;
  var istasyon_adi;
  var epdkSektoru;

  DetailPage({
    required this.st_adi,
    required this.hacim,
    required this.istasyon_adi,
    required this.epdkSektoru,
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
              'Serbest Tüketici Adı:',
              style: TextStyle(fontSize: 28),
            ),
            subtitle: Text(
              '$st_adi',
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
          height: 2, // Çizgi yüksekliği
          color: CupertinoColors.systemGrey4, // Çizgi rengi
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 60,
          child: CupertinoListTile(
            title: Text(
              'Hacim:',
              style: TextStyle(fontSize: 28),
            ),
            subtitle: Text(
              '$hacim',
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
          height: 2, // Çizgi yüksekliği
          color: CupertinoColors.systemGrey4, // Çizgi rengi
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 60,
          child: CupertinoListTile(
            title: Text(
              'İstasyon Adı:',
              style: TextStyle(fontSize: 28),
            ),
            subtitle: Text(
              '$istasyon_adi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 2, // Çizgi yüksekliği
          color: CupertinoColors.systemGrey4, // Çizgi rengi
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 60,
          child: CupertinoListTile(
            title: Text(
              'EPDK Sektörü:',
              style: TextStyle(fontSize: 28),
            ),
            subtitle: Text(
              '$epdkSektoru',
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
