// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loan_admin_app/providers/user_management_provider.dart';
import 'package:provider/provider.dart';
import 'UserDetailsPopup.dart';
import 'add_new_user_screen.dart'; // Import the UserDetailsPopup widget

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  // var userData;
  setUserData() {
    Provider.of<UserManagementProvider>(context, listen: false).getUsersList();
    // var data =
    //     Provider.of<UserManagementProvider>(context, listen: false).getUserList;
    // setState(() {
    //   userData = data;
    // });
  }

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: Consumer<UserManagementProvider>(
          builder: (context, recordProvider, child) {
        return recordProvider.getUserList == null ||
                recordProvider.getUserList.isEmpty
            ? const SizedBox()
            : ListView.builder(
                itemCount: recordProvider.getUserList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return UserDetailsPopup(
                              user: recordProvider.getUserList[index]);
                        },
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(recordProvider.getUserList[index]
                                ['username']
                            .toString()),
                        subtitle: Text(
                          recordProvider.getUserList[index]['usertype']
                              .toString(),
                        ),
                        trailing: Column(
                          children: [
                            Icon(
                              recordProvider.getUserList[index]['usertype']
                                          .toString() ==
                                      "LEADER"
                                  ? Icons.admin_panel_settings
                                  : Icons.people,
                              color: recordProvider.getUserList[index]
                                              ['usertype']
                                          .toString() ==
                                      "LEADER"
                                  ? Colors.blue
                                  : Colors.green,
                            ),
                            // recordProvider.getUserList[index]['usertype']
                                //         .toString() ==
                                //     "LEADER"
                                // ? SizedBox()
                                // : GestureDetector(
                                //     onTap: () {},
                                //     child: Icon(
                                //       Icons.delete,
                                //       color: Colors.red,
                                //     ),
                                //   ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddUserScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
