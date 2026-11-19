import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String _firstname = '';
  bool _ventilation = true;
  String _lastUpdate = '11:42';

  static const _green = Color(0xFF2E7D32);
  static const _lightGreen = Color(0xFFE8F5E9);

  @override
  void initState() {
    super.initState();
    _loadUser();
    _lastUpdate = _currentTime();
  }

  String _currentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _loadUser() async {
    final info = await AuthService.getUserInfo();
    setState(() => _firstname = info['firstname'] ?? 'Utilisateur');
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.white,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: _green, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.eco_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('SERRE DIGITALE',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                    color: Color(0xFF9E9E9E), letterSpacing: 1)),
                Text('Accueil',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF424242)),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: _logout,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: _green,
                child: Text(_firstname.isNotEmpty ? _firstname[0].toUpperCase() : 'U',
                  style: const TextStyle(color: Colors.white, fontSize: 14,
                    fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Greeting ─────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bonjour, $_firstname 👋',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A))),
                    const Text('Cycle de floraison • Semaine 4 sur 8',
                      style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _lightGreen,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(width: 7, height: 7,
                        decoration: const BoxDecoration(color: _green, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      const Text('Serre #1 • En ligne',
                        style: TextStyle(fontSize: 11, color: _green, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Bilan Global Card ─────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: _green.withOpacity(0.3),
                    blurRadius: 15, offset: const Offset(0, 6)),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.eco_rounded, color: Colors.white, size: 32),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('BILAN GLOBAL',
                          style: TextStyle(fontSize: 10, color: Colors.white70,
                            fontWeight: FontWeight.w600, letterSpacing: 1)),
                        SizedBox(height: 2),
                        Text('Climat d\'excellence',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                            color: Colors.white)),
                        SizedBox(height: 4),
                        Text('Tous voyants au vert',
                          style: TextStyle(fontSize: 12, color: Colors.white70)),
                        Text('Photosynthèse optimale • Zéro anomalie',
                          style: TextStyle(fontSize: 11, color: Colors.white60)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('98%\nVitalité',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 12,
                            fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Telemetry Section ─────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Télémétrie en temps réel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                GestureDetector(
                  onTap: () => setState(() => _lastUpdate = _currentTime()),
                  child: Row(
                    children: [
                      const Icon(Icons.refresh, size: 14, color: Color(0xFF9E9E9E)),
                      const SizedBox(width: 4),
                      Text('Mis à jour: $_lastUpdate',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Sensor Grid ───────────────────────────
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
              children: [
                _sensorCard(
                  icon: Icons.thermostat_outlined,
                  label: 'Température',
                  value: '24.5',
                  unit: '°C',
                  status: 'Optimal',
                  statusColor: _green,
                  target: 'Cible : 22°C – 26°C',
                  trend: '+0.2°C',
                  trendPositive: true,
                ),
                _sensorCard(
                  icon: Icons.water_drop_outlined,
                  label: 'Hygrométrie',
                  value: '68',
                  unit: '%',
                  status: 'Optimal',
                  statusColor: _green,
                  target: 'Cible : 60% – 75%',
                  trend: 'Stable',
                  trendPositive: true,
                ),
                _sensorCard(
                  icon: Icons.wb_sunny_outlined,
                  label: 'Luminosité',
                  value: '14.2',
                  unit: 'kLux',
                  status: 'Élevé',
                  statusColor: Colors.orange.shade700,
                  target: 'Ensoleillé • Voile libre',
                  trend: 'Max 18k',
                  trendPositive: null,
                ),
                _sensorCard(
                  icon: Icons.cloud_outlined,
                  label: 'Qualité CO₂',
                  value: '850',
                  unit: 'ppm',
                  status: 'Pur',
                  statusColor: _green,
                  target: 'Max autorisé : 1200',
                  trend: 'Idéal',
                  trendPositive: true,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Camera Zone ───────────────────────────
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFF2D4A2D),
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=800'),
                  fit: BoxFit.cover,
                  opacity: 0.6,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('CAMÉRA Z1 • TOITURE NORD',
                      style: TextStyle(color: Colors.white70, fontSize: 10,
                        fontWeight: FontWeight.w600, letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Zone Tomates & Basilic',
                          style: TextStyle(color: Colors.white, fontSize: 16,
                            fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.circle, color: Colors.white, size: 6),
                              SizedBox(width: 4),
                              Text('Direct', style: TextStyle(color: Colors.white, fontSize: 11,
                                fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Quick Controls ────────────────────────
            const Text('Contrôles d\'action rapide',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 12),

            _controlCard(
              icon: Icons.air,
              title: 'Ventilation régulée',
              subtitle: 'Régulation auto sous 25.0°C',
              isToggle: true,
              toggleValue: _ventilation,
              onToggle: (v) => setState(() => _ventilation = v),
            ),
            const SizedBox(height: 10),
            _controlCard(
              icon: Icons.grass,
              title: 'Micro-goutte 15 min',
              subtitle: 'Injecteur d\'arrosage Ligne A',
              isToggle: false,
              onLaunch: () {},
            ),
            const SizedBox(height: 12),

            // Sync info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F9F3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.cloud_done_outlined, color: _green, size: 16),
                  SizedBox(width: 8),
                  Text('Synchronisé avec la passerelle Zigbee  •  Il y a 2 min',
                    style: TextStyle(fontSize: 11, color: Color(0xFF5D7B5D))),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _green,
        unselectedItemColor: const Color(0xFF9E9E9E),
        backgroundColor: Colors.white,
        elevation: 10,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.sensors_outlined), activeIcon: Icon(Icons.sensors), label: 'Capteurs'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), activeIcon: Icon(Icons.notifications), label: 'Alertes'),
          BottomNavigationBarItem(icon: Icon(Icons.tune_outlined), activeIcon: Icon(Icons.tune), label: 'Paramètres'),
        ],
      ),
    );
  }

  Widget _sensorCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required String status,
    required Color statusColor,
    required String target,
    required String trend,
    required bool? trendPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05),
            blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: const Color(0xFF2E7D32), size: 22),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(status,
                  style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: value,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A))),
                TextSpan(text: ' $unit',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E))),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(target, style: const TextStyle(fontSize: 10, color: Color(0xFFBDBDBD))),
          const SizedBox(height: 6),
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.7,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(trend,
            style: TextStyle(
              fontSize: 10,
              color: trendPositive == null
                ? const Color(0xFF9E9E9E)
                : trendPositive ? const Color(0xFF2E7D32) : Colors.red,
              fontWeight: FontWeight.w600,
            )),
        ],
      ),
    );
  }

  Widget _controlCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isToggle,
    bool? toggleValue,
    Function(bool)? onToggle,
    VoidCallback? onLaunch,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04),
            blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A))),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
              ],
            ),
          ),
          if (isToggle)
            Switch(
              value: toggleValue ?? false,
              onChanged: onToggle,
              activeColor: const Color(0xFF2E7D32),
            )
          else
            ElevatedButton(
              onPressed: onLaunch,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Lancer', style: TextStyle(fontSize: 13)),
            ),
        ],
      ),
    );
  }
}
