import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/pasien_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pasien.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pasien_form.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pasien_page.dart';
import 'package:asesmen_kidk_rumah_sakit/widget/warning_dialog.dart';

class PasienDetail extends StatefulWidget {
  Pasien? pasien;
  PasienDetail({Key? key, this.pasien}) : super(key: key);

  @override
  _PasienDetailState createState() => _PasienDetailState();
}

class _PasienDetailState extends State<PasienDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pasien'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "No Rekam Medis: ${widget.pasien!.noRekamMedis}",
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 10),
            Text(
              "Nama: ${widget.pasien!.namaPasien}",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10),
            Text(
              "NIK KTP: ${widget.pasien!.nikKtp}",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10),
            Text(
              "No BPJS: ${widget.pasien!.noBpjs ?? '-'}",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10),
            Text(
              "Alamat: ${widget.pasien!.alamat ?? '-'}",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10),
            Text(
              "Tanggal Lahir: ${widget.pasien!.tanggalLahir ?? '-'}",
              style: const TextStyle(fontSize: 18.0),
            ),
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
        // Tombol Edit
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PasienForm(
                  pasien: widget.pasien!,
                ),
              ),
            );
          },
        ),
        // Tombol Hapus
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
        // tombol hapus
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            PasienBloc.deletePasien(id: widget.pasien!.noRekamMedis!).then(
              (value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PasienPage(),
                  ),
                );
              },
              onError: (error) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => const WarningDialog(
                    description: "Hapus gagal, silahkan coba lagi",
                  ),
                );
              },
            );
          },
        ),
        // tombol batal
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(builder: (context) => alertDialog, context: context);
  }
}
