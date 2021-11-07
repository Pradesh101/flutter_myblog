import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myblog/app_screens/authentic_screen.dart';
import 'package:myblog/app_screens/upload_screen.dart';
import 'package:myblog/models/post.dart';
import 'package:myblog/widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

    var pid;
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');


    // Future<void> _deletePost() {
    //   return posts
    //       .doc(pid)
    //       .delete()
    //       .then((value) => Fluttertoast.showToast(msg: "Post deleted",
    //       toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red,
    //       textColor: Colors.white,))
    //       .catchError((error) => Fluttertoast.showToast(msg: "Failed to delete post:$error",
    //       toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red,
    //       textColor: Colors.white,));
    // }

    // Widget _alertBox()=>Center(
    //     child: AlertDialog(
    //         title: const Text('Do you want to delete this post?'),
    //         actions: <Widget>[
    //           TextButton(
    //             child: const Text('Cancel'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //           TextButton(
    //             child: const Text('Delete'),
    //             onPressed: () {
    //               _deletePost();
    //             },
    //           )
    //         ],
    //       ),
    // );

  Widget _cardUI(Post post){
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 10.0,
      child: Container(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(post.date,textAlign: TextAlign.center,style: const TextStyle
                  (fontSize: 15.0,color: Colors.grey,fontStyle: FontStyle.italic),),
                Text(post.time,textAlign: TextAlign.center,style: const TextStyle
                  (fontSize: 15.0,color: Colors.grey,fontStyle: FontStyle.italic),
                ),
                TextButton(onPressed: null, child: Icon(Icons.delete))
              ],
            ),
            const SizedBox(height: 10.0,),
            Image.network(post.imageUrl,
            height: 300.0,
            width: double.infinity,
            fit: BoxFit.cover,
            ),
            const SizedBox(height: 10.0,),
              Text(post.description,textAlign: TextAlign.center,style: const TextStyle
                (fontSize: 20.0,color: Colors.indigo)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UploadScreen()),);
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: (){
                FirebaseAuth.instance.signOut().whenComplete((){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthenticScreen()),);
                }).catchError((error){
                  Fluttertoast.showToast(msg: error.toString(),
                    toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red,
                    textColor: Colors.white,);
                });
              },
              child: const Icon(
               Icons.exit_to_app,
               color: Colors.white,
              )
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshots){
          if(!snapshots.hasData){
            return Center(
              child: circularProgressBar(),
            );
          }else{
            return ListView.builder(
              itemCount: snapshots.data!.docs.length,
              itemBuilder: (context,index){
                DocumentSnapshot ds = snapshots.data!.docs[index];
                //print(ds.id);
                pid= ds.id;
                //String did = ds['name'];
                Map<String, dynamic>? postMap = snapshots.data!.docs[index].data() as Map<String, dynamic>?;
                Post post = Post(
                  postMap!['imageUrl'],
                  postMap['description'],
                  postMap['date'],
                  postMap['time'],);
                return _cardUI(post);
            }
            );
          }
        },
      ),
    );
  }
}
