import 'package:flutter/cupertino.dart';

final String tableMana = 'mana';
final String columnId = '_id';
final String columnDate = 'date';
final String columnStartMana = 'start_mana';
final String columnCurrentMana = 'current_mana';

class Mana {
  int id;
  DateTime date;
  int startMana;
  int currentMana;

  Mana();

  // convenience constructor to create a Mana object
  Mana.fromMap(Map<String, dynamic> map){
    id = map[columnId];
    date = DateTime.fromMillisecondsSinceEpoch(map[columnDate]);
    startMana = map[columnStartMana];
    currentMana = map[columnCurrentMana];
  }

    // convenience method to create a Map from this Mana object
    Map<String, dynamic> toMap(){
      var map = <String, dynamic>{
        columnDate: date.millisecondsSinceEpoch,
        columnStartMana: startMana,
        columnCurrentMana: currentMana
      };
      if(id != null){
        map[columnId] = id;
      }
      return map;
    }
}

