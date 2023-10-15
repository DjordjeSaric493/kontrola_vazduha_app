import 'package:flutter/material.dart';
import 'package:kontrola_vazduha_app/home_screen.dart';
import 'package:kontrola_vazduha_app/data/fetch_data.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //da li će pokazati ono debug u gornjem desnom uglu
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          //future je lepo objašnjen pređi kursorom preko da bi videli kratko objašnjeno
          //nema veze sa Future reperom već je ovo asinhrona operacija
          // imate onu knjigu flutter + dart apprentice ako vam treba
          future: fetchData(),
          builder: (context, snap) {
            if (snap.hasData) {
              //ako ima podatak->home screen
              return HomeScreen(snap.data!);
            } else {
              //u suprotnom nek vrti krug
              return const Scaffold(
                body: Center(
                  //na početku vrti ovaj krug
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }
}
