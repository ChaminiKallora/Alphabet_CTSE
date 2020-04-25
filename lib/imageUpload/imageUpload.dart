import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImageUpload{
  String alphabetLetter;
  String name;
  String imageUrl;
  DocumentReference reference;

  ImageUpload({this.name});

  ImageUpload.fromMap(Map<String, dynamic> map, {this.reference}){
    alphabetLetter = map["alphabetLetter"];
    name = map["name"];
    imageUrl = map["imageUrl"];
  }

  ImageUpload.fromSnapshot(DocumentSnapshot snapshot): this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson(){
    return {'name': name};
  }
}