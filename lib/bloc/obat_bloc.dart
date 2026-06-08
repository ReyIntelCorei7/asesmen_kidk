import 'dart:convert';
import 'package:asesmen_kidk_rumah_sakit/helpers/api.dart';
import 'package:asesmen_kidk_rumah_sakit/helpers/api_url.dart';
import 'package:asesmen_kidk_rumah_sakit/model/obat.dart';

class ObatBloc {
  static Future<List<Obat>> getObats() async {
    String apiUrl = ApiUrl.listObat;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listObat = (jsonObj as Map<String, dynamic>)['data'];
    List<Obat> obats = [];
    for (int i = 0; i < listObat.length; i++) {
      obats.add(Obat.fromJson(listObat[i]));
    }
    return obats;
  }

  static Future addObat({Obat? obat}) async {
    String apiUrl = ApiUrl.createObat;
    var body = {
      "nama_obat": obat!.namaObat,
      "stok": obat.stok.toString(),
      "harga_satuan": obat.hargaSatuan.toString()
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updateObat({Obat? obat}) async {
    String apiUrl = ApiUrl.updateObat(obat!.idObat!);
    var body = {
      "nama_obat": obat.namaObat,
      "stok": obat.stok.toString(),
      "harga_satuan": obat.hargaSatuan.toString()
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deleteObat({int? id}) async {
    String apiUrl = ApiUrl.deleteObat(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['status'];
  }
}
