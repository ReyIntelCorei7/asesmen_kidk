import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/resep_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/resep.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/resep_form.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/resep_page.dart';
import 'package:asesmen_kidk_rumah_sakit/widget/warning_dialog.dart';

class ResepDetail extends StatefulWidget {
  final Resep? resep;
  const ResepDetail({super.key, this.resep});

  @override
  _ResepDetailState createState() => _ResepDetailState();
}

class _ResepDetailState extends State<ResepDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Resep')),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text("ID Resep: ${widget.resep!.idResep}", style: const TextStyle(fontSize: 20.0)),
            const SizedBox(height: 10),
            Text("ID Pemeriksaan: ${widget.resep!.idPemeriksaan}", style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 10),
            Text("No Rekam Medis: ${widget.resep!.noRekamMedis}", style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 10),
            Text("ID Dokter: ${widget.resep!.idDokter}", style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 10),
            Text("Tanggal: ${widget.resep!.tanggalResep ?? '-'}", style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 10),
            Text("Total Biaya: ${widget.resep!.totalBiayaObat}", style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 20),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ResepForm(resep: widget.resep!)));
          },
        ),
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            ResepBloc.deleteResep(id: widget.resep!.idResep!).then((value) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ResepPage()));
            }, onError: (error) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => const WarningDialog(description: "Hapus gagal, silahkan coba lagi"),
              );
            });
          },
        ),
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(builder: (context) => alertDialog, context: context);
  }
}
