import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/obat_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/obat.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/obat_form.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/obat_page.dart';
import 'package:asesmen_kidk_rumah_sakit/widget/warning_dialog.dart';

class ObatForm extends StatefulWidget {
  Obat? obat;
  ObatForm({Key? key, this.obat}) : super(key: key);

  @override
  _ObatFormState createState() => _ObatFormState();
}

class _ObatFormState extends State<ObatForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH OBAT";
  String tombolSubmit = "SIMPAN";

  final _namaObatTextboxController = TextEditingController();
  final _stokTextboxController = TextEditingController();
  final _hargaSatuanTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.obat != null) {
      setState(() {
        judul = "UBAH OBAT";
        tombolSubmit = "UBAH";
        _namaObatTextboxController.text = widget.obat!.namaObat!;
        _stokTextboxController.text = widget.obat!.stok.toString();
        _hargaSatuanTextboxController.text = widget.obat!.hargaSatuan.toString();
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
                _namaObatTextField(),
                _stokTextField(),
                _hargaSatuanTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _namaObatTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Obat"),
      keyboardType: TextInputType.text,
      controller: _namaObatTextboxController,
      validator: (value) {
        if (value!.isEmpty) return "Nama Obat harus diisi";
        return null;
      },
    );
  }

  Widget _stokTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Stok"),
      keyboardType: TextInputType.number,
      controller: _stokTextboxController,
    );
  }

  Widget _hargaSatuanTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga Satuan"),
      keyboardType: TextInputType.number,
      controller: _hargaSatuanTextboxController,
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.obat != null) {
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
    Obat createObat = Obat(idObat: null);
    createObat.namaObat = _namaObatTextboxController.text;
    createObat.stok = int.tryParse(_stokTextboxController.text) ?? 0;
    createObat.hargaSatuan = double.tryParse(_hargaSatuanTextboxController.text) ?? 0;
    ObatBloc.addObat(obat: createObat).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ObatPage()),
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
    Obat updateObat = Obat(idObat: null);
    updateObat.idObat = widget.obat!.idObat;
    updateObat.namaObat = _namaObatTextboxController.text;
    updateObat.stok = int.tryParse(_stokTextboxController.text) ?? 0;
    updateObat.hargaSatuan = double.tryParse(_hargaSatuanTextboxController.text) ?? 0;
    ObatBloc.updateObat(obat: updateObat).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ObatPage()),
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
