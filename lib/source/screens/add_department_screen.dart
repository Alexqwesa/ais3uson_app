import 'dart:convert';
import 'dart:math';

import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:flutter/material.dart';

/// Show screen where user can add [WorkerProfile] from text string.
///
/// Used in case of devices without camera...
/// Also used to add test department.
///
/// {@category WorkerProfiles}
class AddDepartmentScreen extends StatelessWidget {
  final controller = TextEditingController();

  AddDepartmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var columnWidth = MediaQuery.of(context).size.width;
    columnWidth = MediaQuery.of(context).size.width <
            1 * MediaQuery.of(context).size.height
        ? columnWidth
        : columnWidth / 2;
    final workerKeys = qrCodes
        .map((e) => WorkerKey.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(S.of(context).putDepText),
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
      body: Wrap(
        children: [
          SizedBox(
            width: columnWidth,
            child: SizedBox(
              height: 280,
              width: 350,
              child: Column(
                children: <Widget>[
                  //
                  // > returned text
                  //
                  SizedBox(
                    height: 280,
                    child: Card(
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              S.of(context).putDepTextField,
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
                                  child: Text(S.of(context).clear),
                                  onPressed: controller.clear,
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  child: Text(S.of(context).addDep),
                                  onPressed: () async {
                                    try {
                                      Navigator.pop(context, 'added');
                                      final res =
                                          await locator<AppData>().addProfileFromKey(
                                        WorkerKey.fromJson(
                                          jsonDecode(
                                            controller.value.text
                                                .replaceAll('\n', ''),
                                          ) as Map<String, dynamic>,
                                        ),
                                      );
                                      if (res) {
                                        await locator<AppData>().save();
                                      } else {
                                        showErrorNotification(
                                          locator<S>().cantAddDepDuplicate,
                                        );
                                        // ignore: use_build_context_synchronously
                                        FocusScope.of(context).requestFocus(
                                          FocusNode(),
                                        );
                                      }
                                    } on FormatException {
                                      showErrorNotification(
                                        locator<S>().cantAddDepBadFormat,
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
                ],
              ),
            ),
          ),
          SizedBox(
            width: columnWidth,
            child: SizedBox(
              width: 350,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        S.of(context).orTestDepList,
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
                              Navigator.pop(context, 'added');
                              final res = await locator<AppData>()
                                  .addProfileFromKey(workerKeys[index]);
                              if (res) {
                                await locator<AppData>().save();
                              } else {
                                showErrorNotification(
                                  locator<S>().cantAddDepDuplicate,
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
        ],
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        // focusNode: focusNode,
        autofocus: true,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        cursorColor: Colors.teal,
        decoration: InputDecoration(
          hintText: S.of(context).putDepTextFieldHint,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
