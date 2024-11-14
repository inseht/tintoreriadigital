import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintoreriadigital/repositorios/crearNotasRepositorio.dart';
import '../bloc/crearNotaBloc.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
  final TextEditingController _observacionesController = TextEditingController();

  String _fechaRecibido = '';
  String _fechaEstimada = '';
  int _prioridad = 2;
  String _estadoSeleccionado = 'Pendiente';
  String _servicioSeleccionado = 'Tintorería';
  List<Map<String, dynamic>> _prendas = [];
  int _idNota = 0; // Para almacenar el id de la nota una vez guardada.

  // Controladores para las prendas
  final TextEditingController _tipoPrendaController = TextEditingController();
  final TextEditingController _cantidadPrendaController = TextEditingController();
  final TextEditingController _precioPrendaController = TextEditingController();

  void _seleccionarFechaRecibido() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          height: 300,
          width: 300,
          child: SfDateRangePicker(
            selectionMode: DateRangePickerSelectionMode.single,
            onSelectionChanged: (args) {
              if (args.value is DateTime) {
                final DateTime selectedDate = args.value;
                setState(() {
                  _fechaRecibido = selectedDate.toString().split(' ')[0];
                  _fechaEstimada = selectedDate.add(Duration(days: 7)).toString().split(' ')[0];
                });
              }
            },
          ),
        ),
      ),
    );
  }

  void _togglePrioridad() {
    setState(() {
      _prioridad = _prioridad == 1 ? 2 : 1;
    });
  }

  void _agregarPrenda() {
    if (_tipoPrendaController.text.isEmpty ||
        _cantidadPrendaController.text.isEmpty ||
        _precioPrendaController.text.isEmpty) {
      return;
    }

    setState(() {
      _prendas.add({
        'tipo': _tipoPrendaController.text,
        'cantidad': int.parse(_cantidadPrendaController.text),
        'precioUnitario': double.parse(_precioPrendaController.text),
      });

      // Limpiar los controladores para la siguiente prenda
      _tipoPrendaController.clear();
      _cantidadPrendaController.clear();
      _precioPrendaController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CrearNotaBloc(repositorio: CrearNotasRepositorio()),
      child: Scaffold(
        body: BlocListener<CrearNotaBloc, CrearNotaState>(
          listener: (context, state) {
            if (state is FormularioValido) {
              context.read<CrearNotaBloc>().add(EnviarFormulario(
                nota: {
                  'nombreCliente': _nombreClienteController.text,
                  'telefonoCliente': _telefonoClienteController.text,
                  'fechaRecibido': _fechaRecibido,
                  'fechaEstimada': _fechaEstimada,
                  'importe': double.parse(_importeController.text),
                  'estadoPago': _estadoSeleccionado,
                  'prioridad': _prioridad,
                  'observaciones': _observacionesController.text,
                  'estado': _estadoSeleccionado,
                },
                prendas: _prendas,
              ));
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
          child: BlocBuilder<CrearNotaBloc, CrearNotaState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nombreClienteController,
                        decoration: const InputDecoration(labelText: 'Nombre del Cliente'),
                        validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _telefonoClienteController,
                        decoration: const InputDecoration(labelText: 'Teléfono del Cliente'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Campo requerido';
                          final regex = RegExp(r'^\d{10,}$');
                          return regex.hasMatch(value) ? null : 'Debe contener al menos 10 dígitos';
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _importeController,
                        decoration: const InputDecoration(labelText: 'Importe'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Campo requerido';
                          return double.tryParse(value) != null ? null : 'Debe ser un número';
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _seleccionarFechaRecibido,
                        child: Text(
                          _fechaRecibido.isEmpty ? 'Seleccionar Fecha Recibido' : 'Fecha Recibido: $_fechaRecibido',
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _estadoSeleccionado,
                        decoration: const InputDecoration(labelText: 'Estado'),
                        items: ['Pendiente', 'En Proceso', 'Finalizado']
                            .map((estado) => DropdownMenuItem(value: estado, child: Text(estado)))
                            .toList(),
                        onChanged: (valor) => setState(() => _estadoSeleccionado = valor!),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _servicioSeleccionado,
                        decoration: const InputDecoration(labelText: 'Servicio'),
                        items: ['Tintorería', 'Lavado', 'Planchado', 'Compostura']
                            .map((servicio) => DropdownMenuItem(value: servicio, child: Text(servicio)))
                            .toList(),
                        onChanged: (valor) => setState(() => _servicioSeleccionado = valor!),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _tipoPrendaController,
                        decoration: const InputDecoration(labelText: 'Tipo de Prenda'),
                      ),
                      TextFormField(
                        controller: _cantidadPrendaController,
                        decoration: const InputDecoration(labelText: 'Cantidad'),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: _precioPrendaController,
                        decoration: const InputDecoration(labelText: 'Precio Unitario'),
                        keyboardType: TextInputType.number,
                      ),
                      ElevatedButton(
                        onPressed: _agregarPrenda,
                        child: const Text('Agregar Prenda'),
                      ),
                      const SizedBox(height: 16),
                      // Mostrar las prendas agregadas
                      _prendas.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: _prendas.length,
                              itemBuilder: (context, index) {
                                final prenda = _prendas[index];
                                return ListTile(
                                  title: Text('Prenda: ${prenda['tipo']}'),
                                  subtitle: Text('Cantidad: ${prenda['cantidad']} - Precio: ${prenda['precioUnitario']}'),
                                );
                              },
                            )
                          : const Text('No hay prendas añadidas'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<CrearNotaBloc>().add(
                              ValidarFormulario(
                                nombreCliente: _nombreClienteController.text,
                                telefonoCliente: _telefonoClienteController.text,
                                fechaRecibido: _fechaRecibido,
                                fechaEstimada: _fechaEstimada,
                                importe: _importeController.text,
                                estadoPago: _estadoSeleccionado,
                                prioridad: _prioridad.toString(),
                                observaciones: _observacionesController.text,
                                estado: _estadoSeleccionado,
                              ),
                            );
                          }
                        },
                        child: const Text('Enviar Nota'),
                      ),
                    ],
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
