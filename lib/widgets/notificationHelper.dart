import 'package:flutter/material.dart';
import 'package:elegant_notification/elegant_notification.dart';

class NotificationHelper {
  static void showSuccess(BuildContext context, String title, String description) {
    ElegantNotification.success(
      title: Text(
          title,
        style: TextStyle(
          color: Colors.black,
            fontWeight: FontWeight.bold
        ),
      ),
      description: Text(
          description,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary
        ),
      ),
    ).show(context);
  }

  static void showError(BuildContext context, String title, String description) {
    ElegantNotification.error(
      title: Text(
          title,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
        ),
      ),
      description: Text(
          description,
        style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary
        ),
      ),
    ).show(context);
  }

  static void showInfo(BuildContext context, String title, String description) {
    ElegantNotification.info(
      title: Text(
          title,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
        ),
      ),
      description: Text(
          description,
        style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary
        ),
      ),
    ).show(context);
  }

}
