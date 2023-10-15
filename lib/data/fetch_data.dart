//pokupi podatke, znaš šta znači fetch valjda

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:kontrola_vazduha_app/data/air_qual.dart';
import 'package:kontrola_vazduha_app/data/api_key.dart';

//stavio nazive na eng jer sam bukv iskopirao iz dokumnentacije neke stvari

Future<AirQuality?> fetchData() async {
  try {
    bool serviceEnabled; //da li je uključena usluga lokacije
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Usluga lokacije je uključena ne nastavljaj
      // pozicija i zahtev da se uključi lokacija

      return Future.error('Lokacija isključena.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Odbijen zahtev, moš ponovo da proba

        return Future.error('Lokacija odbiVena');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      //Trajno odbijeno
      return Future.error(' Dozvola za lokaciju trajno odbijena');
    }
    //ako smo došli ovde, odobrena je lokacija
    //async await ću objasniti posebno u drugom projektu
    Position position = await Geolocator.getCurrentPosition();

    //  http

    //pogledaj dokumentaciju na aqu, izvlači poziciju i api ključ
    var url = Uri.parse(
        'https://api.waqi.info/feed/geo:${position.latitude};${position.longitude}/?token=$API_KEY');
    var response = await http.get(url);

    //odgovor od servera->pogledaj chatgpt
    if (response.statusCode == 200) {
      AirQuality airQuality = AirQuality.fromJson(jsonDecode(response.body));
      if (airQuality.aqi >= 0 && airQuality.aqi <= 50) {
        //u zavisnosti od aqu odgovarajuća poruka i emoji
        airQuality.poruka = "Kvalitet vazduha zadovoljavajući, svakaačas	";
        airQuality.emojiRef = "1.png";
      } else if (airQuality.aqi >= 51 && airQuality.aqi <= 100) {
        airQuality.poruka =
            "Kvalitet vazduha prihvatljiv, posebno osetljive grupe mogu imati blage simptome.";
        airQuality.emojiRef = "2.png";
      } else if (airQuality.aqi >= 101 && airQuality.aqi <= 150) {
        airQuality.poruka =
            "Osetljive grupe mogu imati jasne simptome, zdravo stanovništvo ne.";
        airQuality.emojiRef = "3.png";
      } else if (airQuality.aqi >= 151 && airQuality.aqi <= 200) {
        airQuality.poruka =
            "Svi mogu osetiti simptome, osetljive grupe da se ne izlažu";
        airQuality.emojiRef = "4.png";
      } else if (airQuality.aqi >= 201 && airQuality.aqi < 300) {
        airQuality.poruka = "Zdravstveno upotorenje.";
        airQuality.emojiRef = "5.png";
      } else if (airQuality.aqi >= 300) {
        airQuality.poruka = "ALARM!SVI MOGU OSETITI JAKE SIMPTOME";
        airQuality.emojiRef = "6.png";
      }

      print(airQuality);
      return airQuality;
    }
    return null;
    //za hvatanje greške dart.developer paket
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}
