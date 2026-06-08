import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/pembayaran_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/pemeriksaan_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pembayaran.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pemeriksaan.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pembayaran_page.dart';
import 'package:asesmen_kidk_rumah_sakit/widget/warning_dialog.dart';

class PembayaranForm extends StatefulWidget {
  Pembayaran? pembayaran;
  PembayaranForm({Key? key, this.pembayaran}) : super(key: key);

  @override
  _PembayaranFormState createState() => _PembayaranFormState();
}

class _PembayaranFormState extends State<PembayaranForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH PEMBAYARAN";
  String tombolSubmit = "SIMPAN";

  List<Pemeriksaan> _listPemeriksaan = [];
  int? _selectedPemeriksaanId;
  Pemeriksaan? _selectedPemeriksaanObj;

  final _totalTagihanTextboxController = TextEditingController();
  final _tanggalBayarTextboxController = TextEditingController();
  final _statusPembayaranTextboxController = TextEditingController();

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
        if (widget.pembayaran != null) {
          _selectedPemeriksaanId = widget.pembayaran!.idPemeriksaan;
          _selectedPemeriksaanObj = _listPemeriksaan.firstWhere((p) => p.idPemeriksaan == widget.pembayaran!.idPemeriksaan);
        }
      });
    } catch (e) {}
  }

  isUpdate() {
    if (widget.pembayaran != null) {
      setState(() {
        judul = "UBAH PEMBAYARAN";
        tombolSubmit = "UBAH";
        _totalTagihanTextboxController.text = widget.pembayaran!.totalTagihan.toString();
        _tanggalBayarTextboxController.text = widget.pembayaran!.tanggalBayar ?? '';
        _statusPembayaranTextboxController.text = widget.pembayaran!.statusPembayaran ?? '';
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
                    subtitle: Text("Biaya Periksa: ${_selectedPemeriksaanObj!.biayaPemeriksaan}"),
                  )
                ],
                _totalTagihanTextField(),
                _tanggalBayarTextField(),
                _statusPembayaranTextField(),
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

  Widget _totalTagihanTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Total Tagihan"),
      keyboardType: TextInputType.number,
      controller: _totalTagihanTextboxController,
    );
  }

  Widget _tanggalBayarTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Tanggal Bayar (YYYY-MM-DD)"),
      keyboardType: TextInputType.datetime,
      controller: _tanggalBayarTextboxController,
    );
  }

  Widget _statusPembayaranTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Status Pembayaran"),
      keyboardType: TextInputType.text,
      controller: _statusPembayaranTextboxController,
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            widget.pembayaran != null ? ubah() : simpan();
          }
        }
      },
    );
  }

  simpan() {
    setState(() => _isLoading = true);
    Pembayaran create = Pembayaran(idPembayaran: null);
    create.idPemeriksaan = _selectedPemeriksaanId;
    create.totalTagihan = double.tryParse(_totalTagihanTextboxController.text) ?? 0;
    create.tanggalBayar = _tanggalBayarTextboxController.text;
    create.statusPembayaran = _statusPembayaranTextboxController.text;
    PembayaranBloc.addPembayaran(pembayaran: create).then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PembayaranPage()));
    }, onError: (error) {
      showDialog(context: context, builder: (context) => const WarningDialog(description: "Simpan gagal"));
    });
    setState(() => _isLoading = false);
  }

  ubah() {
    setState(() => _isLoading = true);
    Pembayaran update = Pembayaran(idPembayaran: widget.pembayaran!.idPembayaran);
    update.idPemeriksaan = _selectedPemeriksaanId;
    update.totalTagihan = double.tryParse(_totalTagihanTextboxController.text) ?? 0;
    update.tanggalBayar = _tanggalBayarTextboxController.text;
    update.statusPembayaran = _statusPembayaranTextboxController.text;
    PembayaranBloc.updatePembayaran(pembayaran: update).then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PembayaranPage()));
    }, onError: (error) {
      showDialog(context: context, builder: (context) => const WarningDialog(description: "Ubah gagal"));
    });
    setState(() => _isLoading = false);
  }
}
