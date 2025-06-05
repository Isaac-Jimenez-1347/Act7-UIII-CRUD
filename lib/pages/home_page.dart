import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_services.dart'
    show deletePeople, getPeople;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mi CRUD Jimenez Hernandez", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 136, 132, 133),
      ),

      body: FutureBuilder(
        future: getPeople(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  onDismissed: (direction) async {
                    await deletePeople(snapshot.data?[index]['uid']);
                    snapshot.data?.removeAt(index);
                  },
                  confirmDismiss: (direction) async {
                    bool result = false;

                    result = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "¿Está seguro que quiere eliminar a ${snapshot.data?[index]['name']}?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                return Navigator.pop(context, false);
                              },
                              child: Text(
                                "Cancelar",
                                style: TextStyle(color: const Color.fromARGB(255, 133, 9, 0)),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                return Navigator.pop(context, true);
                              },
                              child: Text(
                                "Sí, estoy seguro",
                                style: TextStyle(color: const Color.fromARGB(255, 5, 80, 141)),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    return result;
                  },
                  background: Container(
                    color: const Color.fromARGB(255, 131, 9, 0),
                    child: const Icon(Icons.delete),
                  ),
                  direction: DismissDirection.endToStart,

                  key: Key(snapshot.data?[index]['uid']),

                  child: ListTile(
                    title: Text(snapshot.data?[index]['name']),
                    onTap: (() async {
                      await Navigator.pushNamed(
                        context,
                        "/edit",
                        arguments: {
                          'name': snapshot.data?[index]['name'],
                          'uid': snapshot.data?[index]['uid'],
                        },
                      );
                      setState(() {});
                    }),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Cargando...'));
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');

          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}