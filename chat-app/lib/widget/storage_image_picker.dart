import 'package:flutter/material.dart';
import 'dart:html' as html; // For web-based image handling

class UserImagePicker extends StatefulWidget {
  final void Function(html.File pickedImage) imagePickFn;

  const UserImagePicker({Key? key, required this.imagePickFn}) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  html.File? _pickedImage;
  String? _imageDataUrl;

  void _pickImage() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final reader = html.FileReader();
        _pickedImage = files.first;

        reader.readAsDataUrl(_pickedImage!);
        reader.onLoadEnd.listen((e) {
          setState(() {
            _imageDataUrl = reader.result as String?;
            widget.imagePickFn(_pickedImage!); // Pass the picked image to the parent widget
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_imageDataUrl != null)
          Image.network(
            _imageDataUrl!,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
        TextButton.icon(
          icon: Icon(Icons.image),
          label: Text('Pick an Image'),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
