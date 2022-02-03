import 'dart:convert';
import 'dart:math';

import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:surf_lint_rules/surf_lint_rules.dart';

/// Add department from text string.
///
/// Used in case of devices without camera...
/// Also used to add test department.
class AddDepartmentScreen extends StatelessWidget {
  final controller = TextEditingController();

  AddDepartmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workerKeys =
        qrCodes.map((e) => WorkerKey.fromJson(jsonDecode(e))).toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Вставте код отделение в виде текста...'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, 'canceled');
            },
            icon: const Icon(Icons.cancel),
          ),
        ],
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 3 / 5,
          child: FittedBox(
            child: SizedBox(
              height: 700,
              width: 350,
              child: Column(
                children: <Widget>[
                  //
                  // > returned text
                  //
                  SizedBox(
                    height: 280,
                    child: Expanded(
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ' Вставте текст-ключ отделения в это поле: ',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6,
                                softWrap: true,
                              ),
                            ),
                            SizedBox(
                              // height: screenHeight,
                              child: SimpleTextField(
                                controller: controller,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                              child: Row(
                                children: [
                                  TextButton(
                                    child: const Text(
                                      'Очистить',
                                    ),
                                    onPressed: controller.clear,
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    child: const Text(
                                      'Добавить отделение',
                                    ),
                                    onPressed: () async {
                                      try {
                                        final res =
                                            await AppData().addProfileFromKey(
                                          WorkerKey.fromJson(
                                            jsonDecode(
                                              controller.value.text
                                                  .replaceAll('\n', ''),
                                            ),
                                          ),
                                        );
                                        if (res) {
                                          unawaited(AppData().save());
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context, 'added');
                                        } else {
                                          showErrorNotification(
                                            'Не удалось добавить отделение. Возможно оно уже есть в списке. ',
                                          );
                                          // ignore: use_build_context_synchronously
                                          FocusScope.of(context).requestFocus(
                                            FocusNode(),
                                          );
                                        }
                                      } on FormatException {
                                        showErrorNotification(
                                          'Не удалось добавить отделение. Возможно неправильный формат строки.',
                                        );
                                        // ignore: use_build_context_synchronously
                                        FocusScope.of(context).requestFocus(
                                          FocusNode(),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Либо добавьте тестовое отделение из списка ниже:',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),

                  ListView.builder(
                    itemCount: workerKeys.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Card(
                          child: ListTile(
                            leading: Transform.rotate(
                              angle: pi / 30,
                              child: const Icon(
                                Icons.group,
                                // color: Colors.green,
                              ),
                            ),
                            title: Text(workerKeys[index].dep),
                            trailing: const Icon(
                              Icons.add,
                              color: Colors.green,
                            ),
                            subtitle: Text(workerKeys[index].name),
                            //
                            // > call dialog
                            //
                            onTap: () async {
                              final res = await AppData()
                                  .addProfileFromKey(workerKeys[index]);
                              if (res) {
                                unawaited(AppData().save());
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context, 'added');
                              } else {
                                showErrorNotification(
                                  'Не удалось добавить отделение. Возможно оно уже есть в списке.',
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleTextField extends StatelessWidget {
  final TextEditingController controller;

  const SimpleTextField({required this.controller, Key? key}) : super(key: key);

  // final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          // focusNode: focusNode,
          autofocus: true,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          cursorColor: Colors.teal,
          decoration: const InputDecoration(
            hintText:
                'Вставьте текст qr-кода отделения здесь, это резервный способ '
                'добавления отделения, например для тех у кого не работает камера на телефоне...'
                ' \n рекомендуемый способ - сканировать QR код!',
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ),
    );
  }
}
