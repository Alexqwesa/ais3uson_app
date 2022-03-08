// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("Uber App"),
        "add": MessageLookupByLibrary.simpleMessage("Addieren!"),
        "addDepFromText": MessageLookupByLibrary.simpleMessage(
            "Abteilung aus Text hinzufügen"),
        "archive": MessageLookupByLibrary.simpleMessage("Archiv"),
        "areYouSureToDelete": MessageLookupByLibrary.simpleMessage(
            "Sind Sie sicher, dass Sie die Abteilung löschen möchten: "),
        "dark": MessageLookupByLibrary.simpleMessage("dunkel"),
        "data": MessageLookupByLibrary.simpleMessage("Daten: "),
        "deleteDep":
            MessageLookupByLibrary.simpleMessage("Abteilung löschende"),
        "depList":
            MessageLookupByLibrary.simpleMessage("Liste der Abteilungen"),
        "emptyDepList": MessageLookupByLibrary.simpleMessage(
            "Liste der Abteilungen ist leer!"),
        "error": MessageLookupByLibrary.simpleMessage("Fehler"),
        "flashLight": MessageLookupByLibrary.simpleMessage("Blitz"),
        "httpAccessError": MessageLookupByLibrary.simpleMessage(
            "Fehler: Serverzugriffsfehler!"),
        "internetError": MessageLookupByLibrary.simpleMessage(
            "Fehler: keine Internetverbindung!"),
        "light": MessageLookupByLibrary.simpleMessage("hell"),
        "loading": MessageLookupByLibrary.simpleMessage("Laden..."),
        "scanQrCode":
            MessageLookupByLibrary.simpleMessage("Abteilung aus QR hinzufügen"),
        "searchQR": MessageLookupByLibrary.simpleMessage("QR suchen..."),
        "selectDepForDelete": MessageLookupByLibrary.simpleMessage(
            "Wählen Sie die zu löschende Abteilung..."),
        "serverError":
            MessageLookupByLibrary.simpleMessage("Fehler: Serverfehler!"),
        "settings": MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "shortAboutApp": MessageLookupByLibrary.simpleMessage(
            "App für Dienstleistungen zählen AIS 3USON"),
        "sslError": MessageLookupByLibrary.simpleMessage(
            "Fehler bei sicherer Verbindung!"),
        "testConnection":
            MessageLookupByLibrary.simpleMessage("Testverbindung!"),
        "theme": MessageLookupByLibrary.simpleMessage("Thema:")
      };
}
