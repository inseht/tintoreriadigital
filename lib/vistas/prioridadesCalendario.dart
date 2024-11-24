import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tintoreriadigital/bd/bdmodel.dart';

class prioridadesCalendario extends StatefulWidget {
  const prioridadesCalendario({super.key});

  @override
  State<prioridadesCalendario> createState() => _PrioridadesCalendarioState();
}

class _PrioridadesCalendarioState extends State<prioridadesCalendario> {
late Map<DateTime, List<Map<String, dynamic>>> _eventos = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _cargarEventos();
  }

  Future<void> _cargarEventos() async {
    final eventos = await BdModel.fetchEventos();
    setState(() {
      _eventos = eventos;
    });
  }

  List<Map<String, dynamic>> _getEventosDelDia(DateTime day) {
    return _eventos[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendario con Pedidos')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventosDelDia,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: _getEventosDelDia(_selectedDay ?? _focusedDay)
                  .map((evento) => ListTile(
                        title: Text(evento['nombreCliente']),
                        subtitle: Text(
                          'Tel: ${evento['telefonoCliente']} - Estado: ${evento['estado']}',
                        ),
                        trailing: Text('\$${evento['importe'].toStringAsFixed(2)}'),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(evento['nombreCliente']),
                              content: Text(
                                'Fecha Estimada: ${evento['fechaEstimada']}\n'
                                'Importe: \$${evento['importe'].toStringAsFixed(2)}\n'
                                'Estado Pago: ${evento['estadoPago']}\n'
                                'Observaciones: ${evento['observaciones'] ?? "N/A"}',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cerrar'),
                                ),
                              ],
                            ),
                          );
                        },
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
