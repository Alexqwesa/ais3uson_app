import 'dart:convert';
import 'dart:math';

import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Show screen where user can add [WorkerProfile] from text string.
///
/// Used in case of devices without camera...
/// Also used to add test department.
///
/// {@category UI WorkerProfiles}
class AddDepartmentScreen extends ConsumerWidget {
  const AddDepartmentScreen({super.key});

  static final controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final columnWidth =
        (size.width < size.height * 1) ? size.width : size.width / 2;
    final newWorkerKeys =
        mapJsonDecode(qrCodes).map(WorkerKey.fromJson).toList(growable: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(tr().putDepText),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              context.push('/');
              // Navigator.pop(context, 'canceled');
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
                              tr().putDepTextField,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
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
                                  child: Text(tr().clear),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  child: Text(tr().addDep),
                                  //
                                  // > add Dep
                                  //
                                  onPressed: () {
                                    // Navigator.pop(context, 'added');
                                    addNewWProfile(
                                      context,
                                      ref,
                                      controller.value.text
                                          .replaceAll('\n', ''),
                                    );
                                    context.push('/');
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
                        tr().orTestDepList,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
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
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(newWorkerKeys[index].name),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(newWorkerKeys[index].comment),
                                  ),
                                ],
                              ),

                              //
                              // > add Dep
                              //
                              onTap: () {
                                // Navigator.pop(context, 'added');
                                addNewWProfile(
                                  context,
                                  ref,
                                  qrCodes[index],
                                );
                                context.push('/');
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
    final res = ref.read(departmentsProvider.notifier).addProfileFromKey(
          WorkerKey.fromJson(
            jsonDecode(text) as Map<String, dynamic>,
          ),
        );
    if (!res) {
      showErrorNotification(
        tr().cantAddDepDuplicate,
      );
      FocusScope.of(context).requestFocus(
        FocusNode(),
      );

      return true;
    }
  } on FormatException {
    showErrorNotification(
      tr().cantAddDepBadFormat,
    );
    FocusScope.of(context).requestFocus(
      FocusNode(),
    );
  }

  return false;
}

class SimpleTextField extends StatelessWidget {
  const SimpleTextField({required this.controller, super.key});

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
          hintText: tr().putDepTextFieldHint,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
