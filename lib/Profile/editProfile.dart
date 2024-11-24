// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staygo/repository.dart';
import 'package:staygo/constants.dart';

class EditProfile extends StatefulWidget {
  final String username;
  final String nama;
  final String email;
  final String noHp;
  final String alamat;
  final String ttl;
  final String image;
  final String accessToken;
  final int customerId;
  final Function(Map<String, dynamic>) onProfileUpdated;

  const EditProfile({
    Key? key,
    required this.username,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.alamat,
    required this.ttl,
    required this.image,
    required this.accessToken,
    required this.customerId,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final CustomerRepository _repository = CustomerRepository();

  // Kontroller untuk form
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateController = TextEditingController();

  File? _image; // Variabel untuk menyimpan gambar yang dipilih
  final _picker = ImagePicker(); // Inisialisasi ImagePicker
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        _dateController.text =
            "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
      });
    }
  }

  Future<void> _getImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected');
    }
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return false;
    }
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email tidak valid')),
      );
      return false;
    }
    if (_phoneController.text.isEmpty || _phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nomor HP tidak valid')),
      );
      return false;
    }
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alamat tidak boleh kosong')),
      );
      return false;
    }
    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tanggal lahir tidak boleh kosong')),
      );
      return false;
    }
    return true;
  }

  Future<void> _saveProfile() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    final profileData = {
      'nama': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'noHp': _phoneController.text.trim(),
      'alamat': _addressController.text.trim(),
      'ttl': _dateController.text.trim(),
    };

    final response = await _repository.updateCustomerProfile(
      accessToken: widget.accessToken,
      customerId: widget.customerId,
      profileData: profileData,
      imageFile: _image,
    );

    if (response['status']) {
      final updatedImagePath = response['imagePath'];
      final updatedProfile = {
        ...profileData,
        'image': updatedImagePath,
      };

      widget.onProfileUpdated(updatedProfile);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
      Navigator.pop(context); // Navigate back to profile page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Update failed')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  String? updatedImage;

  @override
  void initState() {
    super.initState();

    // Inisialisasi data awal
    _nameController.text = widget.nama;
    _emailController.text = widget.email;
    _phoneController.text = widget.noHp;
    _addressController.text = widget.alamat;
    _dateController.text = widget.ttl;
    updatedImage =
        widget.image; // Pastikan updatedImage dimuat dari widget.image
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8), // Margin to add space around the button
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white, // Background color of the circle
          ),
          child: Transform.translate(
            offset: Offset(4, 0), // Shift to the right by 4 pixels
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _getImage, // Aksi ketika gambar diklik
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(_image!) // Jika ada file gambar yang dipilih
                      : (updatedImage != null && updatedImage!.isNotEmpty
                          ? (updatedImage!.contains(AppConstants.baseUrlImage)
                              ? NetworkImage(updatedImage!) // URL lengkap
                              : NetworkImage(
                                  '${AppConstants.baseUrlImage}$updatedImage')) // Tambahkan base URL jika belum lengkap
                          : AssetImage('assets/profile.png')) as ImageProvider,
                  child: _image == null
                      ? Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),

              // Email with "@" Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outlined,
                      color: Colors.grey,
                    ), // Icon "@"
                    SizedBox(width: 10), // Padding antara icon dan TextField
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                          ),
                          hintText: 'Nama',
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
                    SizedBox(width: 10), // Padding antara icon dan TextField
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
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
                    Icon(Icons.alternate_email, color: Colors.grey), // Icon "@"
                    SizedBox(width: 10), // Padding antara icon dan TextField
                    Expanded(
                      child: TextField(
                        controller: _emailController,
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

              // Password with "locked" Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Icon(Icons.location_city,
                        color: Colors.grey), // Icon "locked"
                    SizedBox(width: 10), // Padding antara icon dan TextField
                    Expanded(
                      child: TextField(
                        controller: _addressController,
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
                    Icon(Icons.calendar_month,
                        color: Colors.grey), // Icon "locked"
                    SizedBox(width: 10), // Padding antara icon dan TextField
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: IgnorePointer(
                          child: TextField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
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
                height: 155,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: _isLoading ? null : _saveProfile,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xFF06283D),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Simpan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
