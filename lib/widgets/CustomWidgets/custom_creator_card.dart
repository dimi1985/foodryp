import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/utils/user_service.dart';

class CustomCreatorCard extends StatefulWidget {
  final User user;
  final String currentLoggedUserId;

  const CustomCreatorCard(
      {super.key, required this.user, required this.currentLoggedUserId});

  @override
  State<CustomCreatorCard> createState() => _CustomCreatorCardState();
}

class _CustomCreatorCardState extends State<CustomCreatorCard> {
  late String buttonText;
  bool requestAccepted = false;
  bool requestRejected = false;

  @override
  void initState() {
    super.initState();
    setButtonText();
  }

  void setButtonText() {
    if (widget.user.followRequestsReceived
        .contains(widget.currentLoggedUserId)) {
      buttonText = 'Sent Request';
    } else if (widget.user.followRequestsCanceled
        .contains(widget.currentLoggedUserId)) {
      buttonText = 'Follow Back';
    } else if (widget.user.followers.contains(widget.currentLoggedUserId)) {
      buttonText = 'Following';
    } else {
      buttonText = 'Follow';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.user.username),
      subtitle: Text(
        widget.user.followRequestsCanceled.contains(widget.currentLoggedUserId)
            ? 'User is following you, you can follow back at any time'
            : widget.user.email,
      ),
      trailing: SizedBox(
        height: 75,
        width:
            widget.user.followRequestsSent.contains(widget.currentLoggedUserId)
                ? 250
                : 100,
        child: widget.user.followRequestsSent
                .contains(widget.currentLoggedUserId)
            ? Row(
                children: [
                  if (!requestRejected)
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            buttonText = 'Following Back';
                            requestAccepted = true;
                          });
                          // Logic for following back
                          UserService()
                              .rejectFollowRequest(widget.user.id)
                              .then((success) {
                            if (success) {}
                          });
                        },
                        child: Text(buttonText),
                      ),
                    ),
                  const SizedBox(width: 10),
                  if (!requestAccepted)
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            buttonText = 'No Thanks';
                            requestRejected = true;
                          });
                          // Logic for rejecting follow request
                          UserService().rejectFollowRequest(widget.user.id);
                        },
                        child: const Text('No Thanks'),
                      ),
                    ),
                ],
              )
            : ElevatedButton(
                onPressed: () {
                  if (widget.user.followers
                      .contains(widget.currentLoggedUserId)) {
                    // Implement logic for following user
                    setState(() {
                      buttonText = 'UnFollowing';
                    });
                    UserService().unFollow(widget.user.id);
                  } else if (widget.user.followRequestsCanceled
                      .contains(widget.currentLoggedUserId)) {
                    setState(() {
                      buttonText = 'Following Back';
                    });
                    UserService().followBack(widget.user.id);
                  } else if (!widget.user.following.contains(widget.user.id) &&
                      !widget.user.followRequestsSent
                          .contains(widget.user.id) &&
                      !widget.user.followRequestsReceived
                          .contains(widget.user.id) &&
                      !widget.user.followRequestsCanceled
                          .contains(widget.user.id)) {
                    UserService().followUser(widget.user.id);

                    setState(() {
                      buttonText = widget.user.following
                              .contains(widget.currentLoggedUserId)
                          ? 'Following'
                          : 'Sent Request';
                    });
                    // Implement logic for accepting follow request
                  }
                },
                child: Text(buttonText),
              ),
      ),
    );
  }
}
