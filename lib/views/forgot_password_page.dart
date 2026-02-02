import 'package:flutter/material.dart';

import '../di/injection.dart';
import '../viewmodels/forgot_password_viewmodel.dart';
import '../widgets/app_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _reEnterController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureReEnter = true;
  bool _isSubmitting = false;

  late ForgotPasswordViewModel _viewModel;

  static const _minLength = 8;
  static const _labelStyle = TextStyle(
    fontFamily: 'Source Sans 3',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Color(0xFF6B6B6B),
  );

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<ForgotPasswordViewModel>();
    for (final c in [_currentController, _newController, _reEnterController]) {
      c.addListener(_onFormChanged);
    }
  }

  void _onFormChanged() => setState(() {});

  bool get _formValid {
    final cur = _currentController.text;
    final neu = _newController.text;
    final re = _reEnterController.text;
    if (cur.length < _minLength || neu.length < _minLength || re.length < _minLength) {
      return false;
    }
    if (neu != re) return false;
    if (cur == neu) return false;
    return true;
  }

  @override
  void dispose() {
    for (final c in [_currentController, _newController, _reEnterController]) {
      c.removeListener(_onFormChanged);
    }
    _currentController.dispose();
    _newController.dispose();
    _reEnterController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    final ok = await _viewModel.changePassword(
      current: _currentController.text,
      newPassword: _newController.text,
      reEnter: _reEnterController.text,
    );
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password change request submitted.'),
          backgroundColor: Color(0xFF08306D),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  child: _buildForm(context),
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
            'Forgot password',
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

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
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
                const SizedBox(height: 8),
                _buildPasswordField(
                  controller: _currentController,
                  label: 'Current password',
                  obscure: _obscureCurrent,
                  onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
                  validator: _validateCurrent,
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  controller: _newController,
                  label: 'New password',
                  obscure: _obscureNew,
                  onToggle: () => setState(() => _obscureNew = !_obscureNew),
                  validator: _validateNew,
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  controller: _reEnterController,
                  label: 'Re-enter new password',
                  obscure: _obscureReEnter,
                  onToggle: () => setState(() => _obscureReEnter = !_obscureReEnter),
                  validator: _validateReEnter,
                ),
                const SizedBox(height: 28),
                AppButton(
                  text: 'Change password',
                  enabled: _formValid,
                  isLoading: _isSubmitting,
                  onPressed: _handleChangePassword,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.46),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: _labelStyle,
        border: const UnderlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF6B6B6B),
            size: 22,
          ),
          onPressed: onToggle,
        ),
      ),
      validator: validator,
    );
  }

  String? _validateCurrent(String? value) {
    if (value == null || value.isEmpty) return 'Please enter current password';
    if (value.length < _minLength) return 'Password must be at least $_minLength characters';
    return null;
  }

  String? _validateNew(String? value) {
    if (value == null || value.isEmpty) return 'Please enter new password';
    if (value.length < _minLength) return 'Password must be at least $_minLength characters';
    if (_currentController.text.isNotEmpty && value == _currentController.text) {
      return 'New password must be different from current password';
    }
    return null;
  }

  String? _validateReEnter(String? value) {
    if (value == null || value.isEmpty) return 'Please re-enter new password';
    if (value.length < _minLength) return 'Password must be at least $_minLength characters';
    if (value != _newController.text) return 'Re-enter password must match new password';
    return null;
  }
}
