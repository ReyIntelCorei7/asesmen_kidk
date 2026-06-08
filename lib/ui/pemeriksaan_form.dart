import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/pemeriksaan_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/pasien_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/dokter_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pemeriksaan.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pasien.dart';
import 'package:asesmen_kidk_rumah_sakit/model/dokter.dart';
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

  List<Pasien> _listPasien = [];
  List<Dokter> _listDokter = [];
  
  int? _selectedPasienId;
  int? _selectedDokterId;

  final _tanggalPeriksaTextboxController = TextEditingController();
  final _diagnosisTextboxController = TextEditingController();
  final _tindakanTextboxController = TextEditingController();
  final _biayaPemeriksaanTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
    _loadData();
  }

  void _loadData() async {
    try {
      List pasienList = await PasienBloc.getPasiens();
      List dokterList = await DokterBloc.getDokters();
      setState(() {
        _listPasien = pasienList.cast<Pasien>();
        _listDokter = dokterList.cast<Dokter>();
        if (widget.pemeriksaan != null) {
          _selectedPasienId = widget.pemeriksaan!.noRekamMedis;
          _selectedDokterId = widget.pemeriksaan!.idDokter;
        }
      });
    } catch (e) {
      // ignore
    }
  }

  isUpdate() {
    if (widget.pemeriksaan != null) {
      setState(() {
        judul = "UBAH PEMERIKSAAN";
        tombolSubmit = "UBAH";
        _selectedPasienId = widget.pemeriksaan!.noRekamMedis;
        _selectedDokterId = widget.pemeriksaan!.idDokter;
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
                _pasienDropdownField(),
                _dokterDropdownField(),
                _tanggalPeriksaTextField(),
                _diagnosisTextField(),
                _tindakanTextField(),
                _biayaPemeriksaanTextField(),
                const SizedBox(height: 20),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pasienDropdownField() {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(labelText: "Pasien"),
      value: _selectedPasienId,
      items: _listPasien.map((Pasien p) {
        return DropdownMenuItem<int>(
          value: p.noRekamMedis,
          child: Text(p.namaPasien ?? ''),
        );
      }).toList(),
      onChanged: (int? newValue) {
        setState(() => _selectedPasienId = newValue);
      },
      validator: (value) => value == null ? "Pilih Pasien" : null,
    );
  }

  Widget _dokterDropdownField() {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(labelText: "Dokter"),
      value: _selectedDokterId,
      items: _listDokter.map((Dokter d) {
        return DropdownMenuItem<int>(
          value: d.idDokter,
          child: Text(d.namaDokter ?? ''),
        );
      }).toList(),
      onChanged: (int? newValue) {
        setState(() => _selectedDokterId = newValue);
      },
      validator: (value) => value == null ? "Pilih Dokter" : null,
    );
  }

  Widget _tanggalPeriksaTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Tanggal Periksa (YYYY-MM-DD)"),
      keyboardType: TextInputType.datetime,
      controller: _tanggalPeriksaTextboxController,
    );
  }

  Widget _diagnosisTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Diagnosis"),
      keyboardType: TextInputType.text,
      controller: _diagnosisTextboxController,
    );
  }

  Widget _tindakanTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Tindakan"),
      keyboardType: TextInputType.text,
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
            widget.pemeriksaan != null ? ubah() : simpan();
          }
        }
      },
    );
  }

  simpan() {
    setState(() => _isLoading = true);
    Pemeriksaan create = Pemeriksaan(idPemeriksaan: null);
    create.noRekamMedis = _selectedPasienId;
    create.idDokter = _selectedDokterId;
    create.tanggalPeriksa = _tanggalPeriksaTextboxController.text;
    create.diagnosis = _diagnosisTextboxController.text;
    create.tindakan = _tindakanTextboxController.text;
    create.biayaPemeriksaan = double.tryParse(_biayaPemeriksaanTextboxController.text) ?? 0;
    PemeriksaanBloc.addPemeriksaan(pemeriksaan: create).then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PemeriksaanPage()));
    }, onError: (error) {
      showDialog(context: context, builder: (context) => const WarningDialog(description: "Simpan gagal"));
    });
    setState(() => _isLoading = false);
  }

  ubah() {
    setState(() => _isLoading = true);
    Pemeriksaan update = Pemeriksaan(idPemeriksaan: widget.pemeriksaan!.idPemeriksaan);
    update.noRekamMedis = _selectedPasienId;
    update.idDokter = _selectedDokterId;
    update.tanggalPeriksa = _tanggalPeriksaTextboxController.text;
    update.diagnosis = _diagnosisTextboxController.text;
    update.tindakan = _tindakanTextboxController.text;
    update.biayaPemeriksaan = double.tryParse(_biayaPemeriksaanTextboxController.text) ?? 0;
    PemeriksaanBloc.updatePemeriksaan(pemeriksaan: update).then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PemeriksaanPage()));
    }, onError: (error) {
      showDialog(context: context, builder: (context) => const WarningDialog(description: "Ubah gagal"));
    });
    setState(() => _isLoading = false);
  }
}
