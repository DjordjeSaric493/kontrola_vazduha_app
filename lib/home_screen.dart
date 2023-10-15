import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kontrola_vazduha_app/indikator.dart';
import 'data/air_qual.dart';

class HomeScreen extends StatelessWidget {
  final AirQuality airQuality;
  const HomeScreen(this.airQuality, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text(
            'Indikator kvaliteta vazduha',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, //css like
                        image: AssetImage(
                            'assets/tara-pozadina-proba.jpeg' //slika pozadinska
                            ))),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 5),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black45),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight * 3),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: Size(MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.width),
                          painter: AirQualityIndikator(airQuality.aqi),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: 400,
                            height: MediaQuery.of(context).size.height * 0.40,
                            child: Column(
                              children: [
                                Container(
                                  //širina i visina kontejnera
                                  width: 400,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage(
                                          //emoji koji se menja u zavisnosti od aqi
                                          "assets/${airQuality.emojiRef}"))),
                                ),
                                Container(
                                  width: 400,
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color.fromARGB(137, 255, 255, 255),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      //u centru je odgovarajuća poruka
                                      child: Text(
                                        //poruka o kval vazduha
                                        airQuality.poruka!,
                                        textAlign: TextAlign.center, //css like
                                        style: const TextStyle(
                                            height: 1.5,
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(221, 5, 3, 158),
                                            fontWeight: FontWeight
                                                .w800 //debljina fonta kao bold itd itd
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
