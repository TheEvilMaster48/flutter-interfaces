import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlocNotasApp extends StatefulWidget {
  const BlocNotasApp({super.key});

  @override
  State<BlocNotasApp> createState() => _BlocNotasAppState();
}

class _BlocNotasAppState extends State<BlocNotasApp> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  List<Map<String, String>> _notas = [];
  int? _indiceEditando;

  @override
  void initState() {
    super.initState();
    _cargarNotas();
  }

  Future<void> _cargarNotas() async {
    final prefs = await SharedPreferences.getInstance();
    final datos = prefs.getStringList('notas') ?? [];
    setState(() {
      _notas = datos.map((e) {
        final partes = e.split('|||');
        return {'titulo': partes[0], 'descripcion': partes[1]};
      }).toList();
    });
  }

  Future<void> _guardarNotas() async {
    final prefs = await SharedPreferences.getInstance();
    final datos =
        _notas.map((e) => "${e['titulo']}|||${e['descripcion']}").toList();
    await prefs.setStringList('notas', datos);
  }

  void _agregarONeditarNota() {
    final titulo = _tituloController.text.trim();
    final descripcion = _descripcionController.text.trim();
    if (titulo.isEmpty || descripcion.isEmpty) return;

    setState(() {
      if (_indiceEditando != null) {
        _notas[_indiceEditando!] = {
          'titulo': titulo,
          'descripcion': descripcion
        };
        _indiceEditando = null;
      } else {
        _notas.add({'titulo': titulo, 'descripcion': descripcion});
      }
      _tituloController.clear();
      _descripcionController.clear();
    });
    _guardarNotas();
  }

  void _editarNota(int index) {
    setState(() {
      _indiceEditando = index;
      _tituloController.text = _notas[index]['titulo']!;
      _descripcionController.text = _notas[index]['descripcion']!;
    });
  }

  void _eliminarNota(int index) {
    setState(() {
      _notas.removeAt(index);
    });
    _guardarNotas();
  }

  void _limpiarTodo() {
    setState(() {
      _notas.clear();
      _indiceEditando = null;
      _tituloController.clear();
      _descripcionController.clear();
    });
    _guardarNotas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF38BDF8)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Bloc de Notas",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0A0F1F),
                  Color(0xFF0C1738),
                  Color(0xFF001F3F)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                          orientation == Orientation.landscape ? 700 : 400,
                    ),
                    child: Column(
                      children: [
                        _campoTexto("Título", _tituloController, maxLines: 1),
                        const SizedBox(height: 12),
                        _campoTexto("Descripción", _descripcionController,
                            maxLines: 3),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _botonAccion(
                              icono: _indiceEditando != null
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.add_circle_outline_rounded,
                              texto: _indiceEditando != null
                                  ? "Guardar"
                                  : "Agregar",
                              color: const Color(0xFF3B82F6),
                              onTap: _agregarONeditarNota,
                            ),
                            _botonAccion(
                              icono: Icons.cleaning_services_rounded,
                              texto: "Limpiar",
                              color: const Color(0xFFEF4444),
                              onTap: _limpiarTodo,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _notas.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Text(
                                  "No hay notas guardadas",
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 18),
                                ),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _notas.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E293B)
                                          .withOpacity(0.85),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF38BDF8)
                                            .withOpacity(0.4),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(
                                          Icons.note_alt_rounded,
                                          color: Color(0xFF38BDF8)),
                                      title: Text(
                                        _notas[index]['titulo']!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(
                                        _notas[index]['descripcion']!,
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                      trailing: Wrap(
                                        spacing: 8,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit_rounded,
                                                color: Color(0xFF10B981)),
                                            onPressed: () => _editarNota(index),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.delete_outline_rounded,
                                                color: Color(0xFFEF4444)),
                                            onPressed: () =>
                                                _eliminarNota(index),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _campoTexto(String hint, TextEditingController controller,
      {int maxLines = 1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.5)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _botonAccion({
    required IconData icono,
    required String texto,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icono, size: 24, color: Colors.white),
      label: Text(
        texto,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 6,
        shadowColor: color.withOpacity(0.6),
      ),
    );
  }
}
