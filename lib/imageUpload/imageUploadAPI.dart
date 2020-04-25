import 'package:cloud_firestore/cloud_firestore.dart';
import 'imageUpload.dart';

class ImageUploadAPI {
  getImages() async{
    return Firestore.instance.collection("user_uploaded_images").snapshots();
  }

  addImage(String name){
    ImageUpload imageUpload = new ImageUpload(name: name);
    print("print" + name);
    try{
      Firestore.instance.runTransaction(
            (Transaction transaction) async{
          await Firestore.instance
              .collection("user_uploaded_images")
              .document()
              .setData(imageUpload.toJson());
        },
      );
    } catch(e){
      print(e.toString());
    }
  }

  update(ImageUpload imageUpload, String newName){
    try{
      Firestore.instance.runTransaction((transaction) async{
        await transaction.update(imageUpload.reference, {'name': newName});
      });
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