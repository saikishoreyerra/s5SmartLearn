import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/user.dart';
import '../widgets/app_button.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _fatherController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _institutionController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _bloodGroupController = TextEditingController();

  final Map<String, bool> _locked = {
    'name': true,
    'email': true,
    'father': true,
    'dob': true,
    'address': true,
    'institution': true,
    'studentId': true,
    'bloodGroup': true,
  };

  static const _labelStyle = TextStyle(
    fontFamily: 'Source Sans 3',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Color(0xFF6B6B6B),
  );

  @override
  void initState() {
    super.initState();
    _fillFromUser();
  }

  void _fillFromUser() {
    final u = widget.user;
    _nameController.text = '${u.fnm} ${u.lnm}'.trim();
    _emailController.text = u.email;
    _fatherController.text = u.fatherNm;
    _dobController.text = u.dob;
    _addressController.text = u.add;
    _institutionController.text = u.insName;
    _studentIdController.text = u.stuId;
    _bloodGroupController.text = u.bgrp;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _fatherController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _institutionController.dispose();
    _studentIdController.dispose();
    _bloodGroupController.dispose();
    super.dispose();
  }

  void _toggleLock(String key) {
    setState(() => _locked[key] = !(_locked[key] ?? true));
  }

  void _handleDone() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated.'),
        backgroundColor: Color(0xFF08306D),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.user;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF526E98), Color(0xFF08306D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFormSection(context, u),
                      const SizedBox(height: 24),
                      _buildDoneButton(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 16, 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          const SizedBox(width: 8),
          Text(
            'My profile',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: 'Source Sans 3',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ) ??
                const TextStyle(
                  fontFamily: 'Source Sans 3',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context, User u) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileSection(u),
            const SizedBox(height: 20),
            _buildFieldRow(
              left: _profileField(controller: _nameController, label: 'Name', lockKey: 'name'),
              right: _profileField(controller: _emailController, label: 'Email', lockKey: 'email'),
            ),
            const SizedBox(height: 16),
            _buildFieldRow(
              left: _profileField(controller: _fatherController, label: 'Father\'s name', lockKey: 'father'),
              right: _profileField(controller: _dobController, label: 'Date of birth', lockKey: 'dob'),
            ),
            const SizedBox(height: 16),
            _buildFieldRow(
              left: _profileField(controller: _addressController, label: 'Address', lockKey: 'address'),
              right: _profileField(controller: _institutionController, label: 'Institution', lockKey: 'institution'),
            ),
            const SizedBox(height: 16),
            _buildFieldRow(
              left: _profileField(controller: _studentIdController, label: 'Student ID', lockKey: 'studentId'),
              right: _profileField(controller: _bloodGroupController, label: 'Blood group', lockKey: 'bloodGroup'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(User u) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFE8ECF2),
            child: Icon(Icons.person, color: Colors.grey.shade600, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${u.fnm} ${u.lnm}'.trim(),
                  style: const TextStyle(
                    fontFamily: 'Source Sans 3',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${u.insName}  •  Roll no: ${u.stuId}',
                  style: const TextStyle(
                    fontFamily: 'Source Sans 3',
                    fontSize: 13,
                    color: Color(0xFF6B6B6B),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/icons/ic_camera.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Color(0xFF08306D), BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldRow({required Widget left, required Widget right}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }

  Widget _profileField({
    required TextEditingController controller,
    required String label,
    required String lockKey,
  }) {
    final isLocked = _locked[lockKey] ?? true;
    return TextFormField(
      controller: controller,
      readOnly: isLocked,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: _labelStyle,
        border: const UnderlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: () => _toggleLock(lockKey),
          icon: SvgPicture.asset(
            'assets/icons/ic_lock.svg',
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              isLocked ? const Color(0xFF6B6B6B) : const Color(0xFF08306D),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      validator: (_) => null,
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppButton(
        text: 'Done',
        onPressed: _handleDone,
      ),
    );
  }
}
