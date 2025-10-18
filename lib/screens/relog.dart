import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class RelojScreens extends StatefulWidget {
  const RelojScreens({super.key});

  @override
  State<RelojScreens> createState() => _RelojScreensState();
}

class _RelojScreensState extends State<RelojScreens> {
  late Timer _timer;
  DateTime _horaActual = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _horaActual = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatearHora() {
    return "${_horaActual.hour.toString().padLeft(2, '0')}:${_horaActual.minute.toString().padLeft(2, '0')}:${_horaActual.second.toString().padLeft(2, '0')}";
  }

  String _formatearFecha() {
    const meses = [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre"
    ];
    const dias = [
      "Lunes",
      "Martes",
      "Miércoles",
      "Jueves",
      "Viernes",
      "Sábado",
      "Domingo"
    ];

    return "${dias[_horaActual.weekday - 1]}, ${_horaActual.day} de ${meses[_horaActual.month - 1]} ${_horaActual.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF38BDF8)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Reloj Digital",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A0F1F),
              Color(0xFF0C1738),
              Color(0xFF001F3F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        // Reloj analógico adaptable
                        Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Container(
                              width: constraints.maxWidth * 0.6,
                              height: constraints.maxWidth * 0.6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1E293B),
                                    Color(0xFF0F172A)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF38BDF8)
                                        .withOpacity(0.4),
                                    blurRadius: 30,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: CustomPaint(
                                painter: _RelojAnalogicoPainter(_horaActual),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),

                        // Reloj digital y fecha
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF38BDF8).withOpacity(0.6),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF38BDF8).withOpacity(0.4),
                                  blurRadius: 25,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    _formatearHora(),
                                    style: const TextStyle(
                                      fontSize: 64,
                                      fontFamily: 'Courier New',
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF38BDF8),
                                      letterSpacing: 4,
                                      height: 1.0,
                                      shadows: [
                                        Shadow(
                                          color: Color(0xFF38BDF8),
                                          blurRadius: 20,
                                        ),
                                        Shadow(
                                          color: Color(0xFF3B82F6),
                                          blurRadius: 40,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    _formatearFecha(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withOpacity(0.9),
                                      letterSpacing: 0.5,
                                      shadows: const [
                                        Shadow(
                                          color: Color(0xFF3B82F6),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Dibujo del reloj analógico
class _RelojAnalogicoPainter extends CustomPainter {
  final DateTime horaActual;

  _RelojAnalogicoPainter(this.horaActual);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Fondo circular con gradiente
    final paintFondo = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
        radius: 1.2,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paintFondo);

    // Marcas de minutos y horas
    for (int i = 0; i < 60; i++) {
      final angle = (i * 6 - 90) * math.pi / 180;
      final length = i % 5 == 0 ? 12.0 : 4.0;
      final paint = Paint()
        ..color = i % 5 == 0
            ? const Color(0xFF38BDF8)
            : const Color(0xFF94A3B8).withOpacity(0.5)
        ..strokeWidth = i % 5 == 0 ? 2.5 : 1.0;
      final x1 = center.dx + (radius - 15) * math.cos(angle);
      final y1 = center.dy + (radius - 15) * math.sin(angle);
      final x2 = center.dx + (radius - 15 - length) * math.cos(angle);
      final y2 = center.dy + (radius - 15 - length) * math.sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }

    // Manecillas
    final anguloHoras =
        ((horaActual.hour % 12) * 30 + horaActual.minute * 0.5 - 90) *
            math.pi /
            180;
    final paintHora = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center,
      Offset(center.dx + (radius - 90) * math.cos(anguloHoras),
          center.dy + (radius - 90) * math.sin(anguloHoras)),
      paintHora,
    );

    final anguloMinutos = (horaActual.minute * 6 - 90) * math.pi / 180;
    final paintMinuto = Paint()
      ..color = const Color(0xFF60A5FA)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center,
      Offset(center.dx + (radius - 50) * math.cos(anguloMinutos),
          center.dy + (radius - 50) * math.sin(anguloMinutos)),
      paintMinuto,
    );

    final anguloSegundos = (horaActual.second * 6 - 90) * math.pi / 180;
    final paintSegundo = Paint()
      ..color = const Color(0xFF3B82F6)
      ..strokeWidth = 2;
    canvas.drawLine(
      center,
      Offset(center.dx + (radius - 35) * math.cos(anguloSegundos),
          center.dy + (radius - 35) * math.sin(anguloSegundos)),
      paintSegundo,
    );

    // Centro del reloj
    final paintCentro = Paint()..color = const Color(0xFF38BDF8);
    canvas.drawCircle(center, 6, paintCentro);
    canvas.drawCircle(center, 3, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
