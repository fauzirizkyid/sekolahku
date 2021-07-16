import 'package:flutter/material.dart';

showAlertDialog(BuildContext context,
    {String title = "Konfirmasi",
    String content = "Apa anda yakin akan melakukan aksi berikut?",
    cancelText = 'Batal',
    continueText = 'Lanjut',
    cancelAction,
    @required continueAction}) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text(cancelText),
    onPressed: cancelAction != null
        ? cancelAction
        : () {
            Navigator.of(context, rootNavigator: true).pop();
          },
  );
  Widget continueButton = TextButton(
    child: Text(continueText),
    onPressed: continueAction,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
