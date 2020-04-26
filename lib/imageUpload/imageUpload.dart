import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImageUpload{
  String alphabetLetter;
  String name;
  String imageUrl;
  String color;
  DocumentReference reference;

  ImageUpload({this.name, this.imageUrl, this.color});

  void setAlphabetLetter(String letter){
    this.alphabetLetter = letter;
  }

  ImageUpload.fromMap(Map<String, dynamic> map, {this.reference}){
    alphabetLetter = map["alphabet_letter"];
    name = map["name"];
    imageUrl = map["image_url"];
    color = map["word_color"];
  }

  ImageUpload.fromSnapshot(DocumentSnapshot snapshot): this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson(){
    return {'name': name, 'alphabet_letter':alphabetLetter, 'image_url':imageUrl, 'word_color':color};
  }
}