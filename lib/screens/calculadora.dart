import 'package:flutter/material.dart';

class CalculadorScreen extends StatefulWidget {
  const CalculadorScreen({super.key});

  @override
  State<CalculadorScreen> createState() => _CalculadorScreenState();
}

class _CalculadorScreenState extends State<CalculadorScreen> {
  String _display = "0";
  String _operacion = "";
  double _primerNumero = 0;
  bool _nuevoNumero = true;

  void _presionarNumero(String numero) {
    setState(() {
      if (_nuevoNumero) {
        _display = numero;
        _nuevoNumero = false;
      } else {
        _display = _display == "0" ? numero : _display + numero;
      }
    });
  }

  void _presionarPunto() {
    setState(() {
      if (_display.isEmpty || _display == "0" || _nuevoNumero) {
        _display = "0.";
        _nuevoNumero = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _presionarOperacion(String op) {
    setState(() {
      _primerNumero = double.tryParse(_display) ?? 0;
      _operacion = op;
      _nuevoNumero = true;
    });
  }

  void _calcularResultado() {
    setState(() {
      double segundoNumero = double.tryParse(_display) ?? 0;
      double resultado = 0;

      switch (_operacion) {
        case '+':
          resultado = _primerNumero + segundoNumero;
          break;
        case '-':
          resultado = _primerNumero - segundoNumero;
          break;
        case '×':
          resultado = _primerNumero * segundoNumero;
          break;
        case '÷':
          resultado = segundoNumero != 0 ? _primerNumero / segundoNumero : 0;
          break;
      }

      _display = resultado % 1 == 0
          ? resultado.toInt().toString()
          : resultado.toStringAsFixed(2);
      _nuevoNumero = true;
      _operacion = "";
    });
  }

  void _limpiar() {
    setState(() {
      _display = "0";
      _operacion = "";
      _primerNumero = 0;
      _nuevoNumero = true;
    });
  }

  void _borrar() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = "0";
      }
    });
  }

  Widget _botonCalculadora(
    String texto, {
    Color? color,
    Color? colorTexto,
    bool esOperacion = false,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            gradient: esOperacion
                ? const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: esOperacion
                ? null
                : (color ?? const Color(0xFFFFFFFF).withOpacity(0.95)),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (esOperacion
                        ? const Color(0xFF6366F1)
                        : Colors.black.withOpacity(0.5))
                    .withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                texto,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: colorTexto ??
                      (esOperacion ? Colors.white : const Color(0xFF1E293B)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (_operacion.isNotEmpty)
                                  Text(
                                    "$_primerNumero $_operacion",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    _display,
                                    style: const TextStyle(
                                      fontSize: 56,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                for (var fila in [
                                  ["C", "⌫", "%", "÷"],
                                  ["7", "8", "9", "×"],
                                  ["4", "5", "6", "-"],
                                  ["1", "2", "3", "+"],
                                  ["0", ".", "00", "="],
                                ])
                                  Expanded(
                                    child: Row(
                                      children: [
                                        for (var b in fila)
                                          _botonCalculadora(
                                            b,
                                            color: b == "C"
                                                ? const Color(0xFFEF4444)
                                                : b == "⌫"
                                                    ? const Color(0xFFF59E0B)
                                                    : null,
                                            colorTexto: (b == "C" || b == "⌫")
                                                ? Colors.white
                                                : null,
                                            esOperacion: [
                                              "÷",
                                              "×",
                                              "-",
                                              "+",
                                              "="
                                            ].contains(b),
                                            onTap: () {
                                              if (b == "C") return _limpiar();
                                              if (b == "⌫") return _borrar();
                                              if (b == "=")
                                                return _calcularResultado();
                                              if (["÷", "×", "-", "+"]
                                                  .contains(b)) {
                                                return _presionarOperacion(b);
                                              }
                                              if (b == ".")
                                                return _presionarPunto();
                                              return _presionarNumero(b);
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
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
