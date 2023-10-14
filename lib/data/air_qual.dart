//podaci o kontroli vazduha
//ovo stavljam u zaseban folder data gde će da šteka podatke koji će nam trebati
class AirQuality {
  int aqi; //air quality index->sve jasno
  String grad;
  // aqi,grad dobijam iz api-ja, poruka i emoji mogu biti prazni, zato ?
  String? poruka;
  String? emojiRef;
  //za ova dva baci pogled na json

  AirQuality(
      {required this.aqi,
      required this.grad,

      //poruka i emoji su opcioni
      this.poruka,
      this.emojiRef});

  // šta iz json vuče za grad i za aqi
  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
      aqi: json['data']['aqi'] as int,
      grad: json['data']['city']['name'] as String,
    );
  }

  @override
  String toString() {
    return 'AirQuality(aqi: $aqi, cityName: $grad, message: $poruka, emojiRef: $emojiRef)';
  }
}
