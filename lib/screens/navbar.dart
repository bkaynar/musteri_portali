import 'package:flutter/material.dart';
import 'package:musteri_portali/screens/faturalar.dart';
import 'package:musteri_portali/screens/miktar.dart';
import 'package:musteri_portali/screens/serbesttuketicibilidirimi.dart';
import 'package:musteri_portali/screens/tahislistesi.dart';
import 'tehislistesi.dart';
import 'login_page.dart';
import 'tmbarsiv.dart';
import 'dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musteri_portali/core/variables.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});
  static const IconData bar_chart =
      IconData(0xe0cc, fontFamily: 'MaterialIcons');
  Future<int> _getMusteriId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('musteriId') ?? 0;
  }

  Future<String> _getMusteriAdi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('musteriAdi') ?? '';
  }

  Future<String> _getKullaniciMail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('kullaniciMail') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: FutureBuilder<String>(
              future: _getMusteriAdi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    'Müşteri Adı Yükleniyor...',
                    style: TextStyle(fontSize: 18),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Hata Oluştu: ${snapshot.error}',
                    style: TextStyle(fontSize: 18),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  return Text(
                    snapshot.data!,
                    style: TextStyle(fontSize: 18),
                  );
                } else {
                  return Text(
                    'Müşteri Adı Alınamadı',
                    style: TextStyle(fontSize: 18),
                  );
                }
              },
            ),
            accountEmail: FutureBuilder<String>(
              future: _getKullaniciMail(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    'Müşteri Adı Yükleniyor...',
                    style: TextStyle(fontSize: 18),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Hata Oluştu: ${snapshot.error}',
                    style: TextStyle(fontSize: 18),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  return Text(
                    snapshot.data!,
                    style: TextStyle(fontSize: 18),
                  );
                } else {
                  return Text(
                    'Müşteri Adı Alınamadı',
                    style: TextStyle(fontSize: 18),
                  );
                }
              },
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.asset(
                    //'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                    'assets/logo.png',
                    height: 250,
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.fitWidth),
              ),
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 228, 148, 150),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(
              'Anasayfa',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Dashboard()),
              );
            },
          ),
          ExpansionTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text(
              'TMB',
              style: TextStyle(
                fontFamily: ('poppins'),
                fontSize: 18,
              ),
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.assignment_outlined),
                title: const Text('Miktar Girişi'),
                onTap: /* null */ () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MiktarGirisi()),
                  );
                },
              ),
              ListTile(
                  leading: Icon(Icons.assignment_outlined),
                  title: Text('TMB Arşivi'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TMBarsivi()),
                    );
                  }),
            ],
          ),
          //Sözleşme Navbar
          ExpansionTile(
            leading: Icon(Icons.border_color),
            title: Text(
              'Sözleşme',
              style: TextStyle(
                fontFamily: ('poppins'),
                fontSize: 18,
              ),
            ),
            children: [
              ListTile(
                leading: Icon(Icons.border_color),
                title: Text('Tehis Listesi'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TehisListesi()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.border_color),
                title: Text('Tahis Listesi'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TahisListesi()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.border_color),
                title: Text('Serbest Tüketici Bildirimi'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SerbestTuketiciBildirimi()),
                  );
                },
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.newspaper),
            title: Text(
              'Fatura',
              style: TextStyle(
                fontFamily: ('poppins'),
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Faturalar(
                          musteriId: musteriId,
                        )),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Çıkış',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
