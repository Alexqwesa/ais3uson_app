import 'dart:convert';
import 'dart:math';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/client_server_api/worker_key.dart';
import 'package:ais3uson_app/source/data_models/worker_profile.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/providers/controller_of_worker_profiles_list.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Show screen where user can add [WorkerProfile] from text string.
///
/// Used in case of devices without camera...
/// Also used to add test department.
///
/// {@category UI WorkerProfiles}
class AddDepartmentScreen extends ConsumerWidget {
  const AddDepartmentScreen({Key? key}) : super(key: key);

  static final controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var columnWidth = MediaQuery.of(context).size.width;
    columnWidth = MediaQuery.of(context).size.width <
            1 * MediaQuery.of(context).size.height
        ? columnWidth
        : columnWidth / 2;
    final newWorkerKeys =
        mapJsonDecode(qrCodes).map(WorkerKey.fromJson).toList(growable: false);

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
                            padding: const EdgeInsets.all(8),
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
                                  onPressed: controller.clear,
                                  child: Text(S.of(context).clear),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  child: Text(S.of(context).addDep),
                                  //
                                  // > add Dep
                                  //
                                  onPressed: () {
                                    Navigator.pop(context, 'added');
                                    addNewWProfile(
                                      context,
                                      ref,
                                      controller.value.text
                                          .replaceAll('\n', ''),
                                    );
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
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        S.of(context).orTestDepList,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  //
                  // > list of test department
                  //
                  SizedBox(
                    width: 650,
                    child: ListView.builder(
                      itemCount: newWorkerKeys.length,
                      shrinkWrap: true,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(2),
                          child: Card(
                            child: ListTile(
                              leading: Transform.rotate(
                                angle: pi / 30,
                                child: const Icon(
                                  Icons.group,
                                  // color: Colors.green,
                                ),
                              ),
                              title: Text(newWorkerKeys[index].dep),
                              trailing: const Icon(
                                Icons.add,
                                color: Colors.green,
                              ),
                              subtitle: Text(newWorkerKeys[index].name),
                              //
                              // > add Dep
                              //
                              onTap: () {
                                Navigator.pop(context, 'added');
                                addNewWProfile(
                                  context,
                                  ref,
                                  qrCodes[index],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
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

bool addNewWProfile(BuildContext context, WidgetRef ref, String text) {
  try {
    final res = ref.read(workerProfiles.notifier).addProfileFromKey(
          WorkerKey.fromJson(
            jsonDecode(text) as Map<String, dynamic>,
          ),
        );
    if (!res) {
      showErrorNotification(
        locator<S>().cantAddDepDuplicate,
      );
      FocusScope.of(context).requestFocus(
        FocusNode(),
      );

      return true;
    }
  } on FormatException {
    showErrorNotification(
      locator<S>().cantAddDepBadFormat,
    );
    FocusScope.of(context).requestFocus(
      FocusNode(),
    );
  }

  return false;
}

class SimpleTextField extends StatelessWidget {
  const SimpleTextField({required this.controller, Key? key}) : super(key: key);

  final TextEditingController controller;

  // final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
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
