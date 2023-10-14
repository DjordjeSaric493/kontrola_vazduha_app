//pokupi podatke, znaš šta znači fetch valjda

import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:kontrola_vazduha_app/data/air_qual.dart';

//stavio nazive na eng jer sam bukv iskopirao iz dokumnentacije neke stvari

Future<AirQuality?> FetchData() async {
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
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}
