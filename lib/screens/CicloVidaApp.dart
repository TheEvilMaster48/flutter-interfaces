import 'package:flutter/material.dart';

class CicloVidaApp extends StatefulWidget {
  const CicloVidaApp({super.key});

  @override
  State<CicloVidaApp> createState() => _CicloVidaAppState();
}

class _CicloVidaAppState extends State<CicloVidaApp> with WidgetsBindingObserver {
  String _estado = "Aplicación iniciada";
  Color _colorFondo = const Color(0xFF6366F1);
  IconData _icono = Icons.phone_android_rounded;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch (state) {
        case AppLifecycleState.inactive:
          _estado = "Aplicación inactiva";
          _colorFondo = const Color(0xFFF59E0B); // Amarillo moderno
          _icono = Icons.pause_circle_rounded;
          break;
        case AppLifecycleState.paused:
          _estado = "Aplicación en segundo plano";
          _colorFondo = const Color(0xFFEF4444); // Rojo moderno
          _icono = Icons.stop_circle_rounded;
          break;
        case AppLifecycleState.resumed:
          _estado = "Aplicación en primer plano";
          _colorFondo = const Color(0xFF10B981); // Verde moderno
          _icono = Icons.play_circle_rounded;
          break;
        case AppLifecycleState.detached:
          _estado = "Aplicación cerrada";
          _colorFondo = const Color(0xFF64748B); // Gris moderno
          _icono = Icons.cancel_rounded;
          break;
        case AppLifecycleState.hidden:
          _estado = "Aplicación oculta";
          _colorFondo = const Color(0xFF8B5CF6); // Púrpura moderno
          _icono = Icons.visibility_off_rounded;
          break;
      }
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_estado),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: _colorFondo,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ciclo de Vida"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _colorFondo,
              _colorFondo.withOpacity(0.7),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey(_icono),
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Icon(
                    _icono,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Estado Actual",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _estado,
                        key: ValueKey(_estado),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
