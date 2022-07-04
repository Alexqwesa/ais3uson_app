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
        "addDep": MessageLookupByLibrary.simpleMessage("Add department"),
        "addDepFromText":
            MessageLookupByLibrary.simpleMessage("Add department from text"),
        "after": MessageLookupByLibrary.simpleMessage("After:"),
        "archive": MessageLookupByLibrary.simpleMessage("Archive"),
        "archiveAt": MessageLookupByLibrary.simpleMessage("Archive at: "),
        "areYouSureToDelete": MessageLookupByLibrary.simpleMessage(
            "Are you sure that you want to delete department: "),
        "authorizePlease": MessageLookupByLibrary.simpleMessage(
            "Please, authorize \n (scan QR-code). \n (Or add example department)"),
        "awaitResults":
            MessageLookupByLibrary.simpleMessage("Awaiting results..."),
        "before": MessageLookupByLibrary.simpleMessage("Before:"),
        "cameraAccessDenied": MessageLookupByLibrary.simpleMessage(
            "Access denied: Please, allow app access to camera"),
        "cantAddDepBadFormat": MessageLookupByLibrary.simpleMessage(
            "Can\'t add department. Wrong format of string."),
        "cantAddDepDuplicate": MessageLookupByLibrary.simpleMessage(
            "Can\'t add department. Maybe it is already exist."),
        "clear": MessageLookupByLibrary.simpleMessage("Clear"),
        "dark": MessageLookupByLibrary.simpleMessage("Dark"),
        "data": MessageLookupByLibrary.simpleMessage("Data: "),
        "deleteDep": MessageLookupByLibrary.simpleMessage("Delete department"),
        "depList": MessageLookupByLibrary.simpleMessage("List of departments"),
        "detailed": MessageLookupByLibrary.simpleMessage("Detailed"),
        "developer": MessageLookupByLibrary.simpleMessage(
            "Developer: Savin Alexander Victorovich aka Alexqwesa"),
        "doScanQrCode": MessageLookupByLibrary.simpleMessage("Scan your QR"),
        "emptyDepList": MessageLookupByLibrary.simpleMessage(
            "List of departments is empty!"),
        "emptyListOfPeople": MessageLookupByLibrary.simpleMessage(
            "List of clients is empty, \n\n please ask your manager to add people into your list \n\n then click on refresh button."),
        "emptyListOfServices":
            MessageLookupByLibrary.simpleMessage("No services provided!"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "errorDepSave": MessageLookupByLibrary.simpleMessage(
            "Error: Failed to save department profile!"),
        "errorFS": MessageLookupByLibrary.simpleMessage(
            "FileSystem error: can\'t access directory"),
        "errorFormat": MessageLookupByLibrary.simpleMessage(
            "Error: server response format is wrong!"),
        "errorSave": MessageLookupByLibrary.simpleMessage(
            "Error: Failed to save log entry, \n check free space on device, \n check write permissions"),
        "errorService": MessageLookupByLibrary.simpleMessage(
            "Error: Can not find this service "),
        "errorWrongCertificate": MessageLookupByLibrary.simpleMessage(
            "Error: can\'t add certificate of department"),
        "exportLastMonth":
            MessageLookupByLibrary.simpleMessage("Export last month"),
        "exportLastWeek":
            MessageLookupByLibrary.simpleMessage("Export last week"),
        "exportThisMonth":
            MessageLookupByLibrary.simpleMessage("Export this month"),
        "exportThisWeek":
            MessageLookupByLibrary.simpleMessage("Export this week"),
        "fileSavedTo":
            MessageLookupByLibrary.simpleMessage("File is saved to: "),
        "flashLight": MessageLookupByLibrary.simpleMessage("Flash"),
        "httpAccessError":
            MessageLookupByLibrary.simpleMessage("Error: server access error!"),
        "internetError": MessageLookupByLibrary.simpleMessage(
            "Error: no Internet connection!"),
        "light": MessageLookupByLibrary.simpleMessage("Light"),
        "list": MessageLookupByLibrary.simpleMessage("List"),
        "listOfServicesByDays":
            MessageLookupByLibrary.simpleMessage("List of services by days"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "magnification": MessageLookupByLibrary.simpleMessage("Magnifycation:"),
        "magnificationOfServiceWidgets": MessageLookupByLibrary.simpleMessage(
            "Magnifycation of service widgets:"),
        "makeProofOfService": MessageLookupByLibrary.simpleMessage(
            "Make photo or audio record as a proof:"),
        "maxServicesToStoreInArchive": MessageLookupByLibrary.simpleMessage(
            "The maximum number of services stored in the archive:"),
        "noServicesForClient": MessageLookupByLibrary.simpleMessage(
            "List of client\'s services is empty, \n\n maybe manager already close the contract,\n\n or you can try to refresh the list!"),
        "onRequest": MessageLookupByLibrary.simpleMessage("On search: \n\n"),
        "optional": MessageLookupByLibrary.simpleMessage("OPTIONAL!"),
        "orTestDepList": MessageLookupByLibrary.simpleMessage(
            "Or add example department from list:"),
        "proofOfService":
            MessageLookupByLibrary.simpleMessage("Proof of the service:"),
        "putDepText": MessageLookupByLibrary.simpleMessage(
            "Put department code into this text field..."),
        "putDepTextField":
            MessageLookupByLibrary.simpleMessage("Put department code here"),
        "putDepTextFieldHint": MessageLookupByLibrary.simpleMessage(
            "Put department code here (this is redundant mode of department addition), it useful in case of broken or absent camera... \n the recommended way is: scan QR-code!"),
        "repeatSearch": MessageLookupByLibrary.simpleMessage("RepeatSearch"),
        "scanQrCode":
            MessageLookupByLibrary.simpleMessage("Add department from QR code"),
        "searchQR": MessageLookupByLibrary.simpleMessage("searching QR..."),
        "selectDepForDelete": MessageLookupByLibrary.simpleMessage(
            "Select department to delete..."),
        "serverError":
            MessageLookupByLibrary.simpleMessage("Error: server error!"),
        "serviceIsFull":
            MessageLookupByLibrary.simpleMessage("This service is full!"),
        "servicesNotFound":
            MessageLookupByLibrary.simpleMessage("\n\nServices not found!"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "shortAboutApp": MessageLookupByLibrary.simpleMessage(
            "App for accounting services AIS 3USON"),
        "small": MessageLookupByLibrary.simpleMessage("Small"),
        "sslError": MessageLookupByLibrary.simpleMessage(
            "Error: secure connection error!"),
        "takePicture":
            MessageLookupByLibrary.simpleMessage("Take picture as proof"),
        "testConnection":
            MessageLookupByLibrary.simpleMessage("Test connection!"),
        "theme": MessageLookupByLibrary.simpleMessage("Theme:")
      };
}
