import 'package:flutter/material.dart';

import '/_services/auth_service.dart';
import '/constants/image_constants.dart';
import '/domains/gender.dart';
import '/domains/inbound/register_dto_in.dart';
import '/ui/ErrorMessage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  String? _gender;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      RegisterDtoIn regDtoIn = RegisterDtoIn(
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _mobileController.text,
        gender: Gender.values.byName(_gender!),
        password: _passwordController.text,
      );

      AuthService().register(regDtoIn).then((res) {
        Navigator.pushReplacementNamed(context, '/dashboard', arguments: res);
      }).onError((error, stackTrace) => showErrorMessage(context, error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (constraints.maxWidth > 600) {
                    // Wide layout
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(ImageConstant
                                .mainCharacter), // Replace with your image
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Center(
                            child: Card(
                              elevation: 4.0,
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: SizedBox(
                                  width: 350,
                                  child: Column(
                                    children: getWidgets(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Narrow layout
                    return Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxWidth: 100, maxHeight: 100),
                          child: Image.asset(ImageConstant.logo),
                        ),
                        ...getWidgets(),
                      ]),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getWidgets() {
    return [
      _buildTextField(_firstNameController, 'First Name'),
      _buildTextField(_lastNameController, 'Last Name'),
      _buildTextField(_emailController, 'Email'),
      _buildTextField(_mobileController, 'Mobile No.'),
      _buildGenderDropdown(),
      _buildPasswordTextField(_passwordController, 'Password'),
      _buildPasswordTextField(_repeatPasswordController, 'Repeat Password'),
      const SizedBox(height: 32.0),
      ElevatedButton(
        onPressed: _submit,
        child: const Text('Register'),
      ),
      const SizedBox(
        height: 8.0,
      ),
      TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/login');
        },
        child: const Text('Already have an account? Login'),
      ),
    ];
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordTextField(
      TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        obscureText: _obscurePassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Gender'),
        value: _gender,
        onChanged: (value) {
          setState(() {
            _gender = value;
          });
        },
        items: const [
          DropdownMenuItem(value: 'Male', child: Text('Male')),
          DropdownMenuItem(value: 'Female', child: Text('Female')),
          DropdownMenuItem(value: 'Other', child: Text('Other')),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select gender';
          }
          return null;
        },
      ),
    );
  }
}
