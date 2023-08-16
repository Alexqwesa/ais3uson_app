// ignore_for_file: always_use_package_imports

import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/ui_departments.dart';
import 'package:ais3uson_app/ui_root.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:toggle_switch/toggle_switch.dart';

/// Show screen with main menu and with list of [WorkerProfile].
///
/// {@category UI WorkerProfiles}
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      //
      // > appBar
      //
      appBar: AppBar(
        title: Text(tr().depList),
      ),
      //
      // > body
      //
      body: const ListOfDepartments(),
      //
      // > scan qr button
      //
      floatingActionButton: ref.watch(isArchive)
          ? null
          : FloatingActionButton(
              onPressed: () {
                context.push('/scan_qr');
              },
              tooltip: tr().scanQrCode,
              child: const Icon(Icons.add),
            ),
      //
      // > drawer
      //
      drawer: ref.watch(isArchive)
          ? null
          : Drawer(
              child: ListView(
                controller: ScrollController(),
                children: [
                  //
                  // > logo
                  //
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 4,
                        ),
                        child: SizedBox.square(
                          child: Image.asset('assets/ais-3uson-logo.png'),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      tr().shortAboutApp,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //
                  // > menu list
                  //
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.group_add),
                    title: Text(
                      tr().addDepFromText,
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        'qr',
                      );
                      context.push('/add_department');
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    title: Text(tr().scanQrCode),
                    onTap: () {
                      Navigator.pop(context, 'qr');
                      context.push('/scan_qr');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: Text(tr().deleteDep),
                    onTap: () {
                      Navigator.pop(context, 'delete_department');
                      context.push('/delete_department');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.archive),
                    title: Text(tr().archive),
                    onTap: () {
                      Navigator.pop(context, 'archive');
                      if (ref.read(archiveDate) == null) {
                        ref.read(isArchive.notifier).state = true;
                        context.push('/archive');
                        ArchiveMaterialApp.setArchiveOnWithDatePicker(
                          context,
                          ref,
                        );
                      } else {
                        ref.read(isArchive.notifier).state = false;
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text(tr().settings),
                    onTap: () {
                      Navigator.pop(context, 'settings');
                      context.push('/settings');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.adb),
                    title: Text(tr().about),
                    onTap: () {
                      Navigator.pop(context, 'dev');
                      context.push('/dev');
                    },
                  ),
                  const Divider(),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          tr().theme,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      ToggleSwitch(
                        minWidth: 145,
                        minHeight: 34,
                        cornerRadius: 83,
                        activeBgColors: [
                          [Theme.of(context).primaryColor],
                          [Theme.of(context).primaryColor],
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: const Color(0xffECEFF1),
                        inactiveFgColor: Colors.black,
                        initialLabelIndex: [ThemeMode.light, ThemeMode.dark]
                            .indexOf(ref.watch(standardTheme)),
                        totalSwitches: 2,
                        labels: [tr().light, tr().dark],
                        radiusStyle: true,
                        onToggle: (index) {
                          ref.read(standardTheme.notifier).state = [
                            ThemeMode.light,
                            ThemeMode.dark,
                          ].elementAt(index ?? 0);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
