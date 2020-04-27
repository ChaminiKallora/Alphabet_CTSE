import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'imageUploadAPI.dart';
import 'imageUpload.dart';

class ImageListView extends StatefulWidget {
  @override
  _ImgeListViewPage createState() => _ImgeListViewPage();
}

class _ImgeListViewPage extends State<ImageListView> {
  ImageUploadAPI _imageUploadAPI = new ImageUploadAPI();

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

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => buildListItem(context, data)).toList(),
    );
  }

  Card buildListItem(BuildContext context, DocumentSnapshot data) {
    final imageUpload = ImageUpload.fromSnapshot(data);

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
                    _imageUploadAPI.delete(imageUpload); //delete the image
                  },
                ),
                onTap: () {
                  //setUpdateUI(user);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(150, 180, 170, 255),
        body: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(150, 180, 170, 255),
            image: DecorationImage(
              image: AssetImage("assets/images/rainbow.jpg"), //background image
              fit: BoxFit.fill,
            ),
          ),
          padding: EdgeInsets.all(20.0),
          child: Column(
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
                      text: ' Alphabet',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'FredokaOne-Regular',
                        color: Colors.green,
                      ),
                    ),
                  ])),
              SizedBox(height: 30.0),
              Flexible(
                child: buildBody(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
