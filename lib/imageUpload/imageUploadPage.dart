import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'imageUploadAPI.dart';
import 'imageUpload.dart';

class ImageUploadPage extends StatefulWidget {
  final ImageUpload imageUpload;

  ImageUploadPage({Key key, this.imageUpload}) : super(key: key);

  @override
  _ImgeUploadPageState createState() => _ImgeUploadPageState();
}

class _ImgeUploadPageState extends State<ImageUploadPage> {
  //create an object from imageUploadAPI class
  ImageUploadAPI imageUploadAPI = new ImageUploadAPI();

  //to store the image temporary
  File _image;

  //the url of uploaded iamge
  String _firebase_image_url =
      "https://firebasestorage.googleapis.com/v0/b/ctse-abcd.appspot.com/o/camera.png?alt=media&token=b3a743aa-c361-4b36-8ade-345e126a12fd";

  //nam of the image
  String _name;

  //first letter of the image
  String _letter;

  //user chosen color
  String _colorOfWord;

  //get if the image upload is success
  bool _success = true;

  //global key for the form
  final GlobalKey<FormState> _form_key = GlobalKey<FormState>();

  //node to focus on a particular field
  FocusNode _imageUploadFocusNode = new FocusNode();

  Widget _buildFieldName() {
    //designing text field of image name
    return TextFormField(
      initialValue: widget.imageUpload != null &&
              widget.imageUpload.name.isNotEmpty &&
              widget.imageUpload.name != null
          ? widget.imageUpload.name
          : '',
      focusNode: _imageUploadFocusNode,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromARGB(200, 255, 255, 255),
        labelText: 'Image Name',
        labelStyle: TextStyle(
            fontFamily: 'FredokaOne-Regular', //imported font family
            fontSize: 20,
            color:
                _imageUploadFocusNode.hasFocus ? Colors.black87 : Colors.black),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      keyboardType: TextInputType.text,
      validator: (String image_name) {
        if (image_name.isEmpty) {
          return 'Image Name is Required'; //error message if the name of the image is empty
        }
        return null;
      },
      onSaved: (String image_name) {
        //after saved
        _name = image_name;
        _letter = image_name[0];
      },
    );
  }

  //manage dopdown list
  Widget _buildDropDownListOfColor() {
    //drop down list
    var _colorsList = ['blue', 'red', 'green', 'yellow', 'black'];

    //to change the underline color
    Color getColor(colorOfWord) {
      if (colorOfWord == 'blue')
        return Colors.blue;
      else if (colorOfWord == 'red')
        return Colors.red;
      else if (colorOfWord == 'green')
        return Colors.green;
      else if (colorOfWord == 'yellow')
        return Colors.yellow;
      else if (colorOfWord == 'black') return Colors.black;
    }

    return DropdownButton<String>(
      isExpanded: false,
      hint: Text('Color of the word'),
      onChanged: (String newColorOfWord) {
        setState(() {
          _colorOfWord = newColorOfWord; //change the color on change

          if (widget.imageUpload != null &&
              widget.imageUpload.color != null &&
              widget.imageUpload.color.isNotEmpty) {
            _colorOfWord = widget.imageUpload.color;
            widget.imageUpload.color = null;
          }
        });
      },
      items: _colorsList.map((String color) {
        return new DropdownMenuItem<String>(
          value: color,
          child: Text(color),
        );
      }).toList(),
      value: widget.imageUpload != null &&
              widget.imageUpload.color != null &&
              widget.imageUpload.color.isNotEmpty
          ? widget.imageUpload.color
          : _colorOfWord,
      iconSize: 24,
      elevation: 16,
      icon: Icon(
        Icons.arrow_downward,
        color: Colors.black,
      ),
      style: TextStyle(
          fontSize: 20,
          fontFamily: 'FredokaOne-Regular',
          color: Colors.black), //imported font family
      underline: Container(
        height: 5,
        color: widget.imageUpload != null &&
                widget.imageUpload.color != null &&
                widget.imageUpload.color.isNotEmpty
            ? getColor(widget.imageUpload.color)
            : getColor(
                _colorOfWord), //change color according to the user selectedS
      ),
    );
  }

  //manage the design of the upload image
  Widget _buildFieldImageUrl() {
    if (widget.imageUpload != null &&
        widget.imageUpload.imageUrl != null &&
        widget.imageUpload.imageUrl.isNotEmpty) {
      _firebase_image_url = widget.imageUpload.imageUrl;
    }
    return (Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Align(
        alignment: Alignment.center,
        child: InkWell(
            onTap: () => getImage(),
            child: (_image != null)
                ? SizedBox(
                    //if the iamge is already chosen
                    width: 200.0,
                    height: 250.0,
                    child: Image.file(_image, fit: BoxFit.fill))
                : SizedBox(
                    width: 200.0,
                    height: 250.0,
                    child: Image.network(
                      //if the image is not already chosen
                      _firebase_image_url,
                      fit: BoxFit.fill,
                    ),
                  )),
      ),
    ]));
  }

  //take the image from the gallery
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      _firebase_image_url = _image.toString();
    });
  }

  //get the image url after saving it to the firebase storage.
  Future uploadPicture(BuildContext context) async {
    //get the time to name the uploding images
    var getTimeAsKey = new DateTime.now();

    //create a folder to store user uploaded images
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("user_uploaded_images");

    //give a name to the uploading image
    final StorageUploadTask uploadTask = firebaseStorageRef
        .child(getTimeAsKey.toString() + ".jpg")
        .putFile(_image);

    //get the uploaded image url
    var image_url = await (await uploadTask.onComplete).ref.getDownloadURL();
    _firebase_image_url = image_url.toString();
    print(_firebase_image_url);

    //upload the image to firebase storage
    //imageUploadAPI.addImage(image_url);

    
  }

  //save ti db by calling api class
  Future saveToDatabase(BuildContext context) async {
    bool success;
    ImageUpload imageUpload = new ImageUpload();

    if(_image != null)
      await uploadPicture(context);

    imageUpload.name = _name;
    imageUpload.alphabetLetter = _letter;
    imageUpload.color = _colorOfWord;
    imageUpload.imageUrl = _firebase_image_url;

    if ( widget.imageUpload != null ){
      print('hi');
      await (imageUploadAPI.update( widget.imageUpload, imageUpload));
    }
    else
      success = await (imageUploadAPI.addImage(imageUpload));

    setState(() {
      if (success == true) print("Success");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white60,
        image: DecorationImage(
          image: AssetImage("assets/images/rainbow.jpg"), //background image
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Color.fromARGB(150, 180, 170, 255),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: widget.imageUpload != null
              ? Text(
                  'Update Image Details',
                  style: TextStyle(fontFamily: 'PermanentMarker'),
                ) //imported font family
              : Text(
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
                  child: SingleChildScrollView(
                    //wrap the form to a signgle scroll down view
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //the form
                        SizedBox(height: 30.0),
                        _buildFieldImageUrl(),
                        SizedBox(height: 30.0),
                        _buildFieldName(),
                        SizedBox(height: 30.0),
                        _buildDropDownListOfColor(),
                        SizedBox(height: 30.0),
                        SizedBox(height: 30.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                color: Colors.yellow[400],
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 24.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: Colors.blueAccent)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                elevation: 4.0,
                                splashColor: Colors.blueGrey,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontFamily: 'FredokaOne-Regular',
                                  ),
                                ),
                              ),
                              SizedBox(width: 30.0),
                              RaisedButton(
                                color: Colors.lightBlueAccent,
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 24.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: Colors.blueAccent)),
                                onPressed: () {
                                  if (!_form_key.currentState.validate()) {
                                    return;
                                  }
                                  _form_key.currentState.save();

                                  if (_success == true) {
                                    saveToDatabase(context);
                                  }
                                },
                                elevation: 4.0,
                                splashColor: Colors.blueGrey,
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontFamily: 'FredokaOne-Regular',
                                  ),
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }
}
