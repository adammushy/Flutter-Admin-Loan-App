import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loan_admin_app/providers/loan_management_provider.dart';
import 'package:loan_admin_app/providers/wallet_management_provider.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  void initState() {
    super.initState();
    Provider.of<WalletManagementProvider>(context, listen: false).getWallet();
    Provider.of<LoanManagementProvider>(context, listen: false)
        .getAcceptLoanList();
    // fetchWaller();
  }

  void fetchWaller() async {
    await Provider.of<WalletManagementProvider>(context, listen: false)
        .getWallet();
  }

  @override
  Widget build(BuildContext context) {
    var walletData =
        Provider.of<WalletManagementProvider>(context, listen: true).wallet;
    var mikopo = Provider.of<LoanManagementProvider>(context, listen: true)
        .getAcceptedLoanList;
    // print("MIkopo ${mikopo ?? '0'}");
    // Handle the case where walletData might be null
    String walletAmount = walletData != null && walletData.containsKey('amount')
        ? walletData['amount'].toString()
        : "0";

    // Calculate the total remaining amount for accepted loans
    int totalMikopoRemain = 0;
    if (mikopo != null) {
      for (var loan in mikopo) {
        totalMikopoRemain += (loan['amount_remain'] as num).toInt();
      }
    }
    List<Map<String, dynamic>> categories = [
      {
        "icon": "assets/icons/Cash.svg",
        "text": "Fedha Zote",
        "amount": "Tsh1,000,000",
        "color": Colors.greenAccent, // Green color for this category
      },
      {
        "icon": "assets/icons/Cash.svg",
        "text": "Mikopo Yote",
        "amount": "Tsh230,400",
        "color": const Color(0xFFFFECDF), // Default color for other categories
      },
    ];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: CategoryCard(
                  icon: categories[0]["icon"],
                  text: categories[0]["text"],
                  amount: walletData['amount'].toString() ?? "0",
                  backgroundColor: categories[0]["color"],
                  press: () {},
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: CategoryCard(
                  icon: categories[1]["icon"],
                  text: categories[1]["text"],
                  // amount: categories[1]["amount"],
                  amount: totalMikopoRemain.toString(),
                  backgroundColor: categories[1]["color"],
                  press: () {},
                ),
              ),
            ),
          ]),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.amount,
    required this.backgroundColor,
    required this.press,
  }) : super(key: key);

  final String icon, text, amount;
  final Color backgroundColor;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 56,
            width: 180,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(icon),
                const SizedBox(
                    width: 8), // Adjust spacing between icon and text
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  backgroundColor == Colors.green ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
