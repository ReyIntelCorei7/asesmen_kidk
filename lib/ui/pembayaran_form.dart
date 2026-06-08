import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/bloc/pembayaran_bloc.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pembayaran.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/pembayaran_page.dart';
import 'package:asesmen_kidk_rumah_sakit/widget/warning_dialog.dart';

class PembayaranForm extends StatefulWidget {
  final Pembayaran? pembayaran;
  const PembayaranForm({super.key, this.pembayaran});

  @override
  _PembayaranFormState createState() => _PembayaranFormState();
}

class _PembayaranFormState extends State<PembayaranForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH PEMBAYARAN";
  String tombolSubmit = "SIMPAN";

  final _idPemeriksaanTextboxController = TextEditingController();
  final _totalTagihanTextboxController = TextEditingController();
  final _tanggalBayarTextboxController = TextEditingController();
  final _statusPembayaranTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  void isUpdate() {
    if (widget.pembayaran != null) {
      setState(() {
        judul = "UBAH PEMBAYARAN";
        tombolSubmit = "UBAH";
        _idPemeriksaanTextboxController.text = widget.pembayaran!.idPemeriksaan.toString();
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
                _idPemeriksaanTextField(),
                _totalTagihanTextField(),
                _tanggalBayarTextField(),
                _statusPembayaranTextField(),
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
            if (widget.pembayaran != null) {
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
    Pembayaran createPembayaran = Pembayaran(idPembayaran: null);
    createPembayaran.idPemeriksaan = int.parse(_idPemeriksaanTextboxController.text);
    createPembayaran.totalTagihan = double.tryParse(_totalTagihanTextboxController.text) ?? 0;
    createPembayaran.tanggalBayar = _tanggalBayarTextboxController.text;
    createPembayaran.statusPembayaran = _statusPembayaranTextboxController.text;
    PembayaranBloc.addPembayaran(pembayaran: createPembayaran).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PembayaranPage()),
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
    Pembayaran updatePembayaran = Pembayaran(idPembayaran: null);
    updatePembayaran.idPembayaran = widget.pembayaran!.idPembayaran;
    updatePembayaran.idPemeriksaan = int.parse(_idPemeriksaanTextboxController.text);
    updatePembayaran.totalTagihan = double.tryParse(_totalTagihanTextboxController.text) ?? 0;
    updatePembayaran.tanggalBayar = _tanggalBayarTextboxController.text;
    updatePembayaran.statusPembayaran = _statusPembayaranTextboxController.text;
    PembayaranBloc.updatePembayaran(pembayaran: updatePembayaran).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PembayaranPage()),
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
