import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/logout_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/pasien_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pasien.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/login_page.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pasien_detail.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pasien_form.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/poli_page.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/dokter_page.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pemeriksaan_page.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/resep_page.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/obat_page.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pembayaran_page.dart';

class PasienPage extends StatefulWidget {
  const PasienPage({Key? key}) : super(key: key);

  @override
  _PasienPageState createState() => _PasienPageState();
}

class _PasienPageState extends State<PasienPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Pasien'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PasienForm()));
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu Rumah Sakit',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Pasien'),
              trailing: const Icon(Icons.person),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const PasienPage()));
              },
            ),
            ListTile(
              title: const Text('Poli'),
              trailing: const Icon(Icons.local_hospital),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const PoliPage()));
              },
            ),
            ListTile(
              title: const Text('Dokter'),
              trailing: const Icon(Icons.medical_services),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const DokterPage()));
              },
            ),
            ListTile(
              title: const Text('Pemeriksaan'),
              trailing: const Icon(Icons.assignment),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PemeriksaanPage()));
              },
            ),
            ListTile(
              title: const Text('Resep'),
              trailing: const Icon(Icons.receipt),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const ResepPage()));
              },
            ),
            ListTile(
              title: const Text('Obat'),
              trailing: const Icon(Icons.medication),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const ObatPage()));
              },
            ),
            ListTile(
              title: const Text('Pembayaran'),
              trailing: const Icon(Icons.payment),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PembayaranPage()));
              },
            ),
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()))
                    });
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List>(
        future: PasienBloc.getPasiens(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListPasien(
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

class ListPasien extends StatelessWidget {
  final List? list;
  const ListPasien({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemPasien(
          pasien: list![i],
        );
      },
    );
  }
}

class ItemPasien extends StatelessWidget {
  final Pasien pasien;
  const ItemPasien({Key? key, required this.pasien}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasienDetail(
              pasien: pasien,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(pasien.namaPasien ?? ''),
          subtitle: Text('RM: ${pasien.noRekamMedis ?? ''} | NIK: ${pasien.nikKtp ?? ''}'),
        ),
      ),
    );
  }
}
