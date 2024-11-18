import 'package:drape_shoppe_crm/constants/app_constants.dart';
import 'package:drape_shoppe_crm/controllers/supabaseController.dart';
import 'package:drape_shoppe_crm/models/comment.dart';
import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen(
      {super.key, required this.dealNo, required this.isNewTask});

  final String dealNo;
  final bool isNewTask;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentController = TextEditingController();

  FocusNode commentFocusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              widget.isNewTask
                  ? Text('add data')
                  : Expanded(
                      // Use Expanded to take available space
                      child: FutureBuilder<List<CommentModel>>(
                        future: SupabaseController.instance
                            .fetchComments(widget.dealNo),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          }

                          // Sort the comments by createdAt (ascending order, latest at the bottom)
                          List<CommentModel> comments = snapshot.data!;


                          return CustomCommentListView(
                            comments: comments,
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: AppConstants.appPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: commentController,
                focusNode: commentFocusNode,
                decoration: InputDecoration(
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Type a Message',
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                onPressed: () async {

                },
                icon: Icon(Icons.send_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCommentListView extends StatelessWidget {
  const CustomCommentListView({super.key, required this.comments});

  final List<CommentModel> comments;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        CommentModel comment = comments[index];
        bool isUser = comment.user !=
                // HomeProvider.instance.currentUser!.userName
                "a@gmail.com" ??
            false;
        return CommentChatContainerWidget(comment: comment);
      },
    );
  }
}

class CommentChatContainerWidget extends StatelessWidget {
  CommentChatContainerWidget({super.key, required this.comment});

  final CommentModel comment;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: comment.user !=
                  // HomeProvider.instance.currentUser!.userName
                  "a@gmail.com"
              ? Colors.blueAccent
              : Colors.grey,
          borderRadius: BorderRadius.only(
            topLeft: comment.user !=
                    // HomeProvider.instance.currentUser!.userName
                    "a@gmail.com"
                ? Radius.zero
                : Radius.circular(20.0),
            topRight: comment.user !=
                    // HomeProvider.instance.currentU ser!.userName
                    "a@gmail.com"
                ? Radius.circular(20.0)
                : Radius.zero,
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    comment.user,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                ],
              ),
              SizedBox(height: 5),
              Text(
                comment.comment,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
