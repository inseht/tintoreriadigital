import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/crearNotaBloc.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class CrearNota extends StatefulWidget {
  const CrearNota({super.key});

  @override
  State<CrearNota> createState() => _CrearNotaState();
}

class _CrearNotaState extends State<CrearNota> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreClienteController = TextEditingController();
  final TextEditingController _telefonoClienteController = TextEditingController();
  final TextEditingController _importeController = TextEditingController();
  final TextEditingController _estadoPagoController = TextEditingController();
  final TextEditingController _prioridadController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  
  String _fechaRecibido = '';
  String _fechaEstimada = '';

void _seleccionarFechaRecibido() async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        height: 300,
        width: 300,
        child: Container(
          child: SfDateRangePicker(
  selectionMode: DateRangePickerSelectionMode.range, // Permite seleccionar un rango
  initialSelectedRange: PickerDateRange(
    DateTime.now().subtract(const Duration(days: 4)), // Fecha inicial
    DateTime.now().add(const Duration(days: 3)), // Fecha final
  ),
  onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      final DateTime startDate = args.value.startDate;
      final DateTime? endDate = args.value.endDate;

      // Actualizar las fechas seleccionadas (opcional)
      setState(() {
        _fechaRecibido = startDate.toString().split(' ')[0];
        _fechaEstimada = (endDate ?? startDate).toString().split(' ')[0];
      });
    }
  },
),

        ),
      ),
    ),
  );
}


void _seleccionarFechaEstimada() async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        height: 300,
        width: 300,
        child: Container(
          child: SfDateRangePicker(
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              setState(() {
                _fechaEstimada = (args.value as DateTime).toString().split(' ')[0];
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CrearNotaBloc(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreClienteController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Cliente',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _telefonoClienteController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono del Cliente',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _seleccionarFechaRecibido,
                  child: Text(_fechaRecibido.isEmpty
                      ? 'Seleccionar Fecha Recibido'
                      : 'Fecha Recibido: $_fechaRecibido'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _seleccionarFechaEstimada,
                  child: Text(_fechaEstimada.isEmpty
                      ? 'Seleccionar Fecha Estimada'
                      : 'Fecha Estimada: $_fechaEstimada'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _importeController,
                  decoration: const InputDecoration(
                    labelText: 'Importe',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _estadoPagoController,
                  decoration: const InputDecoration(
                    labelText: 'Estado del Pago',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _prioridadController,
                  decoration: const InputDecoration(
                    labelText: 'Prioridad',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _observacionesController,
                  decoration: const InputDecoration(
                    labelText: 'Observaciones',
                  ),
                ),
                
                const SizedBox(height: 16),
                TextFormField(
                  controller: _estadoController,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                  ),
                ),
            const SizedBox(height: 12),
                          Text(
                            'Prioridad',
                          ),
            RoundCheckBox(
              onTap: (selected) {},
              uncheckedColor: Colors.red,
              uncheckedWidget: Icon(Icons.close, color: Colors.white),
            ),

                const SizedBox(height: 16),
                ElevatedButton(
  onPressed: () {
    final nombreCliente = _nombreClienteController.text;
    final telefonoCliente = _telefonoClienteController.text;
    final importe = _importeController.text;
    final estadoPago = _estadoPagoController.text;
    final prioridad = _prioridadController.text;
    final observaciones = _observacionesController.text;
    final estado = _estadoController.text;

    context.read<CrearNotaBloc>().add(
      ValidarFormulario(
        nombreCliente: nombreCliente,
        telefonoCliente: telefonoCliente,
        fechaRecibido: _fechaRecibido,
        fechaEstimada: _fechaEstimada,
        importe: importe,
        estadoPago: estadoPago,
        prioridad: prioridad,
        observaciones: observaciones,
        estado: estado,
      ),
    );
  },
  child: const Text('Guardar Nota'),
)

              ],
            ),
          ),
        ),
      ),
    );
  }
}
