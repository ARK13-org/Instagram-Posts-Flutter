import 'package:flutter/material.dart';
import 'package:test_app/api/dart_api.dart';
import 'package:test_app/models/post_model.dart';

class UpdatePage extends StatelessWidget {
  final int id;
  final String caption;

  const UpdatePage({super.key, required this.id, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: const Text(
          'Update Post',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: UpdatePost(id: id, caption: caption),
    );
  }
}

class UpdatePost extends StatefulWidget {
  final int id;
  final String caption;

  const UpdatePost({super.key, required this.id, required this.caption});

  @override
  State<UpdatePost> createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  Future<Posts>? futurePostDone;
  late final TextEditingController controller1;

  @override
  void initState() {
    super.initState();
    controller1 = TextEditingController(text: widget.caption);
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  Future<void> submitUpdate() async {
    if (controller1.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Caption cannot be empty')));
      return;
    }

    setState(() {
      futurePostDone = updatePost(widget.id, controller1.text.trim());
    });

    try {
      await futurePostDone;

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post updated successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Update failed: $e')));
    }
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
              decoration: const InputDecoration(
                labelText: 'Caption',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 10,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[800],
              ),
              onPressed: futurePostDone == null ? submitUpdate : null,
              child: const Text(
                'Update Post',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          if (futurePostDone != null)
            FutureBuilder<Posts>(
              future: futurePostDone,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return const Text('Error updating post');
                }

                if (snapshot.hasData) {
                  return const Icon(Icons.check_circle, color: Colors.green);
                }

                return const SizedBox.shrink();
              },
            ),
        ],
      ),
    );
  }
}
