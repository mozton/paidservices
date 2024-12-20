import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:namer_app/provider/paymet_provider.dart';
import 'package:namer_app/screens/add_payment.dart';
import 'package:namer_app/screens/manage_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:namer_app/database/datebase_helper.dart';
//import 'package:flutter/cupertino.dart';


class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  late PaymentProvder paymentProvder;
  late DatabaseHelper databaseHelper;

@override
void initState() {
  super.initState();
  paymentProvder = Provider.of<PaymentProvder>(context, listen: false);
  databaseHelper = DatabaseHelper();
  loadServices();
}

void loadServices() async {

  final serviceList = await DatabaseHelper().getServices();
  setState(() {
    paymentProvder.serviceList = serviceList.map((service) {
      return Service(
        bill: service.bill,
        provider: service.provider,
        amount: service.amount,
        dueDate: DateTime.parse(service.dueDate.toString()),
      );
    }).toList();
  });
}

 getservices () async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();


 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      

      
      body: DecoratedBox (



        decoration: BoxDecoration(
          gradient: LinearGradient(begin:Alignment.topCenter,
          colors: [Colors.blue,Colors.red])


        ) ,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
             

              children: [
                 Row(
                   children: [
                    Spacer(),
                    IconButton(
                                 icon: Icon(Icons.add_business),
                                 color: Colors.white70,
                                 iconSize: 35,
                                 
                               
                                 
                                 onPressed: () {
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => ManageServicesScreen())); // Navega a la pantalla de administración de servicios
                         
                                   // Navegar a la pantalla de Configuración
                                 },
                               ),
                   ],
                 ),
                // Sección de Servicios Pendientes
                Text(
                  "Servicios Pendientes de Pago",
                 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                   
                ),
                SizedBox(height: 10),
                Expanded(
  child: Scrollbar(
    child: ListView.builder(
      itemCount: paymentProvder.serviceList.length,
      itemBuilder: (context, index) {
        final service = paymentProvder.serviceList[index];
        String formattedDate = DateFormat('yyyy-MM-dd').format(service.dueDate);
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: ServiceCard(
            id: service.id,
            databaseHelper: databaseHelper,
            provider: service.provider,
            amount: service.amount,
            dueDate: formattedDate,
            isDueSoon: service.dueDate.isBefore(DateTime.now().add(Duration(days: 3))),
          ),
        );
      },
    ),
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ManageServicesScreen()),
          ).then((_) {
            loadServices(); //Recarga los servicios cuando regrese al dashboard
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
  final int? id;
  final String provider;
  final double amount;
  final String dueDate;
  final bool isDueSoon;
  final DatabaseHelper databaseHelper;

  const ServiceCard({
    required this.id,
    required this.provider,
    required this.amount,
    required this.dueDate,
    required this.isDueSoon,
    required this.databaseHelper
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),

      endActionPane: ActionPane(

        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: (){}), 
        children:  [
                SlidableAction(
           
            borderRadius: BorderRadius.circular(20),
            backgroundColor:(Colors.purple),
            foregroundColor: Colors.grey,
            icon: Icons.edit,
            label: 'Edit',
            onPressed:(context,)async{
              await databaseHelper.deleteService(id!);
         }),
       
          SlidableAction(
              
            borderRadius: BorderRadius.circular(20),
            backgroundColor: 
            Color(0xFFFE4A49),
            foregroundColor: Colors.grey,
            icon: Icons.delete,
            label: 'Delete',
            onPressed:(context,){
         }),
        
        
        ] ),

      child: Card(
        color: isDueSoon ? Colors.redAccent.shade100 : Colors.greenAccent.shade100,
        child: ListTile(
          title: Text(provider),
          subtitle: Text("Vencimiento: $dueDate"),
          trailing: Text("\$$amount",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
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
    
    return  Card(
      margin: EdgeInsets.zero,
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
