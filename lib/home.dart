import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'components/Custom_Button.dart';
import 'helper/file_picker_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  String fileName = "Upload Your File";
  PlatformFile? pickedFile;
  Future<void> uploadFile () async {
    pickedFile = await pickFile();
    
    if (pickedFile != null){
      print(pickedFile?.name);
      setState(() {
        fileName = pickedFile!.name;
      });
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            pickedFile != null
            ?
            Container(
              child: SfPdfViewer.file(File(pickedFile!.path!)),
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              alignment: Alignment.center,
            )
              :
              Container(
                child: Text(
                  "No File Selected",
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              )
            ,
            Text(
              fileName,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            CustomElevatedButton(label: "Upload File", onPressed: uploadFile),
          ],
        )
      ),
    );
  }
}