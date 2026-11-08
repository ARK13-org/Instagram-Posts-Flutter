import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:test_app/api/dart_api.dart';
import 'package:test_app/models/post_model.dart';
import 'package:test_app/screens/add_post.dart';
import 'package:test_app/screens/update_post.dart';

void main() => runApp(MyPage());

class MyPage extends StatefulWidget {
  const new({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyHome());
  }
}

class MyHome extends StatefulWidget {
  const new({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  RefreshController refreshController = RefreshController();

  void onRefresh() async {
    await fetchAllPosts().then((value) {
      setState(() {
        futureAllPosts = value;
      });
    });
  }

  late List<Posts>? futureAllPosts;
  @override
  void initState() {
    fetchAllPosts().then((value) => futureAllPosts = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text(
          'ARK13',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchAllPosts(),
          builder: (BuildContext context, AsyncSnapshot snapShot) {
            if (snapShot.hasData) {
              return SmartRefresher(
                controller: refreshController,
                onRefresh: onRefresh,
                child: ListView.builder(
                  itemCount: futureAllPosts?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.blueGrey[200],
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 25,
                                    child: Icon(
                                      Icons.account_circle_rounded,
                                      color: Colors.blueGrey[800],
                                      size: 50,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    futureAllPosts![index].user!.username
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 290),
                                  child: PopupMenuButton(
                                    elevation: 0,
                                    color: Colors.blueGrey[800]!.withValues(
                                      alpha: 0.5,
                                    ),
                                    constraints: BoxConstraints(maxWidth: 50),
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        PopupMenuItem(
                                          value: '/edit',
                                          onTap: () async {
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdatePage(
                                                      id: futureAllPosts![index]
                                                          .id!,
                                                      caption:
                                                          futureAllPosts![index]
                                                              .caption ??
                                                          '',
                                                    ),
                                              ),
                                            );

                                            if (result == true) {
                                              setState(() async {
                                                futureAllPosts =
                                                    await fetchAllPosts();
                                              });
                                            }
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.blue[600],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: '/delete',
                                          onTap: () {
                                            deletePost(
                                              futureAllPosts![index].id!,
                                            );
                                            setState(() {
                                              fetchAllPosts().then(
                                                (value) =>
                                                    futureAllPosts = value,
                                              );
                                            });
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ];
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image.network(
                            futureAllPosts![index].imageUrl.toString(),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    futureAllPosts![index].caption.toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else if (snapShot.hasError) {
              return Text('${snapShot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[800],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) => AddPage()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
