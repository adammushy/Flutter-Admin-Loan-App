// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_admin_app/providers/wallet_management_provider.dart';
import 'package:provider/provider.dart';
// import '../../../models/Deposits.dart';

class RecentDepositsWidget extends StatefulWidget {
  const RecentDepositsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<RecentDepositsWidget> createState() => _RecentDepositsWidgetState();
}

class _RecentDepositsWidgetState extends State<RecentDepositsWidget> {
  @override
  void initState() {
    super.initState();
    Provider.of<WalletManagementProvider>(context, listen: false)
        .getWalletDepositList();
  }

  String dateTimeFormat(originalDatetimeStr) {
    // Parse the original datetime string to a DateTime object
    DateTime originalDatetime = DateTime.parse(originalDatetimeStr);

    // Format the DateTime object to show only date, hour, and minute
    String formattedDatetimeStr =
        DateFormat('yyyy-MM-dd HH:mm').format(originalDatetime);

    // print(formattedDatetimeStr);
    return formattedDatetimeStr; // Output: 2024-06-10 01:45
  }

  @override
  Widget build(BuildContext context) {
    var demoDeposits =
        Provider.of<WalletManagementProvider>(context, listen: true)
            .depositwalletlist;
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: demoDeposits.length > 5
          ? 5
          : demoDeposits.length, // Limit to 3 deposits
      itemBuilder: (context, index) {
        final deposit = demoDeposits[index];
        return GestureDetector(
          onTap: () {
            // _showDepositHistory(context, deposit);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100],
              ),
              child: ListTile(
                leading: Icon(
                    // deposit.isSuccess ? Icons.check_circle : Icons.error,
                    // color: deposit.isSuccess ? Colors.green : Colors.red,
                    Icons.check_circle),
                title: Text("Depositer Name: ${deposit['wallet']['user']['username']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Amount: ${deposit['amount']}"),
                    Text(
                        "Wallet ID: ${deposit['wallet']['id'] ?? 'username'}"),
                    Text(
                        "Date: ${dateTimeFormat(deposit['created_at']) ?? 'date payed'}"),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // void _showDepositHistory(BuildContext context, Deposits deposit) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Deposit History"),
  //         content: Text(deposit.history),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text("Close"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
