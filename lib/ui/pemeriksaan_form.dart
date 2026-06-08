import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/pemeriksaan_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pemeriksaan.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pemeriksaan_page.dart';
import 'package:asesmen_kidk_rumah_sakit/widget/warning_dialog.dart';

class PemeriksaanForm extends StatefulWidget {
  Pemeriksaan? pemeriksaan;
  PemeriksaanForm({Key? key, this.pemeriksaan}) : super(key: key);

  @override
  _PemeriksaanFormState createState() => _PemeriksaanFormState();
}

class _PemeriksaanFormState extends State<PemeriksaanForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH PEMERIKSAAN";
  String tombolSubmit = "SIMPAN";

  final _noRekamMedisTextboxController = TextEditingController();
  final _idDokterTextboxController = TextEditingController();
  final _tanggalPeriksaTextboxController = TextEditingController();
  final _diagnosisTextboxController = TextEditingController();
  final _tindakanTextboxController = TextEditingController();
  final _biayaPemeriksaanTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.pemeriksaan != null) {
      setState(() {
        judul = "UBAH PEMERIKSAAN";
        tombolSubmit = "UBAH";
        _noRekamMedisTextboxController.text = widget.pemeriksaan!.noRekamMedis.toString();
        _idDokterTextboxController.text = widget.pemeriksaan!.idDokter.toString();
        _tanggalPeriksaTextboxController.text = widget.pemeriksaan!.tanggalPeriksa ?? '';
        _diagnosisTextboxController.text = widget.pemeriksaan!.diagnosis ?? '';
        _tindakanTextboxController.text = widget.pemeriksaan!.tindakan ?? '';
        _biayaPemeriksaanTextboxController.text = widget.pemeriksaan!.biayaPemeriksaan.toString();
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
                _noRekamMedisTextField(),
                _idDokterTextField(),
                _tanggalPeriksaTextField(),
                _diagnosisTextField(),
                _tindakanTextField(),
                _biayaPemeriksaanTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
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

  Widget _tanggalPeriksaTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Tanggal Periksa (YYYY-MM-DD)"),
      keyboardType: TextInputType.datetime,
      controller: _tanggalPeriksaTextboxController,
      validator: (value) {
        if (value!.isEmpty) return "Tanggal harus diisi";
        return null;
      },
    );
  }

  Widget _diagnosisTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Diagnosis"),
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      controller: _diagnosisTextboxController,
    );
  }

  Widget _tindakanTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Tindakan"),
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      controller: _tindakanTextboxController,
    );
  }

  Widget _biayaPemeriksaanTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Biaya Pemeriksaan"),
      keyboardType: TextInputType.number,
      controller: _biayaPemeriksaanTextboxController,
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.pemeriksaan != null) {
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
    Pemeriksaan createPemeriksaan = Pemeriksaan(idPemeriksaan: null);
    createPemeriksaan.noRekamMedis = int.parse(_noRekamMedisTextboxController.text);
    createPemeriksaan.idDokter = int.parse(_idDokterTextboxController.text);
    createPemeriksaan.tanggalPeriksa = _tanggalPeriksaTextboxController.text;
    createPemeriksaan.diagnosis = _diagnosisTextboxController.text;
    createPemeriksaan.tindakan = _tindakanTextboxController.text;
    createPemeriksaan.biayaPemeriksaan = double.tryParse(_biayaPemeriksaanTextboxController.text) ?? 0;
    PemeriksaanBloc.addPemeriksaan(pemeriksaan: createPemeriksaan).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PemeriksaanPage()),
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
    Pemeriksaan updatePemeriksaan = Pemeriksaan(idPemeriksaan: null);
    updatePemeriksaan.idPemeriksaan = widget.pemeriksaan!.idPemeriksaan;
    updatePemeriksaan.noRekamMedis = int.parse(_noRekamMedisTextboxController.text);
    updatePemeriksaan.idDokter = int.parse(_idDokterTextboxController.text);
    updatePemeriksaan.tanggalPeriksa = _tanggalPeriksaTextboxController.text;
    updatePemeriksaan.diagnosis = _diagnosisTextboxController.text;
    updatePemeriksaan.tindakan = _tindakanTextboxController.text;
    updatePemeriksaan.biayaPemeriksaan = double.tryParse(_biayaPemeriksaanTextboxController.text) ?? 0;
    PemeriksaanBloc.updatePemeriksaan(pemeriksaan: updatePemeriksaan).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PemeriksaanPage()),
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
