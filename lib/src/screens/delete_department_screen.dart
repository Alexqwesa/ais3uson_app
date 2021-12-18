import 'dart:math';

import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DeleteDepartmentScreen extends StatelessWidget {
  const DeleteDepartmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userKeys = AppData().userKeys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите отделение для удаления...'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, 'canceled');
            },
            icon: const Icon(Icons.cancel),
          ),
        ],
      ),
      body: userKeys.isNotEmpty
          ? ListView.builder(
              itemCount: userKeys.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Transform.rotate(
                    angle: pi / 30,
                    child: const Icon(
                      Icons.group,
                      // color: Colors.red,
                    ),
                  ),
                  title: Text(userKeys[index].otd),
                  trailing: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () async {
                    final result = await _showMyDialog(context);
                    if (result == 'delete') {
                      // if (!mounted) return;
                      AppData().profiles.removeAt(index);
                      AppData().notifyListeners();
                      Navigator.pop(context, 'delete');
                    }
                  },
                  subtitle: Text(userKeys[index].name),
                );
              },
            )
          : const Center(
              child: Text('Список отделений пуст! '),
            ),
    );
  }
}

Future<String?> _showMyDialog(BuildContext context) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        title: const Text('Удаление отделения'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Вы уверены что хотите удалить отделение: '),
              Text(''),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Удалить',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop('delete');
            },
          ),
          TextButton(
            child: const Text('Отмена'),
            onPressed: () {
              Navigator.of(context).pop('cancel');
            },
          ),
        ],
      );
    },
  );
}
