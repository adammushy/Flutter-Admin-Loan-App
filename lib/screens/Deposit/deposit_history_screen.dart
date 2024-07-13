// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_admin_app/constants/snackbar.dart';
import 'package:loan_admin_app/providers/wallet_management_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import '../../models/Deposits.dart'; // Import the Deposits class and demoDeposits list

class DepositHistoryScreen extends StatefulWidget {
  const DepositHistoryScreen({Key? key}) : super(key: key);

  static String routeName = "/deposit";

  @override
  State<DepositHistoryScreen> createState() => _DepositHistoryScreenState();
}

class _DepositHistoryScreenState extends State<DepositHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<WalletManagementProvider>(context, listen: false)
        .getWalletDepositList();
    requestStoragePermission();
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

  Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      // status = await Permission.accessMediaLocation.request();
      // status = await Permission.storage.request();
      // st = await Permission.storage.request();
      status = await Permission.manageExternalStorage.request();
    }
    return status.isGranted;
  }

  Future<void> generateAndSavePdf() async {
    final pdf = pw.Document();
    var demoDeposits =
        Provider.of<WalletManagementProvider>(context, listen: false)
            .depositwalletlist;
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table.fromTextArray(
            headers: ['Depositor name', 'Amount', 'Account Number', 'Date'],
            data: demoDeposits.map<List<dynamic>>((deposit) {
              return [
                deposit['wallet']['user']['username'],
                deposit['amount'],
                deposit['wallet']['id'],
                dateTimeFormat(deposit['created_at']),
              ];
            }).toList(),
          );
        },
      ),
    );

    try {
      // Request permission if not granted
      bool isPermissionGranted = await requestStoragePermission();
      if (!isPermissionGranted) {
        throw Exception("Permission denied for storage.");
      }

      // Get external storage directory
      Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception("Unable to access external storage directory.");
      }

      // Create kikoba directory under external storage
      final kikobaDir = Directory('${directory.path}/kikoba');
      if (!await kikobaDir.exists()) {
        await kikobaDir.create(recursive: true);
      }

      // Generate file name based on current timestamp
      final file = File(
          '${kikobaDir.path}/walletdeposits_${DateTime.now().toIso8601String()}.pdf');

      // Save PDF to file
      await file.writeAsBytes(await pdf.save());
      print("PDF saved successfully at ${file.path}");
      ShowMToast(context).successToast(
          message: "PDF saved successfully at ${file.path}",
          alignment: Alignment.bottomCenter);
    } catch (e) {
      ShowMToast(context).errorToast(
          message: "Error saving PDF: $e", alignment: Alignment.bottomCenter);
      print("Error saving PDF: $e");
    }

    // try {
    //   final path = Directory('/storage/emulated/0/kikoba');

    //   // Create the directory if it doesn't exist
    //   if (!await path.exists()) {
    //     await path.create(recursive: true);
    //   }

    //   final file = File('${path.path}/all_deposits_${DateTime.now()}.pdf');
    //   await file.writeAsBytes(await pdf.save());
    //   print("PDF saved successfully at ${file.path}");
    //   ShowMToast(context).successToast(
    //       message: "PDF saved successfully at ${file.path}",
    //       alignment: Alignment.bottomCenter);
    // } catch (e) {
    //   ShowMToast(context).errorToast(
    //       message: "Error saving PDF: $e", alignment: Alignment.bottomCenter);
    //   print("Error saving PDF: $e");
    // }
  }

  Future<void> _handlePdfGeneration() async {
    bool isPermissionGranted = await requestStoragePermission();
    if (isPermissionGranted) {
      await generateAndSavePdf();
    } else {
      print("Storage permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    var demoDeposits =
        Provider.of<WalletManagementProvider>(context, listen: true)
            .depositwalletlist;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Deposit History",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: ListView.builder(
        itemCount: demoDeposits.length,
        itemBuilder: (context, index) {
          final deposit = demoDeposits[index];
          return Card(
            child: ListTile(
              leading: Icon(
                  // deposit.isSuccess ? Icons.check_circle : Icons.error,
                  // color: deposit.isSuccess ? Colors.green : Colors.red,
                  Icons.check_circle,
                  color: Colors.green),
              title: Text("Amount: ${deposit['wallet']['user']['username']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Amount: ${deposit['amount']}"),
                  Text("Wallet ID: ${deposit['wallet']['id']}"),
                  Text("Date: ${dateTimeFormat(deposit['created_at'])}"),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          _handlePdfGeneration();
        },
        icon: Icon(Icons.download_rounded),
      ),
    );
  }
}
