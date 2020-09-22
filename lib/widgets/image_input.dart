import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;


class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().getImage(source: ImageSource.camera);

    if(imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });

    // pobieram ścieżkę domyślną do dokumentów
    // i zapisuje kopię zdjęcia
    final appDir = await pathProvider.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            width: double.infinity,
            height: deviceHeight * 0.3,
      
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black12)),
            child: _storedImage != null
                ? Container(
                  width: double.infinity,
                  child: Image.file(
                      _storedImage,
                      fit: BoxFit.cover,
                    ),
                )
                : Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Icon(
                        Icons.camera_alt,
                        size: 90,
                        color: Colors.black12,
                      ),
                  ),
                ),
          ),
          Center(
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: RaisedButton(
                color: Colors.black54,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera, size: 30, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Take Picutre',
                        style: TextStyle(color: Colors.white, fontSize: 16))
                  ],
                ),
                onPressed: () {
                  _takePicture();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
