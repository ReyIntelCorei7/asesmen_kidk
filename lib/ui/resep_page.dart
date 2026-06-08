import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/resep_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/resep.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pasien_page.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/resep_detail.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/resep_form.dart';

class ResepPage extends StatefulWidget {
  const ResepPage({super.key});

  @override
  _ResepPageState createState() => _ResepPageState();
}

class _ResepPageState extends State<ResepPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Resep'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ResepForm()));
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
              title: const Text('Resep'),
              trailing: const Icon(Icons.receipt),
              onTap: () {
                Navigator.pop(context); // Already on ResepPage
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List>(
        future: ResepBloc.getReseps(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListResep(
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

class ListResep extends StatelessWidget {
  final List? list;
  const ListResep({super.key, this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemResep(
          resep: list![i],
        );
      },
    );
  }
}

class ItemResep extends StatelessWidget {
  final Resep resep;
  const ItemResep({super.key, required this.resep});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResepDetail(
              resep: resep,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text('Tanggal: ${resep.tanggalResep ?? ''}'),
          subtitle: Text('Total Biaya: ${resep.totalBiayaObat ?? 0}'),
        ),
      ),
    );
  }
}
