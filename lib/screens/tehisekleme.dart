import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:musteri_portali/core/variables.dart';
import 'package:musteri_portali/screens/tehislistesi.dart';

void main() {
  runApp(const TehisEkleme());
}

class TehisEkleme extends StatelessWidget {
  const TehisEkleme({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: true,
      home: TehisEklemeAlani(),
    );
  }
}

class TehisEklemeAlani extends StatefulWidget {
  const TehisEklemeAlani({super.key});

  @override
  State<TehisEklemeAlani> createState() => _TehisEklemeAlaniState();
}

class _TehisEklemeAlaniState extends State<TehisEklemeAlani> {
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tehis Kayıt Edildi"),
          content: Text("Tehis başarıyla kaydedildi."),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Tamam"),
            ),
          ],
        );
      },
    );
  }

  DateTime? baslangicTarihi;
  DateTime? bitisTarihi;
  DateTime? imzaTarihi;
  int? selectedSerbestTuketiciId;
  String? selectedSerbestTuketici;

  @override
  void initState() {
    super.initState();
    fetchSerbestTuketiciData();
  }

  Future<List<Map<String, dynamic>>> fetchSerbestTuketiciData() async {
    final response = await http.get(Uri.parse(
        "http://10.0.2.2:8080/serbesttuketici/getByMusteriId/${musteriId}"));

    if (response.statusCode == 200) {
      final jsonData = utf8
          .decode(response.bodyBytes); // UTF-8 kodlamasını kullanarak çözümle
      final decodedData = json.decode(jsonData);
      return List<Map<String, dynamic>>.from(decodedData);
    } else {
      throw Exception('API çağrısı başarısız oldu');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TehisListesi()),
            );
          },
          color: Color.fromARGB(255, 10, 10, 10),
        ),
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
                'Müşteri Portalı -> Tehis Sözleşmesi Ekle',
                style: TextStyle(fontSize: 10.0, letterSpacing: 1),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 210, 20, 26),
      ),
      body: Column(
        children: [
          DateTimePicker(
            title: 'Başlangıç Tarihi',
            field: 'Baslangic',
            selectedDate: baslangicTarihi,
            onSelectDate: (date) {
              setState(() {
                baslangicTarihi = date;
              });
            },
          ),
          DateTimePicker(
            title: 'Bitiş Tarihi',
            field: 'Bitis',
            selectedDate: bitisTarihi,
            onSelectDate: (date) {
              setState(() {
                bitisTarihi = date;
              });
            },
          ),
          DateTimePicker(
            title: 'İmza Tarihi',
            field: 'Imza',
            selectedDate: imzaTarihi,
            onSelectDate: (date) {
              setState(() {
                imzaTarihi = date;
              });
            },
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchSerbestTuketiciData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Hata: ${snapshot.error}');
              } else {
                List<Map<String, dynamic>>? serbesttuketiciler = snapshot.data;
                return Container(
                  width: double.infinity,
                  child: DropdownButton<int>(
                    value: selectedSerbestTuketiciId,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedSerbestTuketiciId = newValue!;
                      });
                    },
                    hint: Text('Serbest Tüketici Seçiniz'),
                    items: serbesttuketiciler?.map<DropdownMenuItem<int>>(
                      (Map<String, dynamic> istasyon) {
                        return DropdownMenuItem<int>(
                          value: istasyon['id'],
                          child: Text(istasyon['st_adi']),
                        );
                      },
                    ).toList(),
                  ),
                );
              }
            },
          ),
          ElevatedButton(
            onPressed: () {
              _tehisGirisi();
            },
            child: Text('Sözleşme Ekle'),
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 210, 20, 26),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _tehisGirisi() async {
    // Kullanıcının seçtiği tarihleri ve veriyi al
    String baslangicTarihiStr = baslangicTarihi!.toIso8601String();
    String bitisTarihiStr = bitisTarihi!.toIso8601String();
    String imzaTarihiStr = imzaTarihi!.toIso8601String();

    // Kullanıcının seçtiği Serbest Tüketici ID'sini al
    int selectedTuketiciId = selectedSerbestTuketiciId!;

    // API'ye gönderilecek veriyi hazırla
    Map<String, dynamic> veri = {
      "imza_tarihi": imzaTarihiStr,
      "baslangic_tarihi": baslangicTarihiStr,
      "bitis_tarihi": bitisTarihiStr,
      "serbestTuketici": {
        "id": selectedTuketiciId,
      },
      "musteri": {
        "id": musteriId, // musteriId değişkenini buradan alın
      },
    };

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8080/tehis/ekle"),
        body: json.encode(veri),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // Başarı durumu
        print("Veri başarıyla kaydedildi.");
        _showSuccessDialog();
        // Başarı mesajı veya kullanıcı geri bildirimini gösterme
      } else {
        // Hata durumu
        print("Hata kodu: ${response.statusCode}");
        print(response.body);
        // Hata mesajını veya kullanıcı geri bildirimini gösterme
      }
    } catch (e) {
      // Hata yakalama
      print("Hata oluştu: $e");
      // Hata mesajını veya kullanıcı geri bildirimini gösterme
    }
  }
}

class DateTimePicker extends StatefulWidget {
  final String title;
  final String field;
  final DateTime? selectedDate;
  final Function(DateTime)? onSelectDate;

  const DateTimePicker({
    Key? key,
    required this.title,
    required this.field,
    required this.selectedDate,
    required this.onSelectDate,
  }) : super(key: key);

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null) {
      widget.onSelectDate?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.selectedDate?.toLocal()}".split(' ')[0],
                  ),
                  Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
