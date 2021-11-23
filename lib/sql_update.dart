// import 'dart:async';

// // import 'package:flutter/widgets.dart';
// import 'package:mysql1/mysql1.dart';
//
// var host = '80.87.196.11';
// var port = 3306;
// var user = 'info3';
// var password = 'sqlinfo';
// var db = 'kcson_tmp';
//
// Future call_db1(Function(String) ret_func) async {
//   // Open a connection (testdb should already exist)
//
//   var ret = "NOne";
//   try {
//     final connection = await MySqlConnection.connect(new ConnectionSettings(
//         host: host, port: port, user: user, password: password, db: db));
//     var results = await connection.query('select test,id from test');
//     for (var row in results) {
//       ret = '${row[0]}';
//     }
//
//     // Finally, close the connection
//     await connection.close();
//   } catch (e) {
//     ret = "Error: $e";
//   }
//   ret_func(ret);
//   // return ret;
// }
//
// String call_db(Function(String) ret_func) {
//   ret_func("asdfaaaaa");
//   call_db1(ret_func);
//   return "asdf";
// }
