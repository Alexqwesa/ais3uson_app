import 'dart:math';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Show screen where user can delete [Worker].
///
/// {@category UI Workers}
class DeleteDepartmentScreen extends ConsumerWidget {
  const DeleteDepartmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wpKeys = ref.watch(workerKeysProvider).keys;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr().selectDepForDelete),
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
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 650,
          child: wpKeys.isNotEmpty
              ? ListView.builder(
                  itemCount: wpKeys.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Transform.rotate(
                          angle: pi / 30,
                          child: const Icon(
                            Icons.group,
                            // color: Colors.red,
                          ),
                        ),
                        title: Text(wpKeys[index].dep),
                        trailing: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(wpKeys[index].name),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(wpKeys[index].comment),
                            ),
                          ],
                        ),
                        //
                        // > call dialog
                        //
                        onTap: () async {
                          final result = await _showDialog(
                            context,
                            wpKeys[index].dep,
                          );
                          if (result == 'delete') {
                            if (await ref
                                .read(workerKeysProvider)
                                .delete(wpKeys[index])) {
                              if (context.mounted) {
                                Navigator.pop(context, 'delete');
                              }
                            }
                          }
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(tr().emptyDepList),
                ),
        ),
      ),
    );
  }
}

/// _showDialog
///
/// just simple dialog window,
/// with delete/cancel buttons
Future<String?> _showDialog(BuildContext context, String depName) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        title: Text(tr().deleteDep),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(tr().areYouSureToDelete),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  depName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              MaterialLocalizations.of(context).deleteButtonTooltip,
            ),
            onPressed: () {
              Navigator.of(context).pop('delete');
            },
          ),
          TextButton(
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            onPressed: () {
              Navigator.of(context).pop('cancel');
            },
          ),
        ],
      );
    },
  );
}
