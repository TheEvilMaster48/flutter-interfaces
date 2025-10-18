import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with TickerProviderStateMixin {
  int _segundos = 0;
  int _minutos = 0;
  int _horas = 0;
  int _tiempoTotal = 0;
  int _tiempoRestante = 0;
  Timer? _timer;
  bool _corriendo = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _iniciarTimer() {
    if (_segundos == 0 && _minutos == 0 && _horas == 0) return;

    setState(() {
      _tiempoTotal = _horas * 3600 + _minutos * 60 + _segundos;
      _tiempoRestante = _tiempoTotal;
      _corriendo = true;
    });

    _animationController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_tiempoRestante > 0) {
          _tiempoRestante--;
        } else {
          _pausarTimer();
          _mostrarAlerta();
        }
      });
    });
  }

  void _pausarTimer() {
    _timer?.cancel();
    setState(() => _corriendo = false);
    _animationController.reverse();
  }

  void _reiniciarTimer() {
    _timer?.cancel();
    setState(() {
      _corriendo = false;
      _tiempoRestante = 0;
      _tiempoTotal = 0;
      _segundos = 0;
      _minutos = 0;
      _horas = 0;
    });
    _animationController.reverse();
  }

  void _mostrarAlerta() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("⏰ ¡Tiempo terminado!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text("El temporizador ha llegado a cero.",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Color(0xFF38BDF8))),
          ),
        ],
      ),
    );
  }

  String _formatearTiempo(int segundosTotales) {
    int h = segundosTotales ~/ 3600;
    int m = (segundosTotales % 3600) ~/ 60;
    int s = segundosTotales % 60;
    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  Widget _selectorTiempo(String label, int valor, Function(int) onChange) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF38BDF8),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.3)),
          ),
          child: Column(
            children: [
              IconButton(
                onPressed: _corriendo ? null : () => onChange(valor + 1),
                icon: const Icon(Icons.keyboard_arrow_up_rounded),
                color: const Color(0xFF38BDF8),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  valor.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: _corriendo ? null : () => onChange(valor > 0 ? valor - 1 : 0),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                color: const Color(0xFF38BDF8),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double progreso = _tiempoTotal > 0 ? _tiempoRestante / _tiempoTotal : 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF38BDF8)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Temporizador",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0F1F), Color(0xFF0C1738), Color(0xFF001F3F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 260,
                    height: 260,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(260, 260),
                          painter: _CirculoProgresoPainter(progreso),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _corriendo ? Icons.timer_rounded : Icons.timer_off_rounded,
                              size: 48,
                              color: const Color(0xFF38BDF8),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _tiempoRestante > 0
                                  ? _formatearTiempo(_tiempoRestante)
                                  : "00:00:00",
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: "Courier New",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (!_corriendo && _tiempoRestante == 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _selectorTiempo("Horas", _horas, (val) => setState(() => _horas = val)),
                          _selectorTiempo("Minutos", _minutos, (val) => setState(() => _minutos = val % 60)),
                          _selectorTiempo("Segundos", _segundos, (val) => setState(() => _segundos = val % 60)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_tiempoRestante > 0 || _corriendo)
                        _botonControl(
                          icono: Icons.refresh_rounded,
                          color: const Color(0xFFEF4444),
                          onTap: _reiniciarTimer,
                        ),
                      if (_tiempoRestante > 0 || _corriendo) const SizedBox(width: 20),
                      _botonControl(
                        icono: _corriendo ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: const Color(0xFF38BDF8),
                        onTap: _corriendo ? _pausarTimer : _iniciarTimer,
                        grande: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _botonControl({
    required IconData icono,
    required Color color,
    required VoidCallback onTap,
    bool grande = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: grande ? 80 : 64,
        height: grande ? 80 : 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(icono, color: Colors.white, size: grande ? 40 : 32),
      ),
    );
  }
}

class _CirculoProgresoPainter extends CustomPainter {
  final double progreso;

  _CirculoProgresoPainter(this.progreso);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintFondo = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    canvas.drawCircle(center, radius - 6, paintFondo);

    final paintProgreso = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF38BDF8), Color(0xFF3B82F6)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 6),
        -math.pi / 2, 2 * math.pi * progreso, false, paintProgreso);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
