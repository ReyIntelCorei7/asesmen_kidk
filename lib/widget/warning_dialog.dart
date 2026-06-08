import 'package:flutter/material.dart';

class WarningDialog extends StatelessWidget {
  final String? description;
  final VoidCallback? okClick;

  const WarningDialog({Key? key, this.description, this.okClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Peringatan"),
      content: Text(description ?? "Terjadi Kesalahan"),
      actions: [
        ElevatedButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
            if (okClick != null) okClick!();
          },
        )
      ],
    );
  }
}
