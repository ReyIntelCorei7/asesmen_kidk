import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/poli_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/poli.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pasien_page.dart'; // Using PasienPage for drawer
import 'package:asesmen_kidk_rumah_sakit/ui/poli_detail.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/poli_form.dart';

class PoliPage extends StatefulWidget {
  const PoliPage({Key? key}) : super(key: key);

  @override
  _PoliPageState createState() => _PoliPageState();
}

class _PoliPageState extends State<PoliPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Poli'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PoliForm()));
              },
            ),
          )
        ],
      ),
      // Drawer is typically unified, for now we will just provide a simple back or unified drawer.
      // To keep it simple and follow the pattern, we'll reuse the drawer or just provide back navigation if it's not the main page.
      // Actually, since PasienPage has the full drawer, users can navigate from there. 
      // Let's add the same drawer here for consistency.
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu Rumah Sakit', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text('Pasien'),
              trailing: const Icon(Icons.person),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PasienPage()));
              },
            ),
            ListTile(
              title: const Text('Poli'),
              trailing: const Icon(Icons.local_hospital),
              onTap: () {
                Navigator.pop(context); // Already on PoliPage
              },
            ),
            // Other menu items omitted for brevity, user can go to PasienPage to see all
          ],
        ),
      ),
      body: FutureBuilder<List>(
        future: PoliBloc.getPolis(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListPoli(
                  list: snapshot.data,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class ListPoli extends StatelessWidget {
  final List? list;
  const ListPoli({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemPoli(
          poli: list![i],
        );
      },
    );
  }
}

class ItemPoli extends StatelessWidget {
  final Poli poli;
  const ItemPoli({Key? key, required this.poli}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PoliDetail(
              poli: poli,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(poli.namaPoli ?? ''),
          subtitle: Text('Ruangan: ${poli.lokasiRuangan ?? ''}'),
        ),
      ),
    );
  }
}
