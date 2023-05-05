import 'dart:developer';

import 'package:database/dbHelper/constrain.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Mangodatabase {
  static var db, user_coll;
  static connect() async {
    db = await Db.create(MONGO_CON_URL);
    await db.open();
    inspect(db);
    user_coll = db.collection(USER_COLL);
  }
}
