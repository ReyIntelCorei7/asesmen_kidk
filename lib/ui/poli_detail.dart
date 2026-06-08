import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/poli_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/poli.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/poli_form.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/poli_page.dart';
import 'package:asesmen_kidk_rumah_sakit/widget/warning_dialog.dart';

class PoliDetail extends StatefulWidget {
  final Poli? poli;
  const PoliDetail({super.key, this.poli});

  @override
  _PoliDetailState createState() => _PoliDetailState();
}

class _PoliDetailState extends State<PoliDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Poli')),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text("ID Poli: ${widget.poli!.idPoli}", style: const TextStyle(fontSize: 20.0)),
            const SizedBox(height: 10),
            Text("Nama Poli: ${widget.poli!.namaPoli}", style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 10),
            Text("Lokasi Ruangan: ${widget.poli!.lokasiRuangan ?? '-'}", style: const TextStyle(fontSize: 18.0)),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => PoliForm(poli: widget.poli!)));
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
            PoliBloc.deletePoli(id: widget.poli!.idPoli!).then((value) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PoliPage()));
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
