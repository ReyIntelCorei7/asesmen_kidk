import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/pemeriksaan_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pemeriksaan.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pasien_page.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pemeriksaan_detail.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pemeriksaan_form.dart';

class PemeriksaanPage extends StatefulWidget {
  const PemeriksaanPage({super.key});

  @override
  _PemeriksaanPageState createState() => _PemeriksaanPageState();
}

class _PemeriksaanPageState extends State<PemeriksaanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Pemeriksaan'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PemeriksaanForm()));
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
              title: const Text('Pemeriksaan'),
              trailing: const Icon(Icons.assignment),
              onTap: () {
                Navigator.pop(context); // Already on PemeriksaanPage
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List>(
        future: PemeriksaanBloc.getPemeriksaans(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListPemeriksaan(
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

class ListPemeriksaan extends StatelessWidget {
  final List? list;
  const ListPemeriksaan({super.key, this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemPemeriksaan(
          pemeriksaan: list![i],
        );
      },
    );
  }
}

class ItemPemeriksaan extends StatelessWidget {
  final Pemeriksaan pemeriksaan;
  const ItemPemeriksaan({super.key, required this.pemeriksaan});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PemeriksaanDetail(
              pemeriksaan: pemeriksaan,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text('Tanggal: ${pemeriksaan.tanggalPeriksa ?? ''}'),
          subtitle: Text('Diagnosis: ${pemeriksaan.diagnosis ?? ''}'),
        ),
      ),
    );
  }
}
