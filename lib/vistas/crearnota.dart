import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintoreriadigital/repositorios/crearNotasRepositorio.dart';
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
          child: SfDateRangePicker(
            selectionMode: DateRangePickerSelectionMode.range,
            onSelectionChanged: (args) {
              if (args.value is PickerDateRange) {
                final DateTime startDate = args.value.startDate;
                final DateTime? endDate = args.value.endDate;
                setState(() {
                  _fechaRecibido = startDate.toString().split(' ')[0];
                  _fechaEstimada = (endDate ?? startDate).toString().split(' ')[0];
                });
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CrearNotaBloc(
    repositorio: CrearNotasRepositorio(), 
  ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crear Nota'),
        ),
        body: BlocListener<CrearNotaBloc, CrearNotaState>(
          listener: (context, state) {
            if (state is FormularioValido) {
              // Simulación de envío de datos
              context.read<CrearNotaBloc>().add(EnviarFormulario());
            } else if (state is FormularioEnviado) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Formulario enviado con éxito')),
              );
            } else if (state is FormularioInvalido) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.mensaje)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              TextFormField(
                                controller: _importeController,
                                decoration: const InputDecoration(
                                  labelText: 'Importe',
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _seleccionarFechaRecibido,
                                child: Text(
                                  _fechaRecibido.isEmpty
                                      ? 'Seleccionar Fecha Recibido'
                                      : 'Fecha Recibido: $_fechaRecibido',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                          ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final nombreCliente = _nombreClienteController.text;
                        final telefonoCliente = _telefonoClienteController.text;
                        final importe = _importeController.text;
                        final estadoPago = _estadoPagoController.text;
                        final prioridad = _prioridadController.text;
                        final observaciones = _observacionesController.text;
                        final estado = _estadoController.text;

                        // Enviar el evento de validación
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
