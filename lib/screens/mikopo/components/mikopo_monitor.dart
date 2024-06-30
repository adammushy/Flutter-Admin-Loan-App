// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_admin_app/constants/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:loan_admin_app/providers/loan_management_provider.dart';

class MonitorLoanPage extends StatefulWidget {
  const MonitorLoanPage({super.key});

  @override
  State<MonitorLoanPage> createState() => _MonitorLoanPageState();
}

class _MonitorLoanPageState extends State<MonitorLoanPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<LoanManagementProvider>(context, listen: false)
        .getUnpaidLoanList();
  }

  String formattedDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat formatter = DateFormat.yMMMMd('en_US').add_jms();
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor Loans'),
      ),
      body: Consumer<LoanManagementProvider>(
        builder: (context, loanProvider, child) {
          if (loanProvider.loanRemaining == null ||
              loanProvider.loanRemaining.isEmpty) {
            return Center(
              child: Text(
                'No loans with remaining amount',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            itemCount: loanProvider.loanRemaining.length,
            itemBuilder: (context, index) {
              final loan = loanProvider.loanRemaining[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    "Loan to : ${loan['requested_by']['fullname']}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Loan amount: ${loan['amount'].toString()}"),
                      Text(
                          "Remaining amount: ${loan['amount_remain'].toString()}"),
                      Text("Interest: ${loan['interest'].toString()}"),
                      Text("Return Duration: ${(loan['duration'].toString())}"),
                      loan['accepted_at'] == null
                          ? const SizedBox()
                          : Text(
                              "Accepted At: ${formattedDate(loan['accepted_at'])}"),
                      loan['rejected_at'] == null
                          ? const SizedBox()
                          : Text(
                              "Rejected At: ${formattedDate(loan['rejected_at'])}"),
                      loan['requested_at'] == null
                          ? const SizedBox()
                          : Text(
                              "Requested At: ${formattedDate(loan['requested_at'])}"),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      var data = {"id": loan['id']};
                      var result =
                          await Provider.of<LoanManagementProvider>(context,listen: false)
                              .reminderSms(context, data);
                      if (result) {
                        ShowMToast(context).successToast(
                            message: "Sent successfully",
                            alignment: Alignment.center);
                      } else {
                        ShowMToast(context).errorToast(
                            message: "Failed", alignment: Alignment.center);
                      }
                    },
                    icon: Icon(Icons.add_alert_outlined),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
