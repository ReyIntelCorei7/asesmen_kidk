import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/pembayaran_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pembayaran.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pembayaran_form.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pembayaran_page.dart';
import 'package:asesmen_kidk_rumah_sakit/widget/warning_dialog.dart';

class PembayaranDetail extends StatefulWidget {
  Pembayaran? pembayaran;
  PembayaranDetail({Key? key, this.pembayaran}) : super(key: key);

  @override
  _PembayaranDetailState createState() => _PembayaranDetailState();
}

class _PembayaranDetailState extends State<PembayaranDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pembayaran')),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text("ID Pembayaran: ${widget.pembayaran!.idPembayaran}", style: const TextStyle(fontSize: 20.0)),
            const SizedBox(height: 10),
            Text("ID Pemeriksaan: ${widget.pembayaran!.idPemeriksaan}", style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 10),
            Text("Total Tagihan: ${widget.pembayaran!.totalTagihan}", style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 10),
            Text("Tanggal Bayar: ${widget.pembayaran!.tanggalBayar ?? '-'}", style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 10),
            Text("Status: ${widget.pembayaran!.statusPembayaran ?? '-'}", style: const TextStyle(fontSize: 18.0)),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => PembayaranForm(pembayaran: widget.pembayaran!)));
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
            PembayaranBloc.deletePembayaran(id: widget.pembayaran!.idPembayaran!).then((value) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PembayaranPage()));
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
