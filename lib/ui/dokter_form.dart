import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/dokter_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/dokter.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/dokter_page.dart';
import 'package:asesmen_kidk_rumah_sakit/widget/warning_dialog.dart';

class DokterForm extends StatefulWidget {
  Dokter? dokter;
  DokterForm({Key? key, this.dokter}) : super(key: key);

  @override
  _DokterFormState createState() => _DokterFormState();
}

class _DokterFormState extends State<DokterForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH DOKTER";
  String tombolSubmit = "SIMPAN";

  final _namaDokterTextboxController = TextEditingController();
  final _spesialisasiTextboxController = TextEditingController();
  final _idPoliTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.dokter != null) {
      setState(() {
        judul = "UBAH DOKTER";
        tombolSubmit = "UBAH";
        _namaDokterTextboxController.text = widget.dokter!.namaDokter!;
        _spesialisasiTextboxController.text = widget.dokter!.spesialisasi ?? '';
        _idPoliTextboxController.text = widget.dokter!.idPoli.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _namaDokterTextField(),
                _spesialisasiTextField(),
                _idPoliTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _namaDokterTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Dokter"),
      keyboardType: TextInputType.text,
      controller: _namaDokterTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Dokter harus diisi";
        }
        return null;
      },
    );
  }

  Widget _spesialisasiTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Spesialisasi"),
      keyboardType: TextInputType.text,
      controller: _spesialisasiTextboxController,
    );
  }

  Widget _idPoliTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "ID Poli"),
      keyboardType: TextInputType.number,
      controller: _idPoliTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "ID Poli harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.dokter != null) {
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
    setState(() => _isLoading = true);
    Dokter createDokter = Dokter(idDokter: null);
    createDokter.namaDokter = _namaDokterTextboxController.text;
    createDokter.spesialisasi = _spesialisasiTextboxController.text;
    createDokter.idPoli = int.parse(_idPoliTextboxController.text);
    DokterBloc.addDokter(dokter: createDokter).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DokterPage()),
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
    setState(() => _isLoading = false);
  }

  ubah() {
    setState(() => _isLoading = true);
    Dokter updateDokter = Dokter(idDokter: null);
    updateDokter.idDokter = widget.dokter!.idDokter;
    updateDokter.namaDokter = _namaDokterTextboxController.text;
    updateDokter.spesialisasi = _spesialisasiTextboxController.text;
    updateDokter.idPoli = int.parse(_idPoliTextboxController.text);
    DokterBloc.updateDokter(dokter: updateDokter).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DokterPage()),
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
    setState(() => _isLoading = false);
  }
}
