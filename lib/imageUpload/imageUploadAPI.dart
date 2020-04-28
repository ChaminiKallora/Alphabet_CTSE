import 'package:cloud_firestore/cloud_firestore.dart';
import 'imageUpload.dart';

class ImageUploadAPI {
  getImages() async{
    return Firestore.instance.collection("user_uploaded_images").snapshots();
  }

  addImage(ImageUpload imageUploadObj){
    ImageUpload imageUpload = new ImageUpload(
      name: imageUploadObj.name,
      imageUrl : imageUploadObj.imageUrl,
      color: imageUploadObj.color 
    );
    
    imageUpload.setAlphabetLetter(imageUploadObj.alphabetLetter);

    try{
      Firestore.instance.runTransaction(
            (Transaction transaction) async{
          await Firestore.instance
              .collection("user_uploaded_images")
              .document()
              .setData(imageUpload.toJson());
        },
      );
      
      return true;
    } catch(e){
      print('error - add' + e.toString());
    }
  }

  update(ImageUpload imageUpload, ImageUpload currImageUpload){
    try{
      Firestore.instance.runTransaction((transaction) async{
        await transaction.update(imageUpload.reference, {'alphabet_letter':currImageUpload.alphabetLetter, 'name':currImageUpload.name, 'image_url':currImageUpload.imageUrl, 'word_color':currImageUpload.color});
      });
      print(currImageUpload.name);
    } catch(e){
      print(e.toString());
    }
  }

  delete(ImageUpload imageUpload){
    Firestore.instance.runTransaction(
          (Transaction transaction) async{
        await transaction.delete(imageUpload.reference);
      },
    );
  }
}