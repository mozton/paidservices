import 'package:flutter/material.dart';
import 'package:namer_app/provider/paymet_provider.dart';
import 'package:provider/provider.dart';
import 'package:namer_app/database/datebase_helper.dart';


class ManageServicesScreen extends StatefulWidget {
  @override
  _ManageServicesScreenState createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
  final List<Service> services = [];
  final TextEditingController providerController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  DateTime? selectedDate;
  late PaymentProvder paymentProvder;
  void addService() async {
  if (providerController.text.isEmpty || amountController.text.isEmpty || selectedDate == null) {
    return; // Valida los datos antes de continuar
  }

  final newService = Service(
    provider: providerController.text,
    amount: double.tryParse(amountController.text) ?? 0.0,
    dueDate: selectedDate!,
  );

  // Insertar el servicio en la base de datos y obtener el ID
  final id = await DatabaseHelper().insertService(newService);

  setState(() {
    services.add(
      Service(
        bill: id, // Asigna el ID generado
        provider: newService.provider,
        amount: newService.amount,
        dueDate: newService.dueDate,
      ),
    );
    providerController.clear();
    amountController.clear();
    selectedDate = null;
  });
}

  
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
void initState() {
  super.initState();
  loadServices();
}

void loadServices() async {
  final serviceList = await DatabaseHelper().getServices();
  setState(() {
    services.addAll(serviceList.map((service) {
      return Service(
        provider: service.provider,
        amount: service.amount,
        dueDate: DateTime.parse(service.dueDate.toString()),
      );
    }).toList());
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Administrar Servicios"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formulario para agregar un servicio
            TextField(
              controller: providerController,
              decoration: InputDecoration(labelText: "Nombre del Proveedor"),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Importe"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selectedDate != null
                    ? "Fecha de Vencimiento: ${selectedDate!.toLocal()}".split(' ')[0]
                    : "Seleccionar Fecha"),
                TextButton(
                  onPressed: () => selectDate(context),
                  child: Text("Seleccionar"),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: addService,
              child: Text("Agregar Servicio"),
            ),
            SizedBox(height: 20),

            // Lista de Servicios Existentes
           
          ],
        ),
      ),
    );
  }
}

// Clase que representa un servicio
class Service {
  final int? id;
  final int? bill;
  final String provider;
  final double amount;
  final DateTime dueDate;

  Service({
    this.bill,
    required this.provider,
    required this.amount,
    required this.dueDate,
     this.id
  });
   // Convertir un objeto Service a un Map (para SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // SQLite generará el ID automáticamente si es nulo
      'bill': bill, // SQLite generará el ID automáticamente si es nulo
      'provider': provider,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  // Crear un objeto Service a partir de un Map (de SQLite)
  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      bill: map['id'], // Asigna el ID desde la base de datos
      provider: map['provider'],
      amount: map['amount'],
      dueDate: DateTime.parse(map['dueDate']),
    );
  }
}

