import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class prioridadesCalendario extends StatelessWidget {
  const prioridadesCalendario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
          headerStyle: HeaderStyle(
            formatButtonVisible: false, 
            titleCentered: true, 
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black), 
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.blue, 
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Color.fromRGBO(67, 97, 119, 1), 
              shape: BoxShape.circle,
            ),
            outsideDecoration: BoxDecoration(
              color: Colors.transparent, 
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:tintoreriadigital/repositorios/prioridadesRepositorio.dart'; 
// import 'package:intl/intl.dart';

// class PrioridadesCalendario extends StatefulWidget {
//   const PrioridadesCalendario({super.key});

//   @override
//   _PrioridadesCalendarioState createState() => _PrioridadesCalendarioState();
// }

// class _PrioridadesCalendarioState extends State<PrioridadesCalendario> {
//   late Future<Map<DateTime, List<String>>> _eventos;

//   @override
//   void initState() {
//     super.initState();
//     final prioridadesRepositorio = PrioridadesRepositorio();
//     _eventos = _obtenerEventos(prioridadesRepositorio);
//   }

//   Future<Map<DateTime, List<String>>> _obtenerEventos(PrioridadesRepositorio repositorio) async {
//     final notasConPrioridad1 = await repositorio.obtenerNotasConPrioridad1();
//     return repositorio.mapearEventos(notasConPrioridad1); 
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: FutureBuilder<Map<DateTime, List<String>>>(
//           future: _eventos,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('No hay notas con prioridad 1.'));
//             } else {
//               final eventos = snapshot.data!;

//               return TableCalendar(
//                 firstDay: DateTime.utc(2010, 10, 16),
//                 lastDay: DateTime.utc(2030, 3, 14),
//                 focusedDay: DateTime.now(),
//                 headerStyle: const HeaderStyle(
//                   formatButtonVisible: false,
//                   titleCentered: true,
//                   leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
//                   rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
//                 ),
//                 calendarStyle: const CalendarStyle(
//                   selectedDecoration: BoxDecoration(
//                     color: Colors.blue,
//                     shape: BoxShape.circle,
//                   ),
//                   todayDecoration: BoxDecoration(
//                     color: Color.fromRGBO(67, 97, 119, 1),
//                     shape: BoxShape.circle,
//                   ),
//                   outsideDecoration: BoxDecoration(
//                     color: Colors.transparent,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 eventLoader: (day) {
//                   return eventos[day] ?? [];
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
