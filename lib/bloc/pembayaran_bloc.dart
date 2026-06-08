import 'dart:convert';
import 'package:asesmen_kidk_rumah_sakit/helpers/api.dart';
import 'package:asesmen_kidk_rumah_sakit/helpers/api_url.dart';
import 'package:asesmen_kidk_rumah_sakit/model/pembayaran.dart';

class PembayaranBloc {
  static Future<List<Pembayaran>> getPembayarans() async {
    String apiUrl = ApiUrl.listPembayaran;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listPembayaran = (jsonObj as Map<String, dynamic>)['data'];
    List<Pembayaran> pembayarans = [];
    for (int i = 0; i < listPembayaran.length; i++) {
      pembayarans.add(Pembayaran.fromJson(listPembayaran[i]));
    }
    return pembayarans;
  }

  static Future addPembayaran({Pembayaran? pembayaran}) async {
    String apiUrl = ApiUrl.createPembayaran;
    var body = {
      "id_pemeriksaan": pembayaran!.idPemeriksaan.toString(),
      "total_tagihan": pembayaran.totalTagihan.toString(),
      "tanggal_bayar": pembayaran.tanggalBayar,
      "status_pembayaran": pembayaran.statusPembayaran
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updatePembayaran({Pembayaran? pembayaran}) async {
    String apiUrl = ApiUrl.updatePembayaran(pembayaran!.idPembayaran!);
    var body = {
      "id_pemeriksaan": pembayaran.idPemeriksaan.toString(),
      "total_tagihan": pembayaran.totalTagihan.toString(),
      "tanggal_bayar": pembayaran.tanggalBayar,
      "status_pembayaran": pembayaran.statusPembayaran
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deletePembayaran({int? id}) async {
    String apiUrl = ApiUrl.deletePembayaran(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}
