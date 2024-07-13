import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/screen/sign_in/sign_in_screen.dart';

import '../../controller/auth_controller.dart';
import '../../utils/images.dart';
import '../home/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final _key = GlobalKey<FormState>();

  List<Map<String, dynamic>> studentYears = [
    {'label': 'Năm nhất', 'value': 1},
    {'label': 'Năm hai', 'value': 2},
    {'label': 'Năm ba', 'value': 3},
    {'label': 'Năm bốn', 'value': 4},
    {'label': 'Năm cuối', 'value': 5},
  ];
  int _studentYear = 1;
  String _gender = 'Nam';
  bool _visible = false;
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default to today's date
      firstDate: DateTime(1900), // Earliest date that can be picked
      lastDate: DateTime.now(), // Latest date that can be picked
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  final _showPass = false.obs;
  final _showConfirmPass = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GetBuilder<AuthController>(
                        builder: (controller) => Opacity(
                          opacity: controller.loading ? 0.3 : 1,
                          child: Container(
                            color: Colors.white,
                            child: Form(
                              key: _key,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(100, 56, 100, 20),
                                    color: Colors.white,
                                    child: Image.asset(Images.logo),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Đăng ký tài khoản",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          child: TextFormField(
                                            controller: _firstNameController,
                                            textInputAction: TextInputAction.next,
                                            validator: (value){
                                              if(value == null || value.isEmpty){
                                                return 'Tên không được để trống';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                                contentPadding:
                                                const EdgeInsets.only(left: 28),
                                                border: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        width: 1,
                                                        color:
                                                        Color.fromRGBO(244, 244, 244, 1)),
                                                    borderRadius: BorderRadius.circular(15)),
                                                hintText: "Tên",
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey)),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          child: TextFormField(
                                            controller: _lastNameController,
                                            textInputAction: TextInputAction.next,
                                            validator: (value){
                                              if(value == null || value.isEmpty){
                                                return 'Họ không được để trống';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                                contentPadding:
                                                const EdgeInsets.only(left: 28),
                                                border: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        width: 1,
                                                        color:
                                                        Color.fromRGBO(244, 244, 244, 1)),
                                                    borderRadius: BorderRadius.circular(15)),
                                                hintText: "Họ",
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey)),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          child: TextFormField(
                                            controller: _emailController,
                                            textInputAction: TextInputAction.next,
                                            validator: (value){
                                              if (value == null || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                                return 'Email không hợp lệ';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                                contentPadding:
                                                const EdgeInsets.only(left: 28),
                                                border: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        width: 1,
                                                        color:
                                                        Color.fromRGBO(244, 244, 244, 1)),
                                                    borderRadius: BorderRadius.circular(15)),
                                                hintText: "Email",
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey)),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          child: TextFormField(
                                            controller: _universityController,
                                            textInputAction: TextInputAction.next,
                                            validator: (value){
                                              if(value == null || value.isEmpty){
                                                return "Tên trường không được để trống";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                                contentPadding:
                                                const EdgeInsets.only(left: 28),
                                                border: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        width: 1,
                                                        color:
                                                        Color.fromRGBO(244, 244, 244, 1)),
                                                    borderRadius: BorderRadius.circular(15)),
                                                hintText: "Tên trường",
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey)),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          child: InputDecorator(
                                            decoration: const InputDecoration(
                                              labelText: 'Sinh viên năm thứ', // Nhãn cho DropdownButton
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                            ),
                                            child: DropdownButton<int>(
                                              value: _studentYear,
                                              items: studentYears.map((year) {
                                                return DropdownMenuItem<int>(
                                                  value: year['value'],
                                                  child: Text(year['label']),
                                                );
                                              }).toList(),
                                              onChanged: (int? newValue) {
                                                setState(() {
                                                  _studentYear = newValue!;
                                                });
                                              },
                                            )

                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          child: InputDecorator(
                                            decoration: const InputDecoration(
                                              labelText: 'Giới tính', // Nhãn cho DropdownButton
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                            ),
                                            child: DropdownButton<String>(
                                              value: _gender,
                                              items: const [
                                                DropdownMenuItem(
                                                    value: 'Nam',
                                                    child: Text('Nam')
                                                ),
                                                DropdownMenuItem(
                                                    value: 'Nữ',
                                                    child: Text('Nữ')
                                                ),
                                              ],
                                              onChanged: (String? value) {
                                                setState(()=>_gender = value!);
                                              },

                                            ),
                                          )
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          child: Row(
                                            children: [
                                              ElevatedButton(onPressed: ()=>_selectDate(context), child: const Text('Ngày sinh')),
                                              const SizedBox(width:50),
                                              _selectedDate == null ? const Text('') :
                                              Text('${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}')
                                            ],
                                          )
                                        ),
                                        Visibility(
                                            visible: _visible,
                                            child: const Text('Hãy chọn ngày sinh', style: TextStyle(color: Colors.red, fontSize: 12))),
                                        Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          child: TextFormField(
                                            controller: _usernameController,
                                            textInputAction: TextInputAction.next,
                                            validator: (value){
                                              if(value == null || value.isEmpty){
                                                return 'tên đăng nhập không được để trống ';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                                contentPadding:
                                                const EdgeInsets.only(left: 28),
                                                border: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        width: 1,
                                                        color:
                                                        Color.fromRGBO(244, 244, 244, 1)),
                                                    borderRadius: BorderRadius.circular(15)),
                                                hintText: "Tên đăng nhập",
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey)),
                                          ),
                                        ),


                                        Container(
                                            margin: const EdgeInsets.only(top: 20),
                                            child: Obx(
                                                  () => TextFormField(
                                                textInputAction: TextInputAction.done,
                                                obscureText: _showPass.value,
                                                controller: _passwordController,
                                                    validator: (value){
                                                      if(value == null || value.isEmpty){
                                                        return 'Mật khẩu không được để trống';
                                                      }
                                                      return null;
                                                    },
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                    const EdgeInsets.only(left: 28),
                                                    suffixIcon: IconButton(
                                                      onPressed: () {
                                                        _showPass.value = !_showPass.value;
                                                      },
                                                      icon: Icon(_showPass.value
                                                          ? Icons.visibility
                                                          : Icons.visibility_off),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          width: 1,
                                                          color: Color.fromRGBO(
                                                              244, 244, 244, 1)),
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                    hintText: "Mật khẩu",
                                                    hintStyle: const TextStyle(
                                                        color:
                                                        Colors.grey)),
                                              ),
                                            )),
                                        Container(
                                            margin: const EdgeInsets.only(top: 20),
                                            child: Obx(
                                                  () => TextFormField(
                                                textInputAction: TextInputAction.done,
                                                obscureText: _showConfirmPass.value,
                                                controller: _passwordConfirmController,
                                                validator: (value){
                                                  if(value == null || value.isEmpty){
                                                    return 'Mật khẩu không được để trống';
                                                  }
                                                  if(value != _passwordController.text){
                                                    return 'Mật khẩu xác thực phải giống mật khẩu';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                    const EdgeInsets.only(left: 28),
                                                    suffixIcon: IconButton(
                                                      onPressed: () {
                                                        _showConfirmPass.value = !_showConfirmPass.value;
                                                      },
                                                      icon: Icon(_showConfirmPass.value
                                                          ? Icons.visibility
                                                          : Icons.visibility_off),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          width: 1,
                                                          color: Color.fromRGBO(
                                                              244, 244, 244, 1)),
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                    hintText: "Xác thực mật khẩu",
                                                    hintStyle: const TextStyle(
                                                        color:
                                                        Colors.grey)),
                                              ),
                                            )),
                                        Container(
                                          margin: const EdgeInsets.only(top: 40, bottom: 40),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if(_selectedDate == null){
                                                setState(()=> _visible = true);
                                                // return;
                                              }
                                              if(_key.currentState!.validate() && _selectedDate != null){
                                                setState(()=> _visible = false);
                                                _signup();
                                              }
                                              // _login();
                                            },
                                            style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15)),
                                            ),
                                            child: Container(
                                              padding:
                                              const EdgeInsets.fromLTRB(40, 18, 40, 18),
                                              child: const Text("Đăng ký",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color.fromRGBO(
                                                          191, 252, 226, 1.0))),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text("Đã có tài khoản?", style: TextStyle(fontSize: 20)),
                                            TextButton(
                                                onPressed: ()=>
                                                  Get.to(const SignInScreen(),transition: Transition.size,duration: const Duration(milliseconds: 400),curve: Curves.easeIn ),
                                                child: const Text('Đăng nhập',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                                            )

                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ),
            Center(
                child: GetBuilder<AuthController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.loading,
                      child: const CircularProgressIndicator(),
                    );
                  },
                )
            )
          ],
        ));
  }

  _signup() {
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String email = _emailController.text;
      String universityName = _universityController.text;
      String username = _usernameController.text;
      String password = _passwordController.text;
      String gender = _gender;
      DateTime dob = _selectedDate!;
      int studentYear = _studentYear;

      Get.find<AuthController>().signup(firstName, lastName, email, universityName, gender, dob, studentYear, username, password).then((value) => {
        if (value == 200){
          Get.to(const SignInScreen(),transition: Transition.size,duration: const Duration(milliseconds: 500),curve: Curves.easeIn)
      }

        else if (value == 400)
          {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Tài khoản mật khẩu không chính xác")))
          }
        else
          {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Đã xảy ra lỗi xin vui lòng thử lại")))
          },
      });
    }
  }






