import 'package:flutter/material.dart';
import 'package:namer_app/provider/paymet_provider.dart';
import 'package:provider/provider.dart';

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
  void addService() {
    if (providerController.text.isEmpty || amountController.text.isEmpty || selectedDate == null) {
      return; // Puedes agregar un mensaje de error si lo deseas
    }


    final newService = Service(
      provider: providerController.text,
      amount: double.tryParse(amountController.text) ?? 0.0,
      dueDate: selectedDate!,
    );
    paymentProvder.serviceList.add(newService);

    setState(() {
      services.add(newService);
      providerController.clear();
      amountController.clear();
      selectedDate = null; // Reinicia la fecha
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

paymentProvder =  Provider.of<PaymentProvder>(context, listen: false);


    super.initState();
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
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Card(
                    child: ListTile(
                      title: Text(service.provider),
                      subtitle: Text("Monto: \$${service.amount}\nVencimiento: ${service.dueDate.toLocal()}".split(' ')[0]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            services.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Clase que representa un servicio
class Service {
  final String provider;
  final double amount;
  final DateTime dueDate;

  Service({
    required this.provider,
    required this.amount,
    required this.dueDate,
  });
}
