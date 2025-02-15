

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum SortType { asc, desc }
enum SortOptions { none, createDate, priority, dueDate}

enum PriorityType { high, medium, low }

enum TaskStatus {
  pending,
  completed,
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

Color getColorByStatus(String status)
{
  if(status==TaskStatus.pending.name)
  {
    return Colors.deepOrange;
  }
  else if(status==TaskStatus.completed.name)
  {
    return Colors.green;
  }
  else
  {
    return Colors.blueAccent;
  }
}

Color getColorByPriority(String priority)
{
  if(priority==PriorityType.low.name)
  {
    return Colors.amber;
  }
  else if(priority==PriorityType.medium.name)
  {
    return Colors.teal;
  }
  else if(priority==PriorityType.high.name)
  {
    return Colors.pink;
  }
  else
  {
    return Colors.blueAccent;
  }
}

void showToastMessage(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    fontSize: 16.0,
  );
}


Future<void> customUIAlertPopUp({
  required BuildContext context,
  required String headerName,
  required String message,
  bool isNeutralPresent = false,
  String? neutralButtonName,
  bool isPositivePresent = false,
  String? positiveButtonName,
  bool isNegativePresent = false,
  String? negativeButtonName,
  bool dismissable = true,
  required VoidCallback? onNeutralButtonClick,
  required VoidCallback? onPositiveButtonClick,
  required VoidCallback? onNegativeButtonClick,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: dismissable,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(headerName),
        content: Text(message),
        backgroundColor: Colors.white,
        actions: <Widget>[
          if (isNeutralPresent)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onNeutralButtonClick != null) onNeutralButtonClick();
              },
              child: Text(neutralButtonName!),
            ),
          if (isPositivePresent)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onPositiveButtonClick != null) onPositiveButtonClick();
              },
              child: Text(positiveButtonName!),
            ),
          if (isNegativePresent)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onNegativeButtonClick != null) onNegativeButtonClick();
              },
              child: Text(negativeButtonName!),
            ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      );
    },
  );
}
