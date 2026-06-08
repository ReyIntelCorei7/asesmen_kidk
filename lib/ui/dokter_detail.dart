import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/dokter_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/dokter.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/dokter_form.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/dokter_page.dart';
import 'package:asesmen_kidk_rumah_sakit/widget/warning_dialog.dart';

class DokterDetail extends StatefulWidget {
  final Dokter? dokter;
  const DokterDetail({super.key, this.dokter});

  @override
  _DokterDetailState createState() => _DokterDetailState();
}

class _DokterDetailState extends State<DokterDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Dokter')),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text("ID Dokter: ${widget.dokter!.idDokter}", style: const TextStyle(fontSize: 20.0)),
            const SizedBox(height: 10),
            Text("Nama Dokter: ${widget.dokter!.namaDokter}", style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 10),
            Text("Spesialisasi: ${widget.dokter!.spesialisasi ?? '-'}", style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 10),
            Text("ID Poli: ${widget.dokter!.idPoli}", style: const TextStyle(fontSize: 18.0)),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => DokterForm(dokter: widget.dokter!)));
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
            DokterBloc.deleteDokter(id: widget.dokter!.idDokter!).then((value) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DokterPage()));
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
