final String tableEvent = 'event';
final String columnId = "_id";
final String columnManaId = 'mana_id';
final String columnAmount = 'amount';
final String columnDescription = 'description';

class Event {

  int id;
  int manaId;
  int amount;
  String description;

  Event();

  // convenience constructor to create a Mana object
  Event.fromMap(Map<String, dynamic> map){
    id = map[columnId];
    manaId = map[columnManaId];
    amount = map[columnAmount];
    description = map[columnDescription];
  }

  // convenience method to create a Map from this Mana object
  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      columnManaId: manaId,
      columnAmount: amount,
      columnDescription: description
    };
    if(id != null){
      map[columnId] = id;
    }
    return map;
  }
}