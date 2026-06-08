import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/obat_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/obat.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/obat_form.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/obat_page.dart';
import 'package:asesmen_kidk_rumah_sakit/widget/warning_dialog.dart';

class ObatDetail extends StatefulWidget {
  Obat? obat;
  ObatDetail({Key? key, this.obat}) : super(key: key);

  @override
  _ObatDetailState createState() => _ObatDetailState();
}

class _ObatDetailState extends State<ObatDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Obat')),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text("ID Obat: ${widget.obat!.idObat}", style: const TextStyle(fontSize: 20.0)),
            const SizedBox(height: 10),
            Text("Nama Obat: ${widget.obat!.namaObat}", style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 10),
            Text("Stok: ${widget.obat!.stok}", style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 10),
            Text("Harga Satuan: ${widget.obat!.hargaSatuan}", style: const TextStyle(fontSize: 18.0)),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => ObatForm(obat: widget.obat!)));
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
            ObatBloc.deleteObat(id: widget.obat!.idObat!).then((value) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ObatPage()));
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
