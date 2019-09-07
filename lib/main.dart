import 'package:flutter/material.dart';
import 'package:mana_app/db/database_helpers.dart';
import 'package:mana_app/db/entities/mana.dart';
import 'package:sqflite/sqflite.dart';

import 'db/entities/event.dart';

void main() => runApp(MaterialApp(
  home: Home(),
));


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: getMana(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot){
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Mana App',
              style: TextStyle(
                fontFamily: 'PermanentMarker',
                fontSize: 24,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.teal[300],

          ),
          body: Center(
            child: Text(
              'Mana left today: ' + snapshot.data.toString(),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.grey[800],
                fontFamily: 'PermanentMarker',
              ),
            ),

          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              updateMana(-1);
            // Todo reload page or figure out how to have the number change automatically on update
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Home()),
              );
            },
            child: Text('Minus'),
            backgroundColor: Colors.teal[300],
          ),
        );
      }
    );

  }
}

Future<int> getMana() async{

  DatabaseHelper helper = DatabaseHelper.instance;
  int id = 1;

  try{
    Mana mana = await helper.queryMana(id);
    int amount = mana.currentMana;
    return amount;
  }
  on DatabaseException{
    Mana newMana = new Mana();
    DateTime now = DateTime.now();
    int manaInit = 5;
    newMana.date = new DateTime(now.year, now.month, now.day);
    newMana.startMana = manaInit;
    newMana.currentMana = manaInit;

    helper.insertMana(newMana);

    return manaInit;
  }
}

void updateMana(int amount) async{
  DatabaseHelper helper = DatabaseHelper.instance;

  Mana mana = await helper.queryMana(1);

  Event event = new Event();
  event.manaId = 1;
  event.amount = amount;
  event.description = '';
  await helper.insertEvent(mana, event);
  print('done');


}


