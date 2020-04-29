import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImageUpload {
  //variables
  String alphabetLetter;
  String name;
  String imageUrl;
  String color;
  DocumentReference reference;

  //constructor
  ImageUpload({this.name, this.imageUrl, this.color});

  //set method for letter
  void setAlphabetLetter(String letter) {
    this.alphabetLetter = letter;
  }

  //map to upload the images
  ImageUpload.fromMap(Map<String, dynamic> map, {this.reference}) {
    alphabetLetter = map["alphabet_letter"];
    name = map["name"];
    imageUrl = map["image_url"];
    color = map["word_color"];
  }

  //snapshot
  ImageUpload.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  //convert to a json file
  toJson() {
    return {
      'alphabet_letter': alphabetLetter,
      'name': name,
      'image_url': imageUrl,
      'word_color': color
    };
  }
}
