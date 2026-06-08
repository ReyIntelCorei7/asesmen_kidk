import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/resep_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/resep.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/resep_form.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/resep_page.dart';
import 'package:asesmen_kidk_rumah_sakit/widget/warning_dialog.dart';

class ResepForm extends StatefulWidget {
  Resep? resep;
  ResepForm({Key? key, this.resep}) : super(key: key);

  @override
  _ResepFormState createState() => _ResepFormState();
}

class _ResepFormState extends State<ResepForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH RESEP";
  String tombolSubmit = "SIMPAN";

  final _idPemeriksaanTextboxController = TextEditingController();
  final _noRekamMedisTextboxController = TextEditingController();
  final _idDokterTextboxController = TextEditingController();
  final _tanggalResepTextboxController = TextEditingController();
  final _totalBiayaObatTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.resep != null) {
      setState(() {
        judul = "UBAH RESEP";
        tombolSubmit = "UBAH";
        _idPemeriksaanTextboxController.text = widget.resep!.idPemeriksaan.toString();
        _noRekamMedisTextboxController.text = widget.resep!.noRekamMedis.toString();
        _idDokterTextboxController.text = widget.resep!.idDokter.toString();
        _tanggalResepTextboxController.text = widget.resep!.tanggalResep ?? '';
        _totalBiayaObatTextboxController.text = widget.resep!.totalBiayaObat.toString();
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
                _idPemeriksaanTextField(),
                _noRekamMedisTextField(),
                _idDokterTextField(),
                _tanggalResepTextField(),
                _totalBiayaObatTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _idPemeriksaanTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "ID Pemeriksaan"),
      keyboardType: TextInputType.number,
      controller: _idPemeriksaanTextboxController,
      validator: (value) {
        if (value!.isEmpty) return "ID Pemeriksaan harus diisi";
        return null;
      },
    );
  }

  Widget _noRekamMedisTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "No Rekam Medis"),
      keyboardType: TextInputType.number,
      controller: _noRekamMedisTextboxController,
      validator: (value) {
        if (value!.isEmpty) return "No Rekam Medis harus diisi";
        return null;
      },
    );
  }

  Widget _idDokterTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "ID Dokter"),
      keyboardType: TextInputType.number,
      controller: _idDokterTextboxController,
      validator: (value) {
        if (value!.isEmpty) return "ID Dokter harus diisi";
        return null;
      },
    );
  }

  Widget _tanggalResepTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Tanggal Resep (YYYY-MM-DD)"),
      keyboardType: TextInputType.datetime,
      controller: _tanggalResepTextboxController,
      validator: (value) {
        if (value!.isEmpty) return "Tanggal harus diisi";
        return null;
      },
    );
  }

  Widget _totalBiayaObatTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Total Biaya Obat"),
      keyboardType: TextInputType.number,
      controller: _totalBiayaObatTextboxController,
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.resep != null) {
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
    Resep createResep = Resep(idResep: null);
    createResep.idPemeriksaan = int.parse(_idPemeriksaanTextboxController.text);
    createResep.noRekamMedis = int.parse(_noRekamMedisTextboxController.text);
    createResep.idDokter = int.parse(_idDokterTextboxController.text);
    createResep.tanggalResep = _tanggalResepTextboxController.text;
    createResep.totalBiayaObat = double.tryParse(_totalBiayaObatTextboxController.text) ?? 0;
    ResepBloc.addResep(resep: createResep).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResepPage()),
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
    Resep updateResep = Resep(idResep: null);
    updateResep.idResep = widget.resep!.idResep;
    updateResep.idPemeriksaan = int.parse(_idPemeriksaanTextboxController.text);
    updateResep.noRekamMedis = int.parse(_noRekamMedisTextboxController.text);
    updateResep.idDokter = int.parse(_idDokterTextboxController.text);
    updateResep.tanggalResep = _tanggalResepTextboxController.text;
    updateResep.totalBiayaObat = double.tryParse(_totalBiayaObatTextboxController.text) ?? 0;
    ResepBloc.updateResep(resep: updateResep).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResepPage()),
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
