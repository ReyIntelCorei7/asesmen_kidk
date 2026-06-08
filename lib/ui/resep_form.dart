import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/resep_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/pemeriksaan_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/resep.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pemeriksaan.dart';
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

  List<Pemeriksaan> _listPemeriksaan = [];
  int? _selectedPemeriksaanId;
  Pemeriksaan? _selectedPemeriksaanObj;

  final _tanggalResepTextboxController = TextEditingController();
  final _totalBiayaObatTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
    _loadPemeriksaan();
  }

  void _loadPemeriksaan() async {
    try {
      List pemeriksList = await PemeriksaanBloc.getPemeriksaans();
      setState(() {
        _listPemeriksaan = pemeriksList.cast<Pemeriksaan>();
        if (widget.resep != null) {
          _selectedPemeriksaanId = widget.resep!.idPemeriksaan;
          _selectedPemeriksaanObj = _listPemeriksaan.firstWhere((p) => p.idPemeriksaan == widget.resep!.idPemeriksaan);
        }
      });
    } catch (e) {}
  }

  isUpdate() {
    if (widget.resep != null) {
      setState(() {
        judul = "UBAH RESEP";
        tombolSubmit = "UBAH";
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
                _pemeriksaanDropdownField(),
                if (_selectedPemeriksaanObj != null) ...[
                  ListTile(
                    title: Text("Pasien: ${_selectedPemeriksaanObj!.namaPasien}"),
                    subtitle: Text("Dokter: ${_selectedPemeriksaanObj!.namaDokter}"),
                  )
                ],
                _tanggalResepTextField(),
                _totalBiayaObatTextField(),
                const SizedBox(height: 20),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pemeriksaanDropdownField() {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(labelText: "Pemeriksaan"),
      value: _selectedPemeriksaanId,
      items: _listPemeriksaan.map((Pemeriksaan p) {
        return DropdownMenuItem<int>(
          value: p.idPemeriksaan,
          child: Text("${p.tanggalPeriksa} - ${p.namaPasien}"),
        );
      }).toList(),
      onChanged: (int? newValue) {
        setState(() {
          _selectedPemeriksaanId = newValue;
          _selectedPemeriksaanObj = _listPemeriksaan.firstWhere((p) => p.idPemeriksaan == newValue);
        });
      },
      validator: (value) => value == null ? "Pilih Pemeriksaan" : null,
    );
  }

  Widget _tanggalResepTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Tanggal Resep (YYYY-MM-DD)"),
      keyboardType: TextInputType.datetime,
      controller: _tanggalResepTextboxController,
      validator: (value) => value!.isEmpty ? "Tanggal harus diisi" : null,
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
            widget.resep != null ? ubah() : simpan();
          }
        }
      },
    );
  }

  simpan() {
    setState(() => _isLoading = true);
    Resep create = Resep(idResep: null);
    create.idPemeriksaan = _selectedPemeriksaanId;
    create.noRekamMedis = _selectedPemeriksaanObj?.noRekamMedis;
    create.idDokter = _selectedPemeriksaanObj?.idDokter;
    create.tanggalResep = _tanggalResepTextboxController.text;
    create.totalBiayaObat = double.tryParse(_totalBiayaObatTextboxController.text) ?? 0;
    ResepBloc.addResep(resep: create).then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ResepPage()));
    }, onError: (error) {
      showDialog(context: context, builder: (context) => const WarningDialog(description: "Simpan gagal"));
    });
    setState(() => _isLoading = false);
  }

  ubah() {
    setState(() => _isLoading = true);
    Resep update = Resep(idResep: widget.resep!.idResep);
    update.idPemeriksaan = _selectedPemeriksaanId;
    update.noRekamMedis = _selectedPemeriksaanObj?.noRekamMedis;
    update.idDokter = _selectedPemeriksaanObj?.idDokter;
    update.tanggalResep = _tanggalResepTextboxController.text;
    update.totalBiayaObat = double.tryParse(_totalBiayaObatTextboxController.text) ?? 0;
    ResepBloc.updateResep(resep: update).then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ResepPage()));
    }, onError: (error) {
      showDialog(context: context, builder: (context) => const WarningDialog(description: "Ubah gagal"));
    });
    setState(() => _isLoading = false);
  }
}
