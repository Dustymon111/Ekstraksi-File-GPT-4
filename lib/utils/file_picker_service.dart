import 'package:file_picker/file_picker.dart';

Future pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'doc', 'docx'],
  );

  if (result != null) {
    PlatformFile file = result.files.first;

    print('File name: ${file.name}');
    print('File size: ${file.size}');
    print('File path: ${file.path}');
    return file;
  } else {
    // User canceled the picker
    print('User canceled the picker');
  }
}