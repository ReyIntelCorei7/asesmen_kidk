import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/poli_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/poli.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/poli_page.dart';
import 'package:asesmen_kidk_rumah_sakit/widget/warning_dialog.dart';

class PoliForm extends StatefulWidget {
  final Poli? poli;
  const PoliForm({super.key, this.poli});

  @override
  _PoliFormState createState() => _PoliFormState();
}

class _PoliFormState extends State<PoliForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH POLI";
  String tombolSubmit = "SIMPAN";

  final _namaPoliTextboxController = TextEditingController();
  final _lokasiRuanganTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  void isUpdate() {
    if (widget.poli != null) {
      setState(() {
        judul = "UBAH POLI";
        tombolSubmit = "UBAH";
        _namaPoliTextboxController.text = widget.poli!.namaPoli!;
        _lokasiRuanganTextboxController.text = widget.poli!.lokasiRuangan ?? '';
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
                _namaPoliTextField(),
                _lokasiRuanganTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _namaPoliTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Poli"),
      keyboardType: TextInputType.text,
      controller: _namaPoliTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Poli harus diisi";
        }
        return null;
      },
    );
  }

  Widget _lokasiRuanganTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Lokasi Ruangan"),
      keyboardType: TextInputType.text,
      controller: _lokasiRuanganTextboxController,
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.poli != null) {
              ubah();
            } else {
              simpan();
            }
          }
        }
      },
    );
  }

  void simpan() {
    setState(() => _isLoading = true);
    Poli createPoli = Poli(idPoli: null);
    createPoli.namaPoli = _namaPoliTextboxController.text;
    createPoli.lokasiRuangan = _lokasiRuanganTextboxController.text;
    PoliBloc.addPoli(poli: createPoli).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PoliPage()),
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

  void ubah() {
    setState(() => _isLoading = true);
    Poli updatePoli = Poli(idPoli: null);
    updatePoli.idPoli = widget.poli!.idPoli;
    updatePoli.namaPoli = _namaPoliTextboxController.text;
    updatePoli.lokasiRuangan = _lokasiRuanganTextboxController.text;
    PoliBloc.updatePoli(poli: updatePoli).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PoliPage()),
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
