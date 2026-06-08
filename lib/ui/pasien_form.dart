import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/pasien_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pasien.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pasien_page.dart';
import 'package:asesmen_kidk_rumah_sakit/widget/warning_dialog.dart';

class PasienForm extends StatefulWidget {
  Pasien? pasien;
  PasienForm({Key? key, this.pasien}) : super(key: key);

  @override
  _PasienFormState createState() => _PasienFormState();
}

class _PasienFormState extends State<PasienForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH PASIEN";
  String tombolSubmit = "SIMPAN";

  final _namaPasienTextboxController = TextEditingController();
  final _nikKtpTextboxController = TextEditingController();
  final _noBpjsTextboxController = TextEditingController();
  final _alamatTextboxController = TextEditingController();
  final _tanggalLahirTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.pasien != null) {
      setState(() {
        judul = "UBAH PASIEN";
        tombolSubmit = "UBAH";
        _namaPasienTextboxController.text = widget.pasien!.namaPasien!;
        _nikKtpTextboxController.text = widget.pasien!.nikKtp!;
        _noBpjsTextboxController.text = widget.pasien!.noBpjs ?? '';
        _alamatTextboxController.text = widget.pasien!.alamat ?? '';
        _tanggalLahirTextboxController.text = widget.pasien!.tanggalLahir ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _namaPasienTextField(),
                _nikKtpTextField(),
                _noBpjsTextField(),
                _alamatTextField(),
                _tanggalLahirTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat Textbox Nama Pasien
  Widget _namaPasienTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Pasien"),
      keyboardType: TextInputType.text,
      controller: _namaPasienTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Pasien harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Textbox NIK KTP
  Widget _nikKtpTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "NIK KTP"),
      keyboardType: TextInputType.number,
      controller: _nikKtpTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "NIK KTP harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Textbox No BPJS
  Widget _noBpjsTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "No BPJS"),
      keyboardType: TextInputType.text,
      controller: _noBpjsTextboxController,
    );
  }

  // Membuat Textbox Alamat
  Widget _alamatTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Alamat"),
      keyboardType: TextInputType.text,
      controller: _alamatTextboxController,
    );
  }

  // Membuat Textbox Tanggal Lahir
  Widget _tanggalLahirTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Tanggal Lahir (YYYY-MM-DD)"),
      keyboardType: TextInputType.datetime,
      controller: _tanggalLahirTextboxController,
    );
  }

  // Membuat Tombol Simpan/Ubah
  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.pasien != null) {
              ubah();
            } else {
              simpan();
            }
          }
        }
      },
    );
  }

  simpan() {
    setState(() {
      _isLoading = true;
    });
    Pasien createPasien = Pasien(noRekamMedis: null);
    createPasien.namaPasien = _namaPasienTextboxController.text;
    createPasien.nikKtp = _nikKtpTextboxController.text;
    createPasien.noBpjs = _noBpjsTextboxController.text;
    createPasien.alamat = _alamatTextboxController.text;
    createPasien.tanggalLahir = _tanggalLahirTextboxController.text;
    PasienBloc.addPasien(pasien: createPasien).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PasienPage()),
      );
    }, onError: (error) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Simpan gagal, silahkan coba lagi",
        ),
      );
    });
    setState(() {
      _isLoading = false;
    });
  }

  ubah() {
    setState(() {
      _isLoading = true;
    });
    Pasien updatePasien = Pasien(noRekamMedis: null);
    updatePasien.noRekamMedis = widget.pasien!.noRekamMedis;
    updatePasien.namaPasien = _namaPasienTextboxController.text;
    updatePasien.nikKtp = _nikKtpTextboxController.text;
    updatePasien.noBpjs = _noBpjsTextboxController.text;
    updatePasien.alamat = _alamatTextboxController.text;
    updatePasien.tanggalLahir = _tanggalLahirTextboxController.text;
    PasienBloc.updatePasien(pasien: updatePasien).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PasienPage()),
      );
    }, onError: (error) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Ubah gagal, silahkan coba lagi",
        ),
      );
    });
    setState(() {
      _isLoading = false;
    });
  }
}
