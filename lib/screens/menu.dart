import 'package:flutter/material.dart';
import 'package:flutter_interfaces/screens/bloc_notas.dart';
import 'package:flutter_interfaces/screens/calculadora.dart';
import 'package:flutter_interfaces/screens/relog.dart';
import 'package:flutter_interfaces/screens/timer.dart';
import 'package:flutter_interfaces/widget/menuItem.dart';

class MunuPantalla extends StatelessWidget {
  const MunuPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menú Principal",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0F1F), Color(0xFF0C1738), Color(0xFF001F3F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // ✨ Brillo suave central
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF38BDF8).withOpacity(0.15),
                      Colors.transparent
                    ],
                    radius: 1.2,
                    center: Alignment.center,
                  ),
                ),
              ),
            ),
            // 🌟 Fondo de textura sutil
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: Image.asset(
                  "assets/icono/mi_logo.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 📱 Contenido principal
            GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                MenuItem(
                  titulo: "CALCULADORA",
                  icono: Icons.calculate_rounded,
                  gradientColors: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CalculadorScreen()),
                    );
                  },
                ),
                MenuItem(
                  titulo: "TIMER",
                  icono: Icons.timer_rounded,
                  gradientColors: const [Color(0xFF10B981), Color(0xFF059669)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TimerScreen()),
                    );
                  },
                ),
                MenuItem(
                  titulo: "RELOJ",
                  icono: Icons.access_time_rounded,
                  gradientColors: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RelojScreens()),
                    );
                  },
                ),
                MenuItem(
                  titulo: "BLOC DE NOTAS",
                  icono: Icons.edit_note_rounded,
                  gradientColors: const [Color(0xFF06B6D4), Color(0xFF3B82F6)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BlocNotasApp()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
