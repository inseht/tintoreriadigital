import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:tintoreriadigital/bd/bdmodel.dart';
import 'package:tintoreriadigital/bloc/crearNotaBloc.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrearNota extends StatefulWidget {
  final Map<String, dynamic>? nota;

  const CrearNota({super.key, this.nota});

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
  final TextEditingController _precioUnitarioController = TextEditingController();
  final TextEditingController _colorController   = TextEditingController();

  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  String? _tipoPrendaSeleccionada;
  String? _estadoPagoNota = 'Pendiente';
  String? _estadoNota = 'Recibido'; 
  String? _servicioSeleccionado;
  String? _color;

  int _cantidadPrendas = 1;
  final List<Map<String, dynamic>> _prendas = [];

void _limpiarFormulario() {
  _nombreController.clear();
  _telefonoController.clear();
  _observacionesController.clear();
  _estadoPagoController.clear();
  _abonoController.clear();
  _importeTotalController.clear();
  _precioUnitarioController.clear();
  _colorController.clear();
  
  setState(() {
    _tipoPrendaSeleccionada = null;
    _servicioSeleccionado = null;
    _estadoPagoNota = 'Pendiente';
    _estadoNota = 'Recibido';
    _cantidadPrendas = 1;
    _prendas.clear(); 
    _fechaInicio = null; 
    _fechaFin = null; 
  });
}


  Future<void> _mostrarDatePicker(BuildContext context) async {
    DateTime fechaMinima = DateTime.now().subtract(Duration(days: 60));

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar rango de fechas'),
        content: SizedBox(
          height: 400,
          width: 300,
          child: SfDateRangePicker(
            selectionMode: DateRangePickerSelectionMode.range,
            minDate: fechaMinima, 
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

void _agregarPrenda() {
  if (_nombreController.text.trim().isEmpty || 
      _telefonoController.text.trim().isEmpty || 
      _fechaInicio == null || 
      _fechaFin == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, complete todos los campos principales de la nota antes de agregar una prenda'))
    );
    return;
  }

  double precioUnitario = double.tryParse(_precioUnitarioController.text) ?? 0.0;

  if (_tipoPrendaSeleccionada != null && 
      _cantidadPrendas > 0 && 
      _servicioSeleccionado != null && 
      precioUnitario > 0.0) {
    setState(() {
      _prendas.add({
        'tipo': _tipoPrendaSeleccionada,
        'servicio': _servicioSeleccionado,
        'precioUnitario': precioUnitario,
        'colores': _color,
        'cantidad': _cantidadPrendas,
      });

      double importeTotalActual = double.tryParse(_importeTotalController.text) ?? 0.0;
      _importeTotalController.text = (importeTotalActual + precioUnitario * _cantidadPrendas).toStringAsFixed(2);

      _tipoPrendaSeleccionada = null;
      _servicioSeleccionado = null;
      _cantidadPrendas = 1; 
      _precioUnitarioController.clear();
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, complete todos los campos de la prenda'))
    );
  }
}


void _crearNota() {
  if (_fechaInicio == null || _fechaFin == null || _nombreController.text.trim().isEmpty || _telefonoController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, complete todos los campos antes de crear la nota')),
    );
    return;
  }

  if (_prendas.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Debe agregar al menos una prenda antes de guardar la nota')),
    );
    return;
  }

  double importeFinal = (_estadoPagoNota == 'Pagado')
      ? double.tryParse(_importeTotalController.text) ?? 0.0
      : _prendas.fold<double>(0.0, (sum, prenda) => sum + (prenda['subtotal'] ?? 0.0));

  final Map<String, dynamic> nota = {
    'nombreCliente': _nombreController.text,
    'telefonoCliente': _telefonoController.text,
    'fechaRecibido': _fechaInicio,
    'fechaEstimada': _fechaFin,
    'importe': importeFinal,
    'estadoPago': _estadoPagoNota,
    'prioridad': 1,
    'observaciones': _observacionesController.text,
    'estado': _estadoNota,
  };

  context.read<CrearNotaBloc>().add(EnviarFormulario(nota: nota, prendas: _prendas));

  _limpiarFormulario();
}



    void _eliminarPrenda(int index) {
      setState(() {
        double precioUnitario = _prendas[index]['precioUnitario'];
        int cantidad = _prendas[index]['cantidad'];
        double importeParcial = precioUnitario * cantidad;

        _prendas.removeAt(index);

        // Recalcular el importe total después de eliminar la prenda
        double nuevoTotal = double.tryParse(_importeTotalController.text) ?? 0.0;
        _importeTotalController.text = (nuevoTotal - importeParcial).toStringAsFixed(2);
      });
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
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Información general',
                              style: TextStyle(fontSize: 19.0),
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
            BlocBuilder<CrearNotaBloc, CrearNotaState>(
              builder: (context, state) {
                if (state is CrearNotaInicial) {
                  return DropdownButtonFormField<String>(
                    value: _estadoNota,
                    items: state.estadosNota
                        .map((estado) => DropdownMenuItem<String>(
                              value: estado,
                              child: Text(estado),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _estadoNota = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Estado de la Nota',
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),

    const SizedBox(height: 8.0),

    BlocBuilder<CrearNotaBloc, CrearNotaState>(
      builder: (context, state) {
        if (state is CrearNotaInicial) {
          return DropdownButtonFormField<String>(
            value: state.estadosPago.contains(_estadoPagoNota) ? _estadoPagoNota : null,
            items: state.estadosPago.map((estado) {
              return DropdownMenuItem<String>(
                value: estado,
                child: Text(estado),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _estadoPagoNota = value!;
                if (_estadoPagoNota != 'Abono') {
                  _abonoController.clear();
                }
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Estado de pago',
              hintText: _prendas.isEmpty ? 'Agregue prendas primero' : null,
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    ),


Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: TextField(
    controller: _abonoController,
    enabled: _estadoPagoNota == 'Abono', 
    keyboardType: TextInputType.number,
    onChanged: (value) {
      setState(() {
        double abono = double.tryParse(value) ?? 0.0;
        double importeTotalActual = _prendas.fold<double>(0.0, (sum, prenda) => sum + prenda['subtotal']);
        _importeTotalController.text = (importeTotalActual - abono).toStringAsFixed(2);
      });
    },
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
            enabled: false, 
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Importe total',
            ),
          ),
        ),

                              ],
                            ),
                            const SizedBox(height: 8.0),
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
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Prendas',
                              style: TextStyle(fontSize: 19.0),
                            ),
                            const SizedBox(height: 8.0),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: BlocBuilder<CrearNotaBloc, CrearNotaState>(
  builder: (context, state) {
    if (state is CrearNotaInicial) {
      return DropdownButtonFormField<String>(
  value: _tipoPrendaSeleccionada,
  items: state.tiposPrenda
      .map((tipo) => DropdownMenuItem<String>(
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
);

    }
    return CircularProgressIndicator(); 
  },
),

                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: BlocBuilder<CrearNotaBloc, CrearNotaState>(
  builder: (context, state) {
    if (state is CrearNotaInicial) {
      return DropdownButtonFormField<String>(
        value: _servicioSeleccionado,
        items: state.servicios
            .map((servicio) => DropdownMenuItem<String>(
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
      );
    }
    return CircularProgressIndicator(); 
  },
),

                                ),

                                
Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: TextField(
    enabled: false, 
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Cantidad de prendas',
    ),
    controller: TextEditingController(text: '1'), 
  ),
),
Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: BlocBuilder<CrearNotaBloc, CrearNotaState>(
    builder: (context, state) {
      if (state is CrearNotaInicial) {
        return DropdownButtonFormField<String>(
          value: _color,
          items: state.colores
              .map((color) => DropdownMenuItem<String>(
                    value: color,
                    child: Text(color),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _color = value; 
            });
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Colores',
          ),
        );
      }
      return const CircularProgressIndicator();
    },
  ),
),

                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextField(
                                    controller: _precioUnitarioController, 
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
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40), 
                minimumSize: const Size(200, 70),
              ),
    child: const Text('Agregar prenda'),
  ),
),
const SizedBox(height: 16.0),
if (_prendas.isNotEmpty)
  Expanded(
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
  columns: const [
    DataColumn(label: Text('Tipo')),
    DataColumn(label: Text('Servicio')),
    DataColumn(label: Text('Cantidad')),
    DataColumn(label: Text('Precio Unitario')),
    DataColumn(label: Text('Subtotal')),
  ],
  rows: _prendas.map(
    (prenda) {
      double subtotal = prenda['precioUnitario'] != null && prenda['cantidad'] != null
          ? prenda['precioUnitario'] * prenda['cantidad']
          : 0.0;

      return DataRow(
        cells: [
          DataCell(Text(prenda['tipo'] ?? '')),
          DataCell(Text(prenda['servicio'] ?? '')),
          DataCell(Text(prenda['cantidad'].toString())),
          DataCell(Text(prenda['precioUnitario'].toStringAsFixed(2))),
          DataCell(Text(subtotal.toStringAsFixed(2))),
        ],
      );
    },
  ).toList(),
)

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
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40), 
                minimumSize: const Size(200, 70),
              ),
              child: const Text(
                'Crear nota',
                style: TextStyle(fontSize: 30), 
              ),
            ),
          ),
          const SizedBox(height: 100.0),
        ],
        
      ),
    );
  }
}
