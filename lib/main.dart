import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_flutter_demo/data_model.dart';
import 'package:new_flutter_demo/database_helper.dart';
import 'package:new_flutter_demo/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var future;
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    future = Services.callAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo Listing"),
        centerTitle: true,
        actions: [
          TextButton(onPressed: (){
            dbHelper.queryAll();
          }, child: Icon(Icons.menu,color: Colors.white))
        ],
      ),
      body: FutureBuilder<Object>(
          future: future,
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.done) {
              var dataModel = snapshot.data as DataModel;
              return ListView.builder(
                  itemCount: dataModel.orderInfo?.orders?.length ?? 0,
                  itemBuilder: (context, index) {
                    Order? item = dataModel.orderInfo?.orders?[index];
                    String exptected_date = DateFormat('dd-MM-yyyy').format(DateTime.parse(item?.expected_date ??'' ));
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item?.order_id.toString() ?? 'order_id'),
                          Text(item?.order_type ?? 'order_type')
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Text('${item?.sequence_no.toString() ?? 'sequence_no'} ${((item?.sequence_no ?? 0) %2 == 0) ? 'prime' : 'not prime'}'),
                          const SizedBox(width: 10),
                          Text(exptected_date),
                        ],
                      ),
                      trailing: IconButton(icon: Icon(Icons.save), onPressed: ()async {
                        final id = await dbHelper.insert(item ?? Order(order_id: 1,order_type: "order_type"));
                      }),
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete_forever),
        onPressed: () {
          dbHelper.deleteAll();
        },
      ),
    );
  }
}
