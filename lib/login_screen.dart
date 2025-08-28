import 'package:flutter/material.dart';
import 'package:multi_role_base_app/home_screen.dart';
import 'package:multi_role_base_app/student_screen.dart';
import 'package:multi_role_base_app/teacher_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final ageController = TextEditingController();

  String? selectedRole;
  final List<DropdownMenuItem<String>> items = [
    DropdownMenuItem(value: 'Admin', child: Text('Admin')),
    DropdownMenuItem(value: 'Student', child: Text('Student')),
    DropdownMenuItem(value: 'Teacher', child: Text('Teacher')),
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedRole();
  }

  _loadSavedRole() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      selectedRole = sp.getString('userType');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black)
                ),
                prefixIcon: Icon(Icons.email),
                filled: true,
                fillColor: Colors.grey[350],
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              obscuringCharacter: '*',
              controller: passController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black)
                ),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: Icon(Icons.visibility_off_outlined),
                filled: true,
                fillColor: Colors.grey[350],
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black)
                ),
                prefixIcon: Icon(Icons.person),
                filled: true,
                fillColor: Colors.grey[350],
                hintText: 'Age',
              ),
            ),
            SizedBox(height: 20),

            // Dropdown Menu for Role Selection
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[350],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedRole,
                  items: items,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRole = newValue;
                    });
                  },
                  hint: Text('Select Role'),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                ),
              ),
            ),
            SizedBox(height: 40),

            // Login Button
            InkWell(
              onTap: () async {
                if (selectedRole == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a role')),
                  );
                  return;
                }

                SharedPreferences sp = await SharedPreferences.getInstance();

                sp.setString('email', emailController.text.toString());
                sp.setString('age', ageController.text.toString());
                sp.setBool('isLogin', true);
                sp.setString('userType', selectedRole!);

                // Navigate based on selected role
                if (sp.getString('userType') == 'Student') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudentScreen()),
                  );
                } else if (sp.getString('userType') == 'Teacher') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TeacherScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}