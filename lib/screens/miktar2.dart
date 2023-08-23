import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musteri_portali/core/variables.dart';
import 'package:musteri_portali/model/istasyonResponse.dart';
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
  int? selectedStationId;

  @override
  void initState() {
    super.initState();
    //fetchDropdownItems();
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

  Future<List<IstasyonResponse>> fetchDropdownItems() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/istasyon/getByMusteriId/${musteriId}'),
    );
    return istasyonResponseFromJson(utf8.decode(response.bodyBytes));
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
        title: const Column(
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
                FutureBuilder<List<IstasyonResponse>>(
                  future: fetchDropdownItems(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<IstasyonResponse>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.data!.length > 0) {
                      return Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            border: Border.all(color: Colors.grey)),
                        child: ListTile(
                          title: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: snapshot.data?.map((item) {
                                return DropdownMenuItem(
                                  child: Text(item.istasyonAdi),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(
                                  () {
                                    selectedStationId = newVal as int;
                                  },
                                );
                              },
                              value: selectedStationId,
                              isExpanded: true,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                const SizedBox(height: 16),
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
                  child: const Row(
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
                    style: const TextStyle(fontSize: 16),
                  ),
                const SizedBox(height: 16),
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
                  decoration: const InputDecoration(
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
                      minimumSize: const Size(double.infinity, 40)),
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
        selectedStationId == -1 ||
        selectedBildirim == null ||
        _miktargirisi.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
          "istasyon": {"id": selectedStationId},
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
