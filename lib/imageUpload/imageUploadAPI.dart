import 'package:cloud_firestore/cloud_firestore.dart';
import 'imageUpload.dart';

class ImageUploadAPI {
  //get the list of images
  getImages() async {
    return Firestore.instance.collection("user_uploaded_images").snapshots();
  }

  //add images
  addImage(ImageUpload imageUploadObj) {
    //create a object
    ImageUpload imageUpload = new ImageUpload(
        name: imageUploadObj.name,
        imageUrl: imageUploadObj.imageUrl,
        color: imageUploadObj.color);

    //set the letter value of the object
    imageUpload.setAlphabetLetter(imageUploadObj.alphabetLetter);

    //upload the information
    try {
      Firestore.instance.runTransaction(
        (Transaction transaction) async {
          await Firestore.instance
              .collection("user_uploaded_images") //the folder name
              .document()
              .setData(imageUpload.toJson());
        },
      );

      return true;
    } catch (e) {
      print('error - add' + e.toString());
    }
  }

  //update tje image
  update(ImageUpload imageUpload, ImageUpload currImageUpload) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(imageUpload.reference, {
          'alphabet_letter': currImageUpload.alphabetLetter,
          'name': currImageUpload.name,
          'image_url': currImageUpload.imageUrl,
          'word_color': currImageUpload.color
        });
      });
      print(currImageUpload.name);
    } catch (e) {
      print(e.toString());
    }
  }

  //delete image
  delete(ImageUpload imageUpload) {
    Firestore.instance.runTransaction(
      (Transaction transaction) async {
        // asyncronus operation
        await transaction.delete(imageUpload.reference);
      },
    );
  }
}
