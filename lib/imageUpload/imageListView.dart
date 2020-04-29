import 'package:abcd/imageUpload/imageUploadPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'imageUploadAPI.dart';
import 'imageUpload.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageListView extends StatefulWidget {
  @override
  _ImgeListViewPage createState() => _ImgeListViewPage();
}

class _ImgeListViewPage extends State<ImageListView> {
  ImageUploadAPI _imageUploadAPI = new ImageUploadAPI();

  //Load the data from firebase
  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("user_uploaded_images")
          .snapshots(), //_imageUploadAPI.getImages(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error --");
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print("Documents ${snapshot.data.documents.length}");
          return buildList(context, snapshot.data.documents);
        }
        return CircularProgressIndicator();
      },
    );
  }

  //delete confirmation dialog box
  _deleteConfirmationDialogBox(BuildContext context, ImageUpload imageUpload) {
    return showDialog(
        //
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            // retunr a dialog box
            actions: <Widget>[
              FlatButton(
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                    //shape of the dialog box
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                color: Colors.green[300],
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      // set style for the text
                      fontFamily: 'FredokaOne-Regular',
                      fontSize: 20,
                      color: Colors.black),
                ),
              ),
              FlatButton(
                // design cancel flat button
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                color: Colors.red[400],
                onPressed: () async {
                  _imageUploadAPI.delete(imageUpload);

                  //show success message by a toast
                  Fluttertoast.showToast(
                      msg: "Image deleted successfully.",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity
                          .CENTER, //get the toast to the center of the screen
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 20);

                  Navigator.pop(context);
                },
                child: Text(
                  // design update flat button
                  'Delete',
                  style: TextStyle(
                      fontFamily: 'FredokaOne-Regular',
                      fontSize: 20,
                      color: Colors.black),
                ),
              ),
            ],
            title: Text(
              //alert box message
              'Do you want to delete the image ?',
              style: TextStyle(
                  //text style of alert box message
                  fontFamily: 'FredokaOne-Regular',
                  fontSize: 20,
                  color: Colors.black),
            ),
            backgroundColor: Colors.purple[100],
            shape: RoundedRectangleBorder(
                //shape of the alert box
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            contentPadding: EdgeInsets.all(10.0),
          );
        });
  }

  //List of images imported
  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => buildListItem(context, data)).toList(),
    );
  }

  //build card for individual images
  Card buildListItem(BuildContext context, DocumentSnapshot data) {
    final imageUpload = ImageUpload.fromSnapshot(data);

    //get the color according to the user input
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

    return Card(
      child: Padding(
        //key: ValueKey(imageUpload.name),
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: getColor(imageUpload.color), width: 5),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: SizedBox(
                  width: 350,
                  height: 250,
                  child: Image.network(
                    imageUpload.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 80.0, vertical: 8.0),
                title: Text(
                  imageUpload.alphabetLetter + ' - ' + imageUpload.name,
                  style: TextStyle(
                      color: getColor(imageUpload.color),
                      fontFamily: 'FredokaOne-Regular',
                      fontSize: 25),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    //call delete the image confirmation dialog box
                    _deleteConfirmationDialogBox(context, imageUpload);
                  },
                ),
                onTap: () {
                  //forward to image update page
                  var route = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new ImageUploadPage(imageUpload: imageUpload));
                  Navigator.of(context).push(route);
                },
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  //create the image list page
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.yellow,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            image: DecorationImage(
              image: AssetImage("assets/images/rainbow.jpg"), //background image
              fit: BoxFit.fill,
            ),
          ),
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30.0),
              RichText(
                  text: TextSpan(
                      text: 'Learn',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'FredokaOne-Regular',
                        color: Colors.pink,
                      ),
                      children: [
                    TextSpan(
                      text: ' English',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'FredokaOne-Regular',
                        color: Colors.green,
                      ),
                    ),
                    TextSpan(
                      text: ' Words',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'FredokaOne-Regular',
                        color: Colors.blue,
                      ),
                    ),
                  ])),
              SizedBox(height: 30.0, width: 350),
              Flexible(
                child: buildBody(context),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[900],
          onPressed: () {
            var route = new MaterialPageRoute(
              builder: (BuildContext context) => new ImageUploadPage(),
            );
            Navigator.of(context).push(route);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
