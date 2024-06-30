// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_admin_app/constants/app_constants.dart';
import 'package:loan_admin_app/constants/snackbar.dart';
import 'package:loan_admin_app/providers/loan_management_provider.dart';
import 'package:loan_admin_app/providers/user_management_provider.dart';
import 'package:loan_admin_app/shared-preference-manager/preference-manager.dart';
import 'package:provider/provider.dart';

class LoanRequestsWidget extends StatefulWidget {
  const LoanRequestsWidget({Key? key}) : super(key: key);

  @override
  _LoanRequestsWidgetState createState() => _LoanRequestsWidgetState();
}

class _LoanRequestsWidgetState extends State<LoanRequestsWidget> {
  int _selectedIndex = 0;
  // List<String> newLoanRequests = ['Request 1', 'Request 2', 'Request 3'];
  // List<String> verifiedRequests = [];

  @override
  void initState() {
    super.initState();
    Provider.of<LoanManagementProvider>(context, listen: false)
        .getAcceptLoanList();
    Provider.of<LoanManagementProvider>(context, listen: false)
        .getPendLoanList();
  }

  String formattedDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat formatter = DateFormat.yMMMMd('en_US').add_jms();
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _selectedIndex == 0
                          ? Colors.green[400]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'New Loan Request',
                      style: TextStyle(
                        color:
                            _selectedIndex == 0 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _selectedIndex == 1
                          ? Colors.green[400]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Verified Requests',
                      style: TextStyle(
                        color:
                            _selectedIndex == 1 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Conditional rendering based on _selectedIndex
          _selectedIndex == 0
              ? Consumer<LoanManagementProvider>(
                  builder: (context, recordProvider, child) {
                  // print("userss:: ${recordProvider.getPendingLoanList}");
                  return recordProvider.getPendingLoanList == null ||
                          recordProvider.getPendingLoanList.isEmpty
                      ? const Center(
                          child: Text(
                            'No new loan requests',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: recordProvider.getPendingLoanList
                              .map<Widget>((request) => InkWell(
                                    onTap: () {
                                      print(request);
                                    },
                                    child: Card(
                                      elevation: 3,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                        title: Text(
                                          "Loan request from : ${request['requested_by']['fullname']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Amount: ${request['amount']}"),
                                            Text(
                                                "Interest: ${request['interest']}"),
                                            Text(
                                                "Return Duration: ${(request['duration'])}"),
                                            request['accepted_at'] == null
                                                ? const SizedBox()
                                                : Text(
                                                    "Issued At: ${formattedDate(request['accepted_at'])}"),
                                            request['accepted_at'] == null
                                                ? const SizedBox()
                                                : Text(
                                                    "Rejected At: ${formattedDate(request['rejected_at'])}"),
                                            request['requested_at'] == null
                                                ? const SizedBox()
                                                : Text(
                                                    "Requested At: ${formattedDate(request['requested_at'])}"),
                                          ],
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.check),
                                              onPressed: () {
                                                _handleAccept(request['id']);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.clear),
                                              onPressed: () {
                                                _handleDeny(request['id']);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        );
                })
              : _selectedIndex == 1
                  ? Consumer<LoanManagementProvider>(
                      builder: (context, recordProvider, child) {
                      return recordProvider.getAcceptedLoanList == null ||
                              recordProvider.getAcceptedLoanList.isEmpty
                          ? const Center(
                              child: Text(
                                'No accepted loan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: recordProvider.getAcceptedLoanList
                                  .map<Widget>(
                                    (request) => InkWell(
                                      onTap: () {},
                                      child: Card(
                                        elevation: 3,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(16),
                                          title: Text(
                                            "Loan to : ${request['requested_by']['fullname']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Loan amount: ${request['amount'].toString()}"),
                                              Text(
                                                  "Interest: ${request['interest'].toString()}"),
                                              Text(
                                                  "Return Duration: ${(request['duration'].toString())}"),
                                              request['accepted_at'] == null
                                                  ? const SizedBox()
                                                  : Text(
                                                      "Accepted At: ${formattedDate(request['accepted_at'])}"),
                                              request['rejected_at'] == null
                                                  ? const SizedBox()
                                                  : Text(
                                                      "Rejected At: ${formattedDate(request['rejected_at'])}"),
                                              request['requested_at'] == null
                                                  ? const SizedBox()
                                                  : Text(
                                                      "Requested At: ${formattedDate(request['requested_at'])}"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                    })
                  : Container() // Placeholder for other content
        ],
      ),
    );
  }

  Future<void> _handleAccept(String id) async {
    var pref = SharedPreferencesManager();
    var userId = jsonDecode(await pref.getString(AppConstants.user))['id'];
    var data = {
      "id": id,
      "user": userId,
      "status_to": "ACCEPTED",
    };
    bool result =
        await Provider.of<LoanManagementProvider>(context, listen: false)
            .changeStatus(context, data);
    print("Accept :: $result");
    if (result) {
      ShowMToast(context).successToast(
          message: "Loan was Approved", alignment: Alignment.center);
      print("Status Changed");
    } else {
      print("Insufficient Funds");
      ShowMToast(context).errorToast(
          message: "Insufficient Funds can proceed loan}",
          alignment: Alignment.center);
    }
  }

  Future<void> _handleDeny(String id) async {
    var pref = SharedPreferencesManager();
    var userId = jsonDecode(await pref.getString(AppConstants.user))['id'];
    var data = {
      "id": id,
      "user": userId,
      "status_to": "REJECTED",
    };
    bool result =
        await Provider.of<LoanManagementProvider>(context, listen: false)
            .changeStatus(context, data);
    if (result) {
      print("Status Changed");
    } else {}
  }
}
