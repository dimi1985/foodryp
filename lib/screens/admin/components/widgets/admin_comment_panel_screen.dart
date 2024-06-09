// ignore_for_file: library_private_types_in_public_api, use_super_parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/comment.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/comment_service.dart';
import 'package:foodryp/utils/contants.dart';

class AdminCommentPanelPage extends StatefulWidget {
  final String? userRole;

  const AdminCommentPanelPage({Key? key, this.userRole}) : super(key: key);

  @override
  _AdminCommentPanelPageState createState() => _AdminCommentPanelPageState();
}

class _AdminCommentPanelPageState extends State<AdminCommentPanelPage> {
  late List<Comment> allComments = [];
  String searchText = '';
  String searchResult = '';
  Comment? comment = Constants.defaultComment;

  @override
  void initState() {
    super.initState();
    fetchAllComments();
  }

  void fetchAllComments() async {
    try {
      List<Comment> comments = await CommentService.getAllComments();
      setState(() {
        allComments = comments;
      });
    } catch (e) {
      // Handle error if fetching comments fails
      if (kDebugMode) {
        print('Failed to fetch comments: $e');
      }
    }
  }

  void searchCommentById(String commentId) async {
    try {
      // Call the service method to get the comment by ID
      Comment? getCcomment = await CommentService().getCommentById(commentId);
      setState(() {
        // Update the searchResult with the found comment
        comment = getCcomment;
        searchResult =
            '${AppLocalizations.of(context).translate('Comment found:')} ${comment?.text}';
      });
    } catch (e) {
      // Handle error if fetching comment fails
      setState(() {
        searchResult =
            AppLocalizations.of(context).translate('Comment not found');
      });
      if (kDebugMode) {
        print('Failed to search comment: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate('Admin Comment Panel')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)
                    .translate('Search by Comment ID'),
                labelText: AppLocalizations.of(context).translate('Search'),
                suffixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                searchCommentById(searchText);
              },
              child: Text(AppLocalizations.of(context).translate('Search')),
            ),
            const SizedBox(height: 16),
            if (searchResult.isNotEmpty)
              Row(
                children: [
                  Text(
                    searchResult,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (widget.userRole == 'admin' ||
                      widget.userRole == 'moderator')
                    IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await CommentService().deleteComment(
                              comment?.id ?? '',
                              widget.userRole,
                              comment?.recipeId ?? '');

                          setState(() {
                            fetchAllComments();
                            searchResult = '';
                          });
                        }),
                ],
              ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).translate('All Comments:'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: allComments.length,
                itemBuilder: (context, index) {
                  final comment = allComments[index];
                  return ListTile(
                    title: Text(comment.text),
                    // Add more ListTile properties as needed
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
