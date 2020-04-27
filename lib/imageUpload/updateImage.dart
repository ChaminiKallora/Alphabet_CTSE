import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'imageUploadAPI.dart';
import 'imageUpload.dart';

class update extends StatefulWidget {
  final ImageUpload imageUpload;

  update({Key key, this.imageUpload}) : super(key: key);

  _update createState() => _update();
}

class _update extends State<update> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Works"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text('works'), 
            Text("${widget.imageUpload.name}"),
          ],
        ),
      ),
    );
  }
}
