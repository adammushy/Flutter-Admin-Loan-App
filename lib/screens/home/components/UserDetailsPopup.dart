import 'package:flutter/material.dart';
import 'package:loan_admin_app/providers/user_management_provider.dart';
import 'package:provider/provider.dart';

class UserDetailsPopup extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetailsPopup({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("USER INFORMATION"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Phone: ${user['phone_number']}'),
          Text('Email: ${user['email']}'),
          Text('User Type: ${user['usertype']}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        user['usertype'] == 'LEADER'
            ? const SizedBox()
            : TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text(
                            'Do you want to delete this user? This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Provider.of<UserManagementProvider>(context,
                                      listen: false)
                                  .deleteUser(context, user['id']);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete user'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Delete user'),
              ),
      ],
    );
  }
}
