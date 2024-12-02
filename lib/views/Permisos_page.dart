import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:talento_mxm_flutter/controllers/permisos_controller.dart';
import 'package:talento_mxm_flutter/views/bottom_menu.dart';
import 'package:talento_mxm_flutter/views/menu.dart';

class CrearPermisoPage extends StatefulWidget {
  @override
  _CrearPermisoPageState createState() => _CrearPermisoPageState();
}

class _CrearPermisoPageState extends State<CrearPermisoPage> {
  final PermisosController permisosController = Get.put(PermisosController());
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pventaController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();
  final TextEditingController _tiempoController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _fechapermisoController = TextEditingController();
  final TextEditingController _fechasolicitudController =
      TextEditingController();
  final TextEditingController _justificacionController = TextEditingController();


  String? _unidad;

  final List<String> _unidades = ['Días', 'Horas'];
  final List<String> _categorias = [
    'Calamidad Doméstica',
    'Recreación',
    'Compromiso Médico',
    'Compromiso Familiar',
    'Compromiso Académico',
    'Otros'
  ];

  final List<String> _puntoventa = [
    'ADMINISTRACION', 'BUCARICA', 'CABECERA', 'CARACOLI',
    'CEDI', 'CIUDADELA', 'COLOMBIA', 'COLTABACO', 'COMERCIO',
    'CUMBRE', 'FLORESTA', 'FLORIDA', 'FRUVER', 'GAIRA', 'GIRON',
    'GUARIN', 'K-27', 'LA 200', 'NOVENA', 'PIEDECUESTA', 'POBLADO',
    'PROVENZA', 'PUERTA DEL SOL', 'ROSITA', 'RUITOQUE', 'SAN FCO',
    'SOLERI', 'WEBBCA', 'WEBBGA', 'OTRO'
  ];

  // Función para seleccionar la fecha
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd')
            .format(picked); // Aseguramos el formato correcto
      });
    }
  }

  // Mostrar la alerta de confirmación
  void _showConfirmationDialog() {
    String puntoVenta = _pventaController.text.isEmpty
        ? 'No especificado'
        : _pventaController.text;
    String categoria = _categoriaController.text.isEmpty
        ? 'No especificada'
        : _categoriaController.text;
    String tiempo = _tiempoController.text.isEmpty
        ? 'No especificado'
        : _tiempoController.text;
    String unidad = _unidad ?? 'No especificada';
    String hora = _horaController.text.isEmpty ? 'No especificada' : _horaController.text;
    String fechaPermiso = _fechapermisoController.text.isEmpty
        ? 'No especificada'
        : _fechapermisoController.text;
    String fechaSolicitud = _fechasolicitudController.text.isEmpty
        ? 'No especificada'
        : _fechasolicitudController.text;
   String justificacion = _justificacionController.text.isEmpty
        ? 'No especificada'
        : _justificacionController.text;

    // Mostrar el diálogo de confirmación
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar datos'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Punto de venta: $puntoVenta'),
              Text('Categoría de solicitud: $categoria'),
              Text('Tiempo requerido: $tiempo'),
              Text('Unidad de tiempo: $unidad'),
              if (_unidad == 'Horas') Text('Hora: $hora'),
              Text('Fecha de permiso: $fechaPermiso'),
              Text('Fecha de solicitud: $fechaSolicitud'),
              Text('Justificacion: $justificacion'),
              SizedBox(height: 16),
              Text(
                'Recuerda que estos permisos son remunerados. Por favor, verifica los datos antes de Enviar tu permiso.',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _submitForm(); // Llamar a la función que envía los datos
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  // Enviar el formulario
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      permisosController
          .createPermiso(
            pventa: _pventaController.text,
            categoriasolicitud: _categoriaController.text,
            tiempo: int.parse(_tiempoController.text),
            unidad: _unidad!,
            hora: _horaController.text,
            fechapermiso:
                DateTime.parse(_fechapermisoController.text),
            fechasolicitud:
                DateTime.parse(_fechasolicitudController.text),
            justificacion: _justificacionController.text,
            context: context,
          )
          .then((_) {
        // Redirigir a la página de menú después de crear el permiso
        Get.offAll(() => MenuPage()); // Redirigir a la página de menú
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 5, 13, 121),
        title: Text('Permisos Remunerados', style: TextStyle(color: Colors.white)),
      ),
      drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


               
                // Dropdown para el punto de venta de la solicitud
                SizedBox(height: 16),
                 DropdownButtonFormField<String>(
  value: _pventaController.text.isEmpty ? null : _pventaController.text,
  decoration: InputDecoration(
    labelText: 'sede',
    border: OutlineInputBorder(),
  ),
  onChanged: (newValue) {
    setState(() {
      if (newValue == 'Otros') {
        _pventaController.clear(); // Limpiar el campo si selecciona 'Otros'
      } else {
        _pventaController.text = newValue!;
      }
    });
  },
  items: _puntoventa.map((puntoventa) {
    return DropdownMenuItem<String>(
      value: puntoventa,
      child: Text(
        puntoventa,
        style: TextStyle(fontSize: 12), // Fuente más pequeña
      ),
    );
  }).toList(),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Por favor selecciona un punto de venta';
    }
    return null;
  },
  isDense: true, // Hacer más compacto el dropdown
  itemHeight: 48.0, // Asegurarse de que la altura mínima sea 48.0
  isExpanded: false, 
  menuMaxHeight: 200.0, // Limitar la altura del menú desplegado
)
,

                SizedBox(height: 16),

                // Dropdown para la categoría de solicitud
                DropdownButtonFormField<String>(
                  value: _categoriaController.text.isEmpty
                      ? null
                      : _categoriaController.text,
                  decoration: InputDecoration(
                    labelText: 'Categoría de solicitud',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _categoriaController.text = newValue!;
                    });
                  },
                  items: _categorias.map((categoria) {
                    return DropdownMenuItem<String>(
                      value: categoria,
                      child: Text(categoria),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona una categoría';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Campo de Tiempo Requerido
                TextFormField(
                  controller: _tiempoController,
                  decoration: InputDecoration(
                    labelText: 'Tiempo requerido',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el tiempo requerido';
                    } else if (int.tryParse(value) == null) {
                      return 'El tiempo debe ser un número válido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Dropdown para la unidad de tiempo
                DropdownButtonFormField<String>(
                  value: _unidad,
                  decoration: InputDecoration(
                    labelText: 'Unidad de tiempo (Días, Horas)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _unidad = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor selecciona una unidad de tiempo';
                    }
                    return null;
                  },
                  items: _unidades.map((unidad) {
                    return DropdownMenuItem<String>(
                      value: unidad,
                      child: Text(unidad),
                    );
                  }).toList(),
                ),

                 SizedBox(height: 16),

                // Campo de hora (solo visible si la unidad es 'Horas')
                if (_unidad == 'Horas') ...[
  Container(
    width: 100, // Definir un tamaño más pequeño para el input
    child: DropdownButtonFormField<String>(
      value: _horaController.text.isEmpty ? null : _horaController.text,
      decoration: InputDecoration(
        labelText: 'Hora (formato militar)',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0), // Ajustar el padding horizontal
      ),
      onChanged: (newValue) {
        setState(() {
          _horaController.text = newValue!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor selecciona la hora';
        }
        return null;
      },
      items: [
        '06:00', '07:00', '08:00', '09:00', '10:00', '11:00',
        '12:00', '13:00', '14:00', '15:00', '16:00', '17:00',
        '18:00', '19:00', '20:00'
      ].map((hora) {
        return DropdownMenuItem<String>(
          value: hora,
          child: Text(
            hora,
            style: TextStyle(fontSize: 12), // Fuente más pequeña
          ),
        );
      }).toList(),
      isDense: true, // Hacer más compacto el dropdown
      itemHeight: 48.0, // Asegurarse de que la altura mínima sea 48.0
      isExpanded: false,
      menuMaxHeight: 200.0, // Limitar la altura del menú desplegado
    ),
  ),
],

                SizedBox(height: 16),

                // Campos de fecha de permiso y fecha de solicitud
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _fechapermisoController,
                        decoration: InputDecoration(
                          labelText: 'Fecha de permiso',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        onTap: () async {
                          await _selectDate(context, _fechapermisoController);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor selecciona la fecha de permiso';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _fechasolicitudController,
                        decoration: InputDecoration(
                          labelText: 'Fecha de solicitud',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        onTap: () async {
                          await _selectDate(context, _fechasolicitudController);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor selecciona la fecha de solicitud';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                  SizedBox(height: 16),

                // Campo de Tiempo Requerido
                TextFormField(
                  controller: _justificacionController,
                  decoration: InputDecoration(
                    labelText: 'indique como repondra el tiempo solicitado',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la justificacion';
                    } 
                    return null;
                  },
                ),

                  Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Un permiso remunerado es cuando una persona que trabaja puede faltar al trabajo por un tiempo, pero sigue ganando su sueldo como si hubiera trabajado. Esto es diferente a los permisos no remunerados, donde no se recibe dinero durante la ausencia.\n\n'
                        'Los permisos remunerados están regulados por las leyes del país o acuerdos entre el jefe y el trabajador. Las condiciones pueden cambiar dependiendo del lugar donde trabajes o el contrato que tengas. También es importante recordar que si pides un permiso no remunerado, debes enviarlo por el portal de Autogestión.',
                        
                        style: TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Botón de crear permiso
                ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  child: Text('Crear Permiso Remunerado'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
