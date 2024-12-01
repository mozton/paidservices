import 'package:flutter/material.dart';
import 'package:namer_app/provider/paymet_provider.dart';
import 'package:namer_app/screens/add_payment.dart';
import 'package:namer_app/screens/manage_services.dart';
import 'package:provider/provider.dart';
//import 'package:flutter/cupertino.dart';


class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  late PaymentProvder paymentProvder;

@override
  void initState() {
paymentProvder =  Provider.of<PaymentProvder>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ManageServicesScreen())); // Navega a la pantalla de administración de servicios
    
              // Navegar a la pantalla de Configuración
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Servicios Pendientes
            Text(
              "Servicios Pendientes de Pago",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount:paymentProvder.serviceList.length ,
                itemBuilder:(context,index){
final payment = paymentProvder.serviceList[index];

                  return PaymentCard(provider: payment.provider, amount: payment.amount, paymentDate: payment.dueDate.toString(), note: "");
                } ,
            
              ),
            ),
            SizedBox(height: 20),

            // Sección de Pagos Recientes
            Text(
              "Pagos Recientes",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                // children: [
                //   PaymentCard(
                //     provider: "Internet",
                //     amount: 50.0,
                //     paymentDate: "10 de octubre",
                //   ),
                //   PaymentCard(
                //     provider: "Teléfono",
                //     amount: 20.0,
                //     paymentDate: "9 de octubre",
                //   ),
                //   // Añadir más pagos como se requiera
                // ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddPaymentScreen())).then((value) {
            setState(() {
              
            });
          });
          // Navegar a la pantalla de Administración de Servicios
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Widget personalizado para los servicios pendientes
class ServiceCard extends StatelessWidget {
  final String provider;
  final double amount;
  final String dueDate;
  final bool isDueSoon;

  const ServiceCard({
    required this.provider,
    required this.amount,
    required this.dueDate,
    required this.isDueSoon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDueSoon ? Colors.redAccent.shade100 : Colors.greenAccent.shade100,
      child: ListTile(
        title: Text(provider),
        subtitle: Text("Vencimiento: $dueDate"),
        trailing: Text("\$$amount",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// Widget personalizado para los pagos recientes
class PaymentCard extends StatelessWidget {
  final String provider;
  final double amount;
  final String paymentDate;
  final String note;

  const PaymentCard({
    required this.provider,
    required this.amount,
    required this.paymentDate,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueAccent.shade100,
      child: ListTile(
        title: Text(provider),
        subtitle: Text("Fecha de Pago: $paymentDate"),
        trailing: Text("\$$amount",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
