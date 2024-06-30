import 'package:flutter/material.dart';
import 'package:loan_admin_app/providers/user_management_provider.dart';
import 'package:provider/provider.dart';
import '../sign_in/sign_in_screen.dart';
import 'components/profile_header.dart';
import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData;
  setUserData() {
    var data =
        Provider.of<UserManagementProvider>(context, listen: false).getUserData;
    setState(() {
      userData = data;
    });
  }
  @override
  void initState() {
    super.initState();
    setUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            ProfileHeader(),
            const SizedBox(height: 40),
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () {
                // Navigator.pushNamed(context, MyAccountScreen.routeName);
              },
            ),
            ProfileMenu(
              text: userData['email'],
              icon: "assets/icons/Bell.svg",
              press: () {},
            ),
            ProfileMenu(
              text: userData['usertype'],
              icon: "assets/icons/Settings.svg",
              press: () {},
            ),
            ProfileMenu(
              text: userData['phone_number'],
              icon: "assets/icons/Question mark.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SignInScreen.routeName,
                      (route) => false, 
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
