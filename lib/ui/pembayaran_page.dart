import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/pembayaran_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pembayaran.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pasien_page.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pembayaran_detail.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pembayaran_form.dart';

class PembayaranPage extends StatefulWidget {
  const PembayaranPage({Key? key}) : super(key: key);

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Pembayaran'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PembayaranForm()));
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
              title: const Text('Pembayaran'),
              trailing: const Icon(Icons.payment),
              onTap: () {
                Navigator.pop(context); // Already on PembayaranPage
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List>(
        future: PembayaranBloc.getPembayarans(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListPembayaran(
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

class ListPembayaran extends StatelessWidget {
  final List? list;
  const ListPembayaran({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemPembayaran(
          pembayaran: list![i],
        );
      },
    );
  }
}

class ItemPembayaran extends StatelessWidget {
  final Pembayaran pembayaran;
  const ItemPembayaran({Key? key, required this.pembayaran}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PembayaranDetail(
              pembayaran: pembayaran,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text('Tanggal: ${pembayaran.tanggalBayar ?? ''}'),
          subtitle: Text('Status: ${pembayaran.statusPembayaran ?? ''} | Tagihan: ${pembayaran.totalTagihan ?? 0}'),
        ),
      ),
    );
  }
}
