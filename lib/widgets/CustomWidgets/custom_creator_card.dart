import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';

class CustomCreatorCard extends StatefulWidget {
  final User user;
  final String currentLoggedUserId;

  const CustomCreatorCard({
    super.key,
    required this.user,
    required this.currentLoggedUserId,
  });

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
            ?.contains(widget.currentLoggedUserId) ??
        false) {
      buttonText = AppLocalizations.of(context).translate('Sent Request');
    } else if (widget.user.followRequestsCanceled
            ?.contains(widget.currentLoggedUserId) ??
        false) {
      buttonText = AppLocalizations.of(context).translate('Follow Back');
    } else if (widget.user.followers?.contains(widget.currentLoggedUserId) ??
        false) {
      buttonText = AppLocalizations.of(context).translate('Following');
    } else {
      buttonText = AppLocalizations.of(context).translate('Follow');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: ImagePickerPreviewContainer(
          initialImagePath: widget.user.profileImage,
          containerSize: 30,
          onImageSelected: (image, bytes) {},
          gender: widget.user.gender ?? Constants.emptyField,
          isFor: Constants.emptyField,
          isForEdit: Constants.defaultBoolValue,
          allowSelection: false,
        ),
        title: Text(widget.user.username,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          widget.user.followRequestsCanceled
                      ?.contains(widget.currentLoggedUserId) ??
                  false
              ? AppLocalizations.of(context).translate(
                  'User is following you, you can follow back at any time')
              : widget.user.email,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: SizedBox(
          height: 75,
          width: widget.user.followRequestsSent
                      ?.contains(widget.currentLoggedUserId) ??
                  false
              ? 250
              : 100,
          child: widget.user.followRequestsSent
                      ?.contains(widget.currentLoggedUserId) ??
                  false
              ? Row(
                  children: [
                    if (!requestRejected)
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              buttonText = AppLocalizations.of(context)
                                  .translate('Following Back');
                              requestAccepted = true;
                            });
                            UserService()
                                .acceptFollowRequest(widget.user.id)
                                .then((success) {
                              if (success) {
                                setState(() {
                                  buttonText = AppLocalizations.of(context)
                                      .translate('Following');
                                });
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .primaryColor, // Use the primary theme color
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                          ),
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                                color: Constants.secondaryColor),
                          ),
                        ),
                      ),
                    const SizedBox(width: 10),
                    if (!requestAccepted)
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              buttonText = AppLocalizations.of(context)
                                  .translate('No Thanks');
                              requestRejected = true;
                            });
                            UserService().rejectFollowRequest(widget.user.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Color for rejection
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                          ),
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate('No Thanks'),
                              style: const TextStyle(
                                  color: Constants.secondaryColor)),
                        ),
                      ),
                  ],
                )
              : ElevatedButton(
                  onPressed: () => buttonPressAction(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .primaryColor, // Use the primary theme color
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Constants.secondaryColor),
                  ),
                ),
        ),
      ),
    );
  }

  void buttonPressAction() {
    // Include your existing logic to handle button press here.
    // This part should handle different states like following, unfollowing, etc.
    if (widget.user.followers?.contains(widget.currentLoggedUserId) ?? false) {
      // Implement logic for following user
      setState(() {
        buttonText = AppLocalizations.of(context).translate('UnFollowing');
      });
      UserService().unFollow(widget.user.id);
    } else if (widget.user.followRequestsCanceled
            ?.contains(widget.currentLoggedUserId) ??
        false) {
      setState(() {
        buttonText = AppLocalizations.of(context).translate('Following Back');
      });
      UserService().followBack(widget.user.id);
    } else if (!((widget.user.following ?? []).contains(widget.user.id)) &&
        !((widget.user.followRequestsSent ?? []).contains(widget.user.id)) &&
        !((widget.user.followRequestsReceived ?? [])
            .contains(widget.user.id)) &&
        !((widget.user.followRequestsCanceled ?? [])
            .contains(widget.user.id))) {
      UserService().followUser(widget.user.id);

      setState(() {
        buttonText =
            widget.user.following?.contains(widget.currentLoggedUserId) ?? false
                ? AppLocalizations.of(context).translate('Following')
                : AppLocalizations.of(context).translate('Sent Request');
      });
      // Implement logic for accepting follow request
    }
  }
}
