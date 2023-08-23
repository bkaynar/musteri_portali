// To parse this JSON data, do
//
//     final istasyonResponse = istasyonResponseFromJson(jsonString);

import 'dart:convert';

List<IstasyonResponse> istasyonResponseFromJson(String str) => List<IstasyonResponse>.from(json.decode(str).map((x) => IstasyonResponse.fromJson(x)));

String istasyonResponseToJson(List<IstasyonResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IstasyonResponse {
    String istasyonAdi;
    Musteri musteri;
    int id;

    IstasyonResponse({
        required this.istasyonAdi,
        required this.musteri,
        required this.id,
    });

    factory IstasyonResponse.fromJson(Map<String, dynamic> json) => IstasyonResponse(
        istasyonAdi: json["istasyon_adi"],
        musteri: Musteri.fromJson(json["musteri"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "istasyon_adi": istasyonAdi,
        "musteri": musteri.toJson(),
        "id": id,
    };
}

class Musteri {
    int id;
    String musteriKod;
    String musteriAdi;
    String adres;
    String il;
    String ilce;
    String telefon;
    bool aktif;

    Musteri({
        required this.id,
        required this.musteriKod,
        required this.musteriAdi,
        required this.adres,
        required this.il,
        required this.ilce,
        required this.telefon,
        required this.aktif,
    });

    factory Musteri.fromJson(Map<String, dynamic> json) => Musteri(
        id: json["id"],
        musteriKod: json["musteriKod"],
        musteriAdi: json["musteriAdi"],
        adres: json["adres"],
        il: json["il"],
        ilce: json["ilce"],
        telefon: json["telefon"],
        aktif: json["aktif"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "musteriKod": musteriKod,
        "musteriAdi": musteriAdi,
        "adres": adres,
        "il": il,
        "ilce": ilce,
        "telefon": telefon,
        "aktif": aktif,
    };
}
