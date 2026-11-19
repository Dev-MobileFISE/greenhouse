import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  static const _green = Color(0xFF2E7D32);
  static const _lightGreen = Color(0xFFE8F5E9);

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final result = await AuthService.login(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );

    setState(() => _loading = false);

    if (!mounted) return;
    if (result['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              // ── Logo ──────────────────────────────────
              const SizedBox(height: 20),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _green,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _green.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.eco_rounded, color: Colors.white, size: 40),
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
                    Container(width: 7, height: 7,
                      decoration: const BoxDecoration(color: _green, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    const Text('SUPERVISION HORTICOLE V2.4',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                        color: _green, letterSpacing: 0.8)),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              const Text('Serre Digitale',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
              const Text('Surveillance & Climat Intelligent',
                style: TextStyle(fontSize: 13, color: Color(0xFF757575))),
              const SizedBox(height: 28),

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email
                      const Text('Adresse e-mail agronomique',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                          color: Color(0xFF424242))),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'votre@serre.fr',
                          prefixIcon: Icon(Icons.alternate_email, color: Color(0xFF9E9E9E), size: 20),
                        ),
                        validator: (v) => v!.isEmpty ? 'Email requis' : null,
                      ),
                      const SizedBox(height: 18),

                      // Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Mot de passe',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                              color: Color(0xFF424242))),
                          Text('Mot de passe oublié ?',
                            style: TextStyle(fontSize: 12, color: _green,
                              fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••••••',
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9E9E9E), size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: const Color(0xFF9E9E9E), size: 20,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) => v!.isEmpty ? 'Mot de passe requis' : null,
                      ),
                      const SizedBox(height: 10),

                      // IoT info
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F9F3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.wifi_tethering, color: _green, size: 16),
                            const SizedBox(width: 8),
                            const Text('Connexion sécurisée aux sondes IoT LoRaWAN',
                              style: TextStyle(fontSize: 11, color: Color(0xFF5D7B5D))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Se connecter
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _login,
                          child: _loading
                            ? const SizedBox(height: 20, width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Se connecter  →'),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Biométrique
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.fingerprint, size: 20),
                          label: const Text('Connexion biométrique (Touch ID)'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF424242),
                            side: const BorderSide(color: Color(0xFFE0E0E0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Divider ──────────────────────────────
              Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('ou', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  ),
                  const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
                ],
              ),
              const SizedBox(height: 16),

              // ── Create account ───────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Pas encore de compte d'exploitation ? ",
                    style: TextStyle(color: Color(0xFF757575), fontSize: 13)),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: const Text('Créer un compte',
                      style: TextStyle(color: _green, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Demo Mode ────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE8F5E9)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: _lightGreen, shape: BoxShape.circle),
                      child: const Icon(Icons.radio_button_checked, color: _green, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('Mode Démonstration Actif',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13,
                                  color: Color(0xFF1A1A1A))),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text('En direct',
                                  style: TextStyle(color: Colors.white, fontSize: 10,
                                    fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Explorez 3 serres connectées (Tomates anciennes, Basilic géant, Orchidées) avec 48 capteurs télémétriques actifs.',
                            style: TextStyle(fontSize: 11, color: Color(0xFF757575), height: 1.4)),
                          const SizedBox(height: 6),
                          Text('Visiter l\'espace d\'essai →',
                            style: const TextStyle(fontSize: 12, color: _green,
                              fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Footer ───────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _footerLink('Documentation API'),
                  _dot(),
                  _footerLink('Conformité RGPD'),
                  _dot(),
                  _footerLink('Assistance 24/7'),
                ],
              ),
              const SizedBox(height: 6),
              const Text('Plateforme certifiée Agriculture Éco-Régénérative',
                style: TextStyle(fontSize: 10, color: Color(0xFFBDBDBD))),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footerLink(String text) =>
    Text(text, style: const TextStyle(fontSize: 10, color: Color(0xFFBDBDBD)));

  Widget _dot() =>
    const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text('•', style: TextStyle(fontSize: 10, color: Color(0xFFBDBDBD))),
    );

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
}
