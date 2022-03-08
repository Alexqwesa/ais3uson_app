// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("About"),
        "add": MessageLookupByLibrary.simpleMessage("Add!"),
        "addDepFromText":
            MessageLookupByLibrary.simpleMessage("Add department from text"),
        "archive": MessageLookupByLibrary.simpleMessage("Archive"),
        "areYouSureToDelete": MessageLookupByLibrary.simpleMessage(
            "Are you sure that you want to delete department: "),
        "dark": MessageLookupByLibrary.simpleMessage("Dark"),
        "data": MessageLookupByLibrary.simpleMessage("Data: "),
        "deleteDep": MessageLookupByLibrary.simpleMessage("Delete department"),
        "depList": MessageLookupByLibrary.simpleMessage("List of departments"),
        "emptyDepList": MessageLookupByLibrary.simpleMessage(
            "List of departments is empty!"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "flashLight": MessageLookupByLibrary.simpleMessage("Flash"),
        "light": MessageLookupByLibrary.simpleMessage("Light"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "scanQrCode":
            MessageLookupByLibrary.simpleMessage("Add department from QR code"),
        "searchQR": MessageLookupByLibrary.simpleMessage("searching QR..."),
        "selectDepForDelete": MessageLookupByLibrary.simpleMessage(
            "Select department to delete..."),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "shortAboutApp": MessageLookupByLibrary.simpleMessage(
            "App for accounting services AIS 3USON"),
        "testConnection":
            MessageLookupByLibrary.simpleMessage("Test connection!"),
        "theme": MessageLookupByLibrary.simpleMessage("Theme:")
      };
}
