// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:loan_admin_app/providers/user_management_provider.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  TextEditingController _addressController = TextEditingController();

  var _selectedUser;
  // TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneNumberController.dispose();
    _fullnameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitUser() async {
    String email = _emailController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();
    String fullname = _fullnameController.text.trim();

    if (email.isNotEmpty && phoneNumber.isNotEmpty && fullname.isNotEmpty) {
      var data = {
        "email": email,
        "password": phoneNumber,
        "username": email,
        "fullname": fullname,
        "phone_number": phoneNumber,
        "usertype": "MEMBER"
      };
      bool result =
          await Provider.of<UserManagementProvider>(context, listen: false)
              .registerMember(context, data);
      if (result) {
        Navigator.pop(context);
      } else {}
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fullnameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Fullname',
                border: OutlineInputBorder(),
              ),
            ),

            // const SizedBox(height: 10),

            // Container(
            //   // padding:
            //   // EdgeInsets.only(left: 24, top: 16, right: 16),
            //   decoration: BoxDecoration(
            //       // border: Border(
            //       //   bottom: BorderSide(
            //       //     color: Colors.white,
            //       //     width: 1.2,
            //       //   ),
            //       // ),
            //       // borderRadius: BorderRadius.circular(12)
            //       ),
            //   child: DropdownButtonFormField<String>(
            //     value: _selectedUser,
            //     icon: const Icon(Icons.arrow_downward),
            //     decoration: const InputDecoration(
            //       focusedBorder: OutlineInputBorder(),
            //       focusColor: Colors.white,
            //       enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(12)),
            //         borderSide: BorderSide(
            //           color: Colors.white,
            //         ),
            //       ),
            //       labelText: 'User Type',
            //       labelStyle: TextStyle(
            //         color: Colors.white,
            //         fontSize: 12,
            //       ),
            //       border: OutlineInputBorder(
            //           // borderSide: BorderSide.
            //           borderRadius: BorderRadius.all(Radius.circular(12))),
            //     ),
            //     items: ['LEADER', 'MEMBER'].map((String value) {
            //       return DropdownMenuItem<String>(
            //         value: value,
            //         child: Text(value),
            //       );
            //     }).toList(),
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         _selectedUser = newValue;
            //       });
            //     },
            //   ),
            // ),
            // const SizedBox(height: 10),
            // TextField(
            //   controller: _addressController,
            //   decoration: const InputDecoration(
            //     labelText: 'Enter Address',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitUser,
              child: const Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}
