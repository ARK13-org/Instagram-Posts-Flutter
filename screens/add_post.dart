import 'package:flutter/material.dart';
import 'package:test_app/api/dart_api.dart';
import 'package:test_app/models/post_model.dart';

class AddPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[800],
          title: Text(
            'Add Post',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: AddPosts(),
      ),
    );
  }
}

class AddPosts extends StatefulWidget {
  const new({super.key});

  @override
  State<AddPosts> createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {
  Future<Posts>? futurePostDone;
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();

  void clearText() {
    controller1.clear();
    controller2.clear();
    controller3.clear();
  }

  FutureBuilder<Posts> buildFuturBuilder() {
    return FutureBuilder(
      future: futurePostDone,
      builder: (BuildContext context, AsyncSnapshot<Posts> snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: 125,
            decoration: BoxDecoration(
              color: Colors.blueGrey[600],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Successful',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Icon(Icons.thumb_up, color: Colors.white, size: 15),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error');
        }
        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: controller1,
              decoration: InputDecoration(label: Text('Image Url')),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 10,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: controller2,
              decoration: InputDecoration(label: Text('Caption')),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: controller3,
              decoration: InputDecoration(label: Text('ID')),
              keyboardType: TextInputType.multiline,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[800],
              ),
              onPressed: () {
                setState(() {
                  futurePostDone = creatPost(
                    controller1.text,
                    controller2.text,
                    int.parse(controller3.text),
                  );
                  clearText();
                });
              },
              child: Text('Add Post', style: TextStyle(color: Colors.white)),
            ),
          ),
          Center(
            child: futurePostDone == null ? Text('') : buildFuturBuilder(),
          ),
        ],
      ),
    );
  }
}
