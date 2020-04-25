import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'imageUploadAPI.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getflutter/getflutter.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImgeUploadPageState createState() => _ImgeUploadPageState();
}

class _ImgeUploadPageState extends State<ImageUploadPage> {
  ImageUploadAPI imageUploadAPI = new ImageUploadAPI();
  File _image;
  String _firebase_image_url =
      "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60";
  String _name;
  String _letter;

  final GlobalKey<FormState> _form_key = GlobalKey<FormState>();
  FocusNode imageUploadFocusNode = new FocusNode();

  Widget _buildFieldName() {
    //designing text field of image name
    return TextFormField(
      focusNode: imageUploadFocusNode,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromARGB(200, 255, 255, 255),
        labelText: 'Image Name',
        labelStyle: TextStyle(
            fontFamily: 'FredokaOne-Regular',
            fontSize: 20,
            color:
                imageUploadFocusNode.hasFocus ? Colors.black87 : Colors.black),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      keyboardType: TextInputType.text,
      validator: (String image_name) {
        if (image_name.isEmpty) {
          return 'Image Name is Required';
        }
        return null;
      },
      onSaved: (String image_name) {
        _name = image_name;
        _letter = image_name[0];
        print('Image letter' + _letter);
      },
    );
  }

  Widget _buildFieldImageUrl() {
    return (Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () => getImage(),
          child: (_image != null)
              ? SizedBox(
                  width: 200.0,
                  height: 200.0,
                  child: Image.file(_image, fit: BoxFit.fill))
              : Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/ctse-abcd.appspot.com/o/camera.png?alt=media&token=b3a743aa-c361-4b36-8ade-345e126a12fd",
                  fit: BoxFit.fill,
                ),
        ),
      ),
    ]));
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      _firebase_image_url = _image.toString();
      print('image path $_image');
    });
  }

  Future uploadPicture(BuildContext context) async {
    var getTimeAsKey = new DateTime.now();

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("user_uploaded_images");

    final StorageUploadTask uploadTask = firebaseStorageRef
        .child(getTimeAsKey.toString() + ".jpg")
        .putFile(_image);

    var image_url = await (await uploadTask.onComplete).ref.getDownloadURL();
    _firebase_image_url = image_url.toString();

    imageUploadAPI.addImage(_firebase_image_url);

    setState(() {
      print("Profile Piscture uploaded");
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white60,
        image: DecorationImage(
          image: AssetImage("assets/images/rainbow.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Color.fromARGB(80, 60, 50, 0),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              //Navigator.pop(context);
            },
          ),
          title: Text(
            'Add Image',
            style: TextStyle(fontFamily: 'PermanentMarker'),
          ),
        ),
        body: Builder(
            builder: (context) => Container(
                padding: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 40,
                  right: 40,
                ),
                child: Form(
                  key: _form_key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 30.0),
                      _buildFieldImageUrl(),
                      SizedBox(height: 30.0),
                      _buildFieldName(),
                      SizedBox(height: 30.0),
                      SizedBox(height: 30.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.blue,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              elevation: 4.0,
                              splashColor: Colors.blueGrey,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ),
                            SizedBox(width: 30.0),
                            RaisedButton(
                              color: Colors.blue,
                              onPressed: () {
                                if (!_form_key.currentState.validate()) {
                                  return;
                                }
                                _form_key.currentState.save();

                                uploadPicture(context);
                              },
                              elevation: 4.0,
                              splashColor: Colors.blueGrey,
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ),
                          ]),
                    ],
                  ),
                ))),
      ),
    );
  }
}
