import 'package:flutter/material.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  bool _hidePass = true;
  bool _hideConfirm = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created successfully')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title(),
                    const SizedBox(height: 32),

                    _animatedField(0, _field(
                      label: 'Full Name',
                      controller: _nameCtrl,
                      validator: (v) =>
                      v!.isEmpty ? 'Name required' : null,
                    )),

                    _animatedField(1, _field(
                      label: 'Email',
                      controller: _emailCtrl,
                      keyboard: TextInputType.emailAddress,
                      validator: (v) {
                        if (v!.isEmpty) return 'Email required';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    )),

                    _animatedField(2, _field(
                      label: 'Password',
                      controller: _passCtrl,
                      obscure: _hidePass,
                      suffix: _eye(() {
                        setState(() => _hidePass = !_hidePass);
                      }, _hidePass),
                      validator: (v) =>
                      v!.length < 6 ? 'Min 6 characters' : null,
                    )),

                    _animatedField(3, _field(
                      label: 'Confirm Password',
                      controller: _confirmCtrl,
                      obscure: _hideConfirm,
                      suffix: _eye(() {
                        setState(() => _hideConfirm = !_hideConfirm);
                      }, _hideConfirm),
                      validator: (v) =>
                      v != _passCtrl.text ? 'Passwords do not match' : null,
                    )),

                    _animatedField(4, _field(
                      label: 'Phone Number',
                      controller: _phoneCtrl,
                      keyboard: TextInputType.phone,
                      validator: (v) =>
                      v!.length < 10 ? 'Invalid phone number' : null,
                    )),

                    const SizedBox(height: 28),

                    _animatedField(5, _button()),

                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _animatedField(int index, Widget child) {
    final delay = index * 0.1;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
    );
  }

  Widget _title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Sign up to get started',
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool obscure = false,
    Widget? suffix,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboard,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFFFE6DC),
              suffixIcon: suffix,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _loading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF28B66),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: _loading
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _eye(VoidCallback onTap, bool hidden) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(hidden ? Icons.visibility_off : Icons.visibility),
    );
  }
}
