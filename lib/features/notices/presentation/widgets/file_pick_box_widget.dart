import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerBox extends StatefulWidget {
  final Function(File?) onFilePicked;

  const FilePickerBox({Key? key, required this.onFilePicked}) : super(key: key);

  @override
  State<FilePickerBox> createState() => _FilePickerBoxState();
}

class _FilePickerBoxState extends State<FilePickerBox> {
  File? _file;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      setState(() {
        _file = file;
      });
      widget.onFilePicked(_file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _file == null
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.attach_file, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      "Pick a File",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.file_upload, size: 40),
                    Text(
                      "Picked: ${_file!.path.split('/').last}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
