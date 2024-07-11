import 'dart:io';

import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../components/custom_button.dart';
import '../utils/file_picker_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}



class _HomeState extends State<Home> {
  String fileName = "";
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
    var themeprov = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          Switch(
            thumbIcon: themeprov.isDarkTheme? WidgetStateProperty.all(const Icon(Icons.nights_stay)) :WidgetStateProperty.all(const Icon(Icons.sunny)) ,
            activeColor: Colors.white,
            inactiveThumbColor: Colors.indigo,
            value: themeprov.isDarkTheme, 
            onChanged: (bool value){
              themeprov.toggleTheme();
            },
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
            icon: const Icon(Icons.home),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/');
            }
          ),
          IconButton(
            icon: const Icon(Icons.book_outlined),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/bookmarks');
            }
          ),
          ]
        ,),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            pickedFile != null
            ?
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.height / 1.5,
              alignment: Alignment.center,
              child: SfPdfViewer.file(
                scrollDirection: PdfScrollDirection.horizontal,
                pageLayoutMode: PdfPageLayoutMode.single,
                File(pickedFile!.path!)),
            )
              :
              Container(
                child: const Text(
                  "No File Selected",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              )
            ,
            Container(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Text(
                fileName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(label: pickedFile != null? "Ganti Berkas" : "Unggah Berkas", onPressed: uploadFile),
                SizedBox(width: 20,),

                CustomElevatedButton(label: "Ekstrak Berkas", onPressed: pickedFile != null ? () {
                  print("proses ekstraksi dimulai");
              } : null,)
              ],
            )
          ],
        )
      ),
    );
  }
}