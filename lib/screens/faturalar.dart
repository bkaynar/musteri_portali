import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Faturalar extends StatefulWidget {
  final int musteriId;

  const Faturalar({required this.musteriId, Key? key}) : super(key: key);

  @override
  State<Faturalar> createState() => _FaturalarState();
}

class _FaturalarState extends State<Faturalar> {
  List<dynamic> faturalar = [];

  Future<void> veriCek() async {
    final response = await http.get(Uri.parse(
      'http://10.0.2.2:8080/fatura/getMusteriFaturalar/${widget.musteriId}',
    ));

    if (response.statusCode == 200) {
      setState(() {
        faturalar = json.decode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    veriCek();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('BOTAŞ'),
            Visibility(
              visible: true,
              child: Text(
                'Müşteri Portalı -> Faturalarım',
                style: TextStyle(fontSize: 10, letterSpacing: 1),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 210, 20, 26),
      ),
      body: ListView.builder(
        itemCount: faturalar.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FaturaDetay(
                    faturaDetay: faturalar[index],
                  ),
                ),
              );
            },
            child: ListTile(
              title: Text('Fatura Numarası: ${faturalar[index]['id']}'),
              subtitle: Text('Fatura Tutarı: ' +
                  faturalar[index]['tutar'].toString() +
                  '₺'),
            ),
          );
        },
      ),
    );
  }
}

class FaturaDetay extends StatelessWidget {
  final Map<String, dynamic> faturaDetay;

  const FaturaDetay({required this.faturaDetay, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('BOTAŞ'),
              Visibility(
                visible: true,
                child: Text(
                  'Müşteri Portalı -> Fatura Detayı',
                  style: TextStyle(fontSize: 10, letterSpacing: 1),
                ),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 210, 20, 26),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
              height: 60,
              child: CupertinoListTile(
                title: Text(
                  'Yıl:${faturaDetay['yil']}',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
            Container(
              height: 60,
              child: CupertinoListTile(
                title: Text(
                  'Ay:${faturaDetay['ay']}',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
            Container(
              height: 60,
              child: CupertinoListTile(
                title: Text(
                  'Tutar:${faturaDetay['tutar']}',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
            Container(
              height: 60,
              child: CupertinoListTile(
                title: Text(
                  'Tüketim Miktarı:${faturaDetay['tuketimMiktari']} sm3',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
            Container(
              height: 60,
              child: CupertinoListTile(
                title: Text(
                  'KDV Oranı:${faturaDetay['kdv']}',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
            Container(
              height: 60,
              child: CupertinoListTile(
                title: Text(
                  'ÖTV Oranı:${faturaDetay['otv']}',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
          ],
        ));
  }
}
