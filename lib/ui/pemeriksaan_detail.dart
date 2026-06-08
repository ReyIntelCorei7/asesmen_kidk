import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/pemeriksaan_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pemeriksaan.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pemeriksaan_form.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pemeriksaan_page.dart';
import 'package:asesmen_kidk_rumah_sakit/widget/warning_dialog.dart';

class PemeriksaanDetail extends StatefulWidget {
  final Pemeriksaan? pemeriksaan;
  const PemeriksaanDetail({super.key, this.pemeriksaan});

  @override
  _PemeriksaanDetailState createState() => _PemeriksaanDetailState();
}

class _PemeriksaanDetailState extends State<PemeriksaanDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pemeriksaan')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text("ID Pemeriksaan: ${widget.pemeriksaan!.idPemeriksaan}", style: const TextStyle(fontSize: 20.0)),
              const SizedBox(height: 10),
              Text("Pasien: ${widget.pemeriksaan!.namaPasien ?? widget.pemeriksaan!.noRekamMedis}", style: const TextStyle(fontSize: 18.0)),
              const SizedBox(height: 10),
              Text("Dokter: ${widget.pemeriksaan!.namaDokter ?? widget.pemeriksaan!.idDokter}", style: const TextStyle(fontSize: 18.0)),
              const SizedBox(height: 10),
              Text("Tanggal: ${widget.pemeriksaan!.tanggalPeriksa ?? '-'}", style: const TextStyle(fontSize: 18.0)),
              const SizedBox(height: 10),
              Text("Diagnosis: ${widget.pemeriksaan!.diagnosis ?? '-'}", style: const TextStyle(fontSize: 18.0)),
              const SizedBox(height: 10),
              Text("Tindakan: ${widget.pemeriksaan!.tindakan ?? '-'}", style: const TextStyle(fontSize: 18.0)),
              const SizedBox(height: 10),
              Text("Biaya: ${widget.pemeriksaan!.biayaPemeriksaan}", style: const TextStyle(fontSize: 18.0)),
              const SizedBox(height: 20),
              _tombolHapusEdit(),
            ],
          ),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => PemeriksaanForm(pemeriksaan: widget.pemeriksaan!)));
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
            PemeriksaanBloc.deletePemeriksaan(id: widget.pemeriksaan!.idPemeriksaan!).then((value) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PemeriksaanPage()));
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
