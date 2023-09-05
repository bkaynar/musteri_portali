import 'package:flutter/material.dart';
import 'package:musteri_portali/screens/dashboard.dart';
import 'forgot_password.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:musteri_portali/core/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _kullaniciAdi = TextEditingController();
  final TextEditingController _sifre = TextEditingController();
  bool _isPasswordVisible =
      false; // Şifre görünürlüğünü kontrol etmek için değişken
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //resim gelecek
              Image.asset(
                'assets/logo.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 30),
              const Text(
                'MÜŞTERİ PORTALI',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    fontFamily: 'poppins'),
              ),
              const SizedBox(height: 10),
              const Text(
                'MOBİL UYGULAMASI',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontFamily: 'poppins'),
              ),
              const SizedBox(height: 30),
              //Kullanıcı Adı Bölümü

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: _kullaniciAdi,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Kullanıcı Adı',
                      ),
                    ),
                  ),
                ),
              ),
              //Şifre Bölümü
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      controller: _sifre,
                      obscureText:
                          !_isPasswordVisible, // Şifre gizleme/gösterme özelliği
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Şifre',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ), //Giriş Butonu
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: InkWell(
                  onTap: _login,
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Colors.red[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Giriş Yap',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    var url = Uri.http(baseurl, '/kullanici/giris');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "kullaniciAdi": _kullaniciAdi.text,
        "kullaniciSifre": _sifre.text,
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      musteriId = responseData['musteri']['id'];
      musteriAdi = responseData['musteri']['musteriAdi'];
      kullaniciMail = responseData['kullaniciMail'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('musteriId', musteriId);
      await prefs.setString('musteriAdi', musteriAdi);
      await prefs.setString('kullaniciMail', kullaniciMail);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Giriş Yapılamadı'),
            content: const Text('Kullanıcı Adı veya Şifre Yanlış.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
    }
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPassword()),
    );
  }
}
