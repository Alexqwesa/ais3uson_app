import 'dart:math';
import 'dart:ui';

import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DeleteDepartmentScreen extends StatelessWidget {
  const DeleteDepartmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workerKeys = AppData().workerKeys.toList();

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
      body: workerKeys.isNotEmpty
          ? ListView.builder(
              itemCount: workerKeys.length,
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
                  title: Text(workerKeys[index].otd),
                  trailing: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () async {
                    final result = await _showMyDialog(context, index);
                    if (result == 'delete') {
                      // if (!mounted) return;
                      AppData().profiles.removeAt(index);
                      AppData().notifyListeners();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, 'delete');
                    }
                  },
                  subtitle: Text(workerKeys[index].name),
                );
              },
            )
          : const Center(
              child: Text('Список отделений пуст! '),
            ),
    );
  }
}

Future<String?> _showMyDialog(BuildContext context, int index) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        title: const Text('Удаление отделения'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Text('Вы уверены что хотите удалить отделение: '),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppData().profiles[index].key.otd,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: const Text(
              'Удалить',
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
