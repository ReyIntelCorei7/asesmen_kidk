import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/dokter_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/dokter.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/dokter_detail.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/dokter_form.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pasien_page.dart';

class DokterPage extends StatefulWidget {
  const DokterPage({super.key});

  @override
  _DokterPageState createState() => _DokterPageState();
}

class _DokterPageState extends State<DokterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Dokter'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DokterForm()));
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
              title: const Text('Dokter'),
              trailing: const Icon(Icons.medical_services),
              onTap: () {
                Navigator.pop(context); // Already on DokterPage
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List>(
        future: DokterBloc.getDokters(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListDokter(
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

class ListDokter extends StatelessWidget {
  final List? list;
  const ListDokter({super.key, this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemDokter(
          dokter: list![i],
        );
      },
    );
  }
}

class ItemDokter extends StatelessWidget {
  final Dokter dokter;
  const ItemDokter({super.key, required this.dokter});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DokterDetail(
              dokter: dokter,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(dokter.namaDokter ?? ''),
          subtitle: Text('Spesialisasi: ${dokter.spesialisasi ?? ''} | Poli: ${dokter.namaPoli ?? ''}'),
        ),
      ),
    );
  }
}
