import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameCtrl = TextEditingController();
  final _lastnameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptTerms = false;
  bool _loading = false;

  static const _green = Color(0xFF2E7D32);
  static const _lightGreen = Color(0xFFE8F5E9);

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez accepter les conditions d\'utilisation')),
      );
      return;
    }
    setState(() => _loading = true);

    final result = await AuthService.register(
      firstname: _firstnameCtrl.text.trim(),
      lastname: _lastnameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );

    setState(() => _loading = false);
    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Compte créé avec succès ! Connectez-vous.'),
          backgroundColor: _green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // ── Logo ──────────────────────────────────
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.08),
                      blurRadius: 10, offset: const Offset(0, 3)),
                  ],
                ),
                child: const Icon(Icons.eco_rounded, color: Color(0xFF2E7D32), size: 36),
              ),
              const SizedBox(height: 14),

              // ── Badge ─────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _lightGreen,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _green.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_outlined, color: _green, size: 14),
                    const SizedBox(width: 6),
                    const Text('SERRE DIGITALE',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                        color: _green, letterSpacing: 1)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              const Text('Créer un compte',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
              const SizedBox(height: 6),
              const Text(
                'Rejoignez la gestion connectée de votre serre\nmaraîchère et suivez vos cultures en temps réel.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF757575), height: 1.5)),
              const SizedBox(height: 24),

              // ── Form Card ─────────────────────────────
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.06),
                      blurRadius: 20, offset: const Offset(0, 4)),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Prénom + Nom
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Prénom',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                    color: Color(0xFF424242))),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _firstnameCtrl,
                                  decoration: const InputDecoration(hintText: 'Thomas'),
                                  validator: (v) => v!.isEmpty ? 'Requis' : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Nom',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                    color: Color(0xFF424242))),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _lastnameCtrl,
                                  decoration: const InputDecoration(hintText: 'Dubois'),
                                  validator: (v) => v!.isEmpty ? 'Requis' : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email
                      _buildLabel('Adresse e-mail'),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'thomas.dubois@ferme.fr',
                          prefixIcon: Icon(Icons.alternate_email, color: Color(0xFF9E9E9E), size: 20),
                        ),
                        validator: (v) => v!.isEmpty ? 'Email requis' : null,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      _buildLabel('Mot de passe'),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9E9E9E), size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: const Color(0xFF9E9E9E), size: 20),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) => v!.length < 6 ? '6 caractères minimum' : null,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 6, left: 4),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 13, color: Color(0xFF9E9E9E)),
                            SizedBox(width: 4),
                            Text('Au moins 8 caractères, incluant un chiffre',
                              style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirm password
                      _buildLabel('Confirmer le mot de passe'),
                      TextFormField(
                        controller: _confirmCtrl,
                        obscureText: _obscureConfirm,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_reset, color: Color(0xFF9E9E9E), size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: const Color(0xFF9E9E9E), size: 20),
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        validator: (v) => v != _passwordCtrl.text ? 'Mots de passe différents' : null,
                      ),
                      const SizedBox(height: 16),

                      // Terms
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                            activeColor: _green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(fontSize: 12, color: Color(0xFF424242)),
                                children: [
                                  TextSpan(text: "J'accepte les "),
                                  TextSpan(text: 'conditions générales d\'utilisation',
                                    style: TextStyle(color: _green, fontWeight: FontWeight.w600)),
                                  TextSpan(text: ' et la charte de confidentialité agronomique.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // S'inscrire
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _register,
                          child: _loading
                            ? const SizedBox(height: 20, width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text("S'inscrire  →"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Footer info
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_tethering, color: Color(0xFF2E7D32), size: 14),
                  const SizedBox(width: 6),
                  const Text('Télémétrie 24/7',
                    style: TextStyle(fontSize: 11, color: Color(0xFF757575))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('•', style: TextStyle(color: Color(0xFFBDBDBD))),
                  ),
                  const Icon(Icons.shield_outlined, color: Color(0xFF2E7D32), size: 14),
                  const SizedBox(width: 6),
                  const Text('Données protégées',
                    style: TextStyle(fontSize: 11, color: Color(0xFF757575))),
                ],
              ),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Vous avez déjà un compte ? ',
                    style: TextStyle(fontSize: 13, color: Color(0xFF757575))),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                    child: const Text('Se connecter',
                      style: TextStyle(color: _green, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF424242))),
    ),
  );

  @override
  void dispose() {
    _firstnameCtrl.dispose();
    _lastnameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }
}
