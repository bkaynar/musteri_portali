import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musteri_portali/core/variables.dart';
import 'navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MiktarGirisi extends StatefulWidget {
  const MiktarGirisi({super.key});

  @override
  State<MiktarGirisi> createState() => _MiktarGirisiState();
}

class _MiktarGirisiState extends State<MiktarGirisi> {
  List<String> dropdownItems = [];
  List<Map<String, dynamic>> bildirimVeriler = [];

  int? selectedBildirim;

  final TextEditingController _miktargirisi = TextEditingController();
  DateTime? selectedDate;
  String? selectedStation;
  int? selectedIstasyonId;
  @override
  void initState() {
    super.initState();
    fetchIstasyonData();
    fetchBildirimVeriler();
  }

  Future<void> fetchBildirimVeriler() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8080/bildirim/bildirimler'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> veriler =
            List<Map<String, dynamic>>.from(data);

        setState(() {
          bildirimVeriler = veriler;
        });
      } else {
        throw Exception('API isteği başarısız oldu');
      }
    } catch (error) {
      print('Hata: $error');
    }
  }

  Future<List<Map<String, dynamic>>> fetchIstasyonData() async {
    final response = await http.get(
        Uri.parse("http://10.0.2.2:8080/istasyon/getByMusteriId/${musteriId}"));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return List<Map<String, dynamic>>.from(jsonData);
    } else {
      throw Exception('API çağrısı başarısız oldu');
    }
  }

  void _gerceklesenDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 10),
      lastDate: DateTime(2099),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Navbar(),
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('BOTAŞ'),
            Visibility(
              visible: true,
              child: Text(
                'Müşteri Portalı -> Miktar Girişi ',
                style: TextStyle(fontSize: 10.0, letterSpacing: 1),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 210, 20, 26),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              children: [
                const ListTile(
                  title: Text(
                    'Gerçekleşen Tüketim',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Tüketim miktarlarınızı görebilirsiniz',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchIstasyonData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    } else {
                      List<Map<String, dynamic>>? istasyonlar = snapshot.data;
                      return Container(
                        width: double.infinity,
                        child: DropdownButton<int>(
                          value: selectedIstasyonId,
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedIstasyonId = newValue!;
                            });
                          },
                          hint: Text('İstasyon Seçiniz'),
                          items: istasyonlar?.map<DropdownMenuItem<int>>(
                            (Map<String, dynamic> istasyon) {
                              return DropdownMenuItem<int>(
                                value: istasyon['id'],
                                child: Text(istasyon['istasyon_adi']),
                              );
                            },
                          ).toList(),
                        ),
                      );
                    }
                  },
                ),
                if (selectedIstasyonId != null)
                  Text(
                    'Seçilen Bildirim ID: $selectedIstasyonId',
                    style: TextStyle(fontSize: 16),
                  ),
                SizedBox(height: 16),
                Column(
                  children: bildirimVeriler.map((veri) {
                    return RadioListTile<int>(
                      title: Text(veri['bildirim_tipi'] as String),
                      value: veri['id'] as int,
                      groupValue: selectedBildirim,
                      onChanged: (value) {
                        setState(() {
                          selectedBildirim = value;
                        });
                      },
                    );
                  }).toList(),
                ),
                if (selectedBildirim != null)
                  Text(
                    'Seçilen Bildirim ID: $selectedBildirim',
                    style: TextStyle(fontSize: 16),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40),
                  ),
                  onPressed: () {
                    _gerceklesenDatePicker();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 8),
                      Text(
                        'Tarih Seçin',
                        style: TextStyle(fontFamily: 'poppins'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (selectedDate != null)
                  Text(
                    'Seçilen Tarih: ${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}',
                    style: TextStyle(fontSize: 16),
                  ),
                SizedBox(height: 16),
                const Text(
                  'Gerçekleşen Miktar',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _miktargirisi,
                  decoration: InputDecoration(
                    labelText: 'Gerçekleşen Miktar',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _miktarGirisi();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      minimumSize: Size(double.infinity, 40)),
                  child: const Text('Miktar Girişi Kaydet'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _miktarGirisi() async {
    double girisMiktari = double.parse(_miktargirisi.text);
    final String tarihString = selectedDate.toString();
    DateTime parsedDate = DateTime.parse(tarihString);
    String formattedTarih = DateFormat('yyyy-MM-dd').format(parsedDate);
    if (selectedDate == null ||
        selectedBildirim == -1 ||
        selectedBildirim == null ||
        _miktargirisi.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen tüm alanları doldurun.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      var url = Uri.http(baseurl, '/gerceklesen_tmb/ekle');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "miktar": girisMiktari,
          "tarih": formattedTarih.toString(),
          "musteri": {"id": musteriId},
          "istasyon": {"id": selectedIstasyonId},
          "bildirim": {"id": selectedBildirim}
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Miktar kaydedildi'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bir hata oluştu. Tekrar deneyin.1'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('Hata: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bir hata oluştu. Tekrar deneyin.2'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

void main() {
  runApp(MaterialApp(home: MiktarGirisi()));
}
