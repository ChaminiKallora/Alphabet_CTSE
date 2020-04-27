import 'package:abcd/imageUpload/imageUploadPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

    print("print" + imageUploadObj.name);
    print("print" + imageUploadObj.alphabetLetter);
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