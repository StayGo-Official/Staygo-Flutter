// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:staygo/loginpage.dart';
import 'package:staygo/models.dart';
import 'package:staygo/repository.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _noHpController = TextEditingController();
  final _alamatController = TextEditingController();
  final _ttlController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confPasswordController = TextEditingController();
  final CustomerRepository _repository = CustomerRepository();

  void _registerCustomer() async {
    if (_formKey.currentState!.validate()) {
      final customer = CustomerRegistration(
        username: _usernameController.text,
        nama: _namaController.text,
        email: _emailController.text,
        noHp: _noHpController.text,
        alamat: _alamatController.text,
        ttl: _ttlController.text,
        password: _passwordController.text,
        confPassword: _confPasswordController.text,
      );

      try {
        final response = await _repository.registerCustomer(customer);
        if (response['msg'] == 'Register Berhasil') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration Successful')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response['msg']}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        _ttlController.text =
            "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
      });
    }
  }

  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/gambar-register.png',
                    height: 200,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outlined,
                          color: Colors.grey,
                        ), // Icon "@"
                        SizedBox(
                            width: 10), // Padding antara icon dan TextField
                        Expanded(
                          child: TextFormField(
                            controller: _usernameController,
                            validator: (value) =>
                                value!.isEmpty ? 'Enter username' : null,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              hintText: 'Username',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outlined,
                          color: Colors.grey,
                        ), // Icon "@"
                        SizedBox(
                            width: 10), // Padding antara icon dan TextField
                        Expanded(
                          child: TextFormField(
                            controller: _namaController,
                            validator: (value) =>
                                value!.isEmpty ? 'Enter Name' : null,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              hintText: 'Nama Lengkap',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Icon(Icons.alternate_email,
                            color: Colors.grey), // Icon "@"
                        SizedBox(
                            width: 10), // Padding antara icon dan TextField
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            validator: (value) =>
                                value!.isEmpty || !value.contains('@')
                                    ? 'Enter valid email'
                                    : null,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              hintText: 'Email ID',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Icon(Icons.contact_phone_outlined,
                            color: Colors.grey), // Icon "@"
                        SizedBox(
                            width: 10), // Padding antara icon dan TextField
                        Expanded(
                          child: TextFormField(
                            controller: _noHpController,
                            validator: (value) =>
                                value!.isEmpty ? 'Enter phone number' : null,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              hintText: 'No Handphone',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey,
                        ), // Icon "@"
                        SizedBox(
                            width: 10), // Padding antara icon dan TextField
                        Expanded(
                          child: TextFormField(
                            controller: _alamatController,
                            validator: (value) =>
                                value!.isEmpty ? 'Enter address' : null,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              hintText: 'Alamat',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.grey,
                        ), // Icon "@"
                        SizedBox(
                            width: 10), // Padding antara icon dan TextField
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: IgnorePointer(
                              child: TextFormField(
                                controller: _ttlController,
                                validator: (value) => value!.isEmpty ? 'Enter Birthday' : null,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  hintText: 'Tanggal Lahir',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  // Password with "locked" Icon
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Icon(Icons.lock_clock_outlined,
                            color: Colors.grey), // Icon "locked"
                        SizedBox(
                            width: 10), // Padding antara icon dan TextField
                        Expanded(
                          child: TextFormField(
                            controller: _passwordController,
                            validator: (value) =>
                                value!.isEmpty ? 'Enter password' : null,
                            obscureText:
                                _isObscurePassword, // Atur apakah password disembunyikan atau tidak
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              hintText: 'Password',

                              // Ikon mata di sebelah kanan untuk menampilkan atau menyembunyikan password
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscurePassword =
                                        !_isObscurePassword; // Mengubah status _isObscure ketika ikon ditekan
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Icon(Icons.lock_clock_outlined,
                            color: Colors.grey), // Icon "locked"
                        SizedBox(
                            width: 10), // Padding antara icon dan TextField
                        Expanded(
                          child: TextFormField(
                            controller: _confPasswordController,
                            validator: (value) =>
                                value != _passwordController.text
                                    ? 'Passwords do not match'
                                    : null,
                            obscureText:
                                _isObscureConfirmPassword, // Atur apakah password disembunyikan atau tidak
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              hintText: 'Konfirmasi Password',

                              // Ikon mata di sebelah kanan untuk menampilkan atau menyembunyikan password
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscureConfirmPassword =
                                        !_isObscureConfirmPassword; // Mengubah status _isObscureConfirmPassword ketika ikon ditekan
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey, // Warna default untuk teks
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'dengan mendaftar, Anda menyetujui ', // Teks biasa
                              style: TextStyle(
                                  color: Colors.grey), // Warna untuk teks biasa
                            ),
                            TextSpan(
                              text:
                                  'Syarat & Ketentuan', // Teks dengan warna berbeda
                              style: TextStyle(
                                color: Color(
                                    0xFF47B5FF), // Ganti warna sesuai kebutuhan
                                fontWeight:
                                    FontWeight.bold, // Optional: Gaya huruf
                              ),
                            ),
                            TextSpan(
                              text: ' dan ', // Teks biasa
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text:
                                  'Kebijakan Privasi', // Teks dengan warna berbeda
                              style: TextStyle(
                                color: Color(
                                    0xFF47B5FF), // Ganti warna sesuai kebutuhan
                                fontWeight:
                                    FontWeight.bold, // Optional: Gaya huruf
                              ),
                            ),
                            TextSpan(
                              text: ' Kami', // Teks biasa
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: _registerCustomer,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0xFF06283D),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            'Daftar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginPage();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Masuk',
                          style: TextStyle(
                            color: Color(0xFF47B5FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
