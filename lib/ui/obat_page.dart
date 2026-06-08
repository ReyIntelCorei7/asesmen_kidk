import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/obat_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/obat.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pasien_page.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/obat_detail.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/obat_form.dart';

class ObatPage extends StatefulWidget {
  const ObatPage({super.key});

  @override
  _ObatPageState createState() => _ObatPageState();
}

class _ObatPageState extends State<ObatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Obat'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ObatForm()));
              },
            ),
          )
        ],
      ),
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
              title: const Text('Obat'),
              trailing: const Icon(Icons.medication),
              onTap: () {
                Navigator.pop(context); // Already on ObatPage
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List>(
        future: ObatBloc.getObats(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListObat(
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

class ListObat extends StatelessWidget {
  final List? list;
  const ListObat({super.key, this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemObat(
          obat: list![i],
        );
      },
    );
  }
}

class ItemObat extends StatelessWidget {
  final Obat obat;
  const ItemObat({super.key, required this.obat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ObatDetail(
              obat: obat,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(obat.namaObat ?? ''),
          subtitle: Text('Harga: ${obat.hargaSatuan ?? 0} | Stok: ${obat.stok ?? 0}'),
        ),
      ),
    );
  }
}
