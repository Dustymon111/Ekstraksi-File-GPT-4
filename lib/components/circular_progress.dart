import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage

class UploadProgressDialog extends StatefulWidget {
  final Stream<TaskSnapshot> progressStream;
  final VoidCallback onClose;

  UploadProgressDialog({required this.progressStream, required this.onClose});

  @override
  _UploadProgressDialogState createState() => _UploadProgressDialogState();
}

class _UploadProgressDialogState extends State<UploadProgressDialog> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    widget.progressStream.listen((event) {
      setState(() {
        _progress = (event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) * 100;
      });
    }).onDone(() {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Uploading...'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(value: _progress / 100),
          SizedBox(height: 16),
          Text('${_progress.toStringAsFixed(2)}%'),
        ],
      ),
    );
  }
}
