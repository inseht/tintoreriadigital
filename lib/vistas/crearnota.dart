import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:tintoreriadigital/bloc/crearNotaBloc.dart';
import '../repositorios/crearNotasRepositorio.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrearNota extends StatefulWidget {
  const CrearNota({super.key});

  @override
  State<CrearNota> createState() => _CrearNotaState();
}

class _CrearNotaState extends State<CrearNota> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();
  final TextEditingController _estadoPagoController = TextEditingController();
  final TextEditingController _abonoController = TextEditingController();
  final TextEditingController _importeTotalController = TextEditingController();
  final TextEditingController _precioUnitarioController = TextEditingController(); // Controlador para el precio unitario

  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  String? _tipoPrendaSeleccionada;
  final List<String> _tiposPrenda = ['Camisa', 'Pantalón', 'Chaqueta', 'Vestido'];

  int _cantidadPrendas = 0;

  // Servicios desde el repositorio
  final List<String> _servicios = CrearNotasRepositorio().obtenerServicios();
  String? _servicioSeleccionado;

  // Lista de prendas agregadas
  List<Map<String, dynamic>> _prendas = [];

  /// Abre el DatePicker en un cuadro de diálogo
  Future<void> _mostrarDatePicker(BuildContext context) async {
    DateTime fechaMinima = DateTime.now().subtract(Duration(days: 60)); // 60 días es aproximadamente 2 meses.

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar rango de fechas'),
        content: SizedBox(
          height: 400,
          width: 300,
          child: SfDateRangePicker(
            selectionMode: DateRangePickerSelectionMode.range,
            minDate: fechaMinima, // Establece la fecha mínima
            onSelectionChanged: (args) {
              if (args.value is PickerDateRange) {
                setState(() {
                  _fechaInicio = args.value.startDate;
                  _fechaFin = args.value.endDate;
                });
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  // Método para agregar una prenda a la lista
  void _agregarPrenda() {
    double precioUnitario = double.tryParse(_precioUnitarioController.text) ?? 0.0; // Obtener precio unitario desde el controlador

    if (_tipoPrendaSeleccionada != null && _cantidadPrendas > 0 && _servicioSeleccionado != null && precioUnitario > 0.0) {
      setState(() {
        _prendas.add({
          'tipo': _tipoPrendaSeleccionada,
          'servicio': _servicioSeleccionado,
          'precioUnitario': precioUnitario,
          'cantidad': _cantidadPrendas,
        });
      });

      // Imprimir la lista de prendas en la consola para verificar
      print('Lista de prendas:');
      _prendas.forEach((prenda) {
        print('Tipo: ${prenda['tipo']}, Servicio: ${prenda['servicio']}, Cantidad: ${prenda['cantidad']}, Precio Unitario: ${prenda['precioUnitario']}');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos de prenda')),
      );
    }
  }

  // Método para enviar los datos al BLoC
  void _crearNota() {
    if (_fechaInicio == null || _fechaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar un rango de fechas')),
      );
      return;
    }

    final Map<String, dynamic> nota = {
      'nombreCliente': _nombreController.text,
      'telefonoCliente': _telefonoController.text,
      'fechaRecibido': _fechaInicio,
      'fechaEstimada': _fechaFin,
      'importe': double.tryParse(_importeTotalController.text) ?? 0.0,
      'estadoPago': _estadoPagoController.text,
      'prioridad': 1, // Puedes obtener esta información de alguna parte o input
      'observaciones': _observacionesController.text,
      'estado': 'Recibido', // Por defecto o según el caso
    };

    // Enviar al BLoC
    context.read<CrearNotaBloc>().add(EnviarFormulario(nota: nota, prendas: _prendas));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  // Card de Información General
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Información general',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            const SizedBox(height: 16.0),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextField(
                                    controller: _nombreController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Nombre del cliente',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextField(
                                    controller: _telefonoController,
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Teléfono del cliente',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => _mostrarDatePicker(context),
                                        child: const Text('Seleccionar fechas'),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        _fechaInicio != null && _fechaFin != null
                                            ? '${DateFormat('dd/MM/yyyy').format(_fechaInicio!)} - ${DateFormat('dd/MM/yyyy').format(_fechaFin!)}'
                                            : 'No seleccionado',
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'Fecha estimada de entrega: ${_fechaFin != null ? DateFormat('dd/MM/yyyy').format(_fechaFin!) : 'Seleccione un rango'}',
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextField(
                                    controller: _observacionesController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Observaciones',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextField(
                                    controller: _estadoPagoController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Estado de pago',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextField(
                                    controller: _abonoController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Abono',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextField(
                                    controller: _importeTotalController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Importe total',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Selecciona la prioridad'),
                                  const SizedBox(width: 8.0),
                                  RoundCheckBox(
                                    onTap: (selected) {},
                                    uncheckedColor: Colors.red,
                                    uncheckedWidget: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Card de Prendas
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Prendas',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            const SizedBox(height: 16.0),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: DropdownButtonFormField<String>(
                                    value: _tipoPrendaSeleccionada,
                                    items: _tiposPrenda
                                        .map((tipo) => DropdownMenuItem(
                                              value: tipo,
                                              child: Text(tipo),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _tipoPrendaSeleccionada = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Tipo de prenda',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: DropdownButtonFormField<String>(
                                    value: _servicioSeleccionado,
                                    items: _servicios
                                        .map((servicio) => DropdownMenuItem(
                                              value: servicio,
                                              child: Text(servicio),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _servicioSeleccionado = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Servicios',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        _cantidadPrendas = int.tryParse(value) ?? 0;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Cantidad de prendas',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextField(
                                    controller: _precioUnitarioController, // Ahora se usa el controlador adecuado
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Precio unitario',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Center(
                              child: ElevatedButton(
                                onPressed: _agregarPrenda,
                                child: const Text('Agregar prenda'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(200, 50),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50.0),
          Center(
            child: ElevatedButton(
              onPressed: _crearNota,
              child: const Text(
                'Crear nota',
                style: TextStyle(fontSize: 30), // Aumenta el tamaño del texto
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40), // Ajusta el relleno interno
                minimumSize: const Size(200, 70), // Asegura un tamaño mínimo adecuado
              ),
            ),
          ),
          const SizedBox(height: 100.0),
        ],
      ),
    );
  }
}
