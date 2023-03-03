import 'package:localstore/localstore.dart';

import '../constants.dart';

Future<void> WipeLocalStore() async {
  final db = Localstore.instance;
  for (var i in databaseCollections) {
    Map<String, dynamic>? values = await db.collection(i).get();

    if (values != null) {
      for (var doc in values.keys) {
        await db.collection(i).doc(doc.split("/")[2]).delete();
      }
    }
  }
}
