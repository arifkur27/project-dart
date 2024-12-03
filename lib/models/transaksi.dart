import 'produk.dart';

class Transaksi {
  DateTime tanggal;
  List<Map<String, dynamic>> items;
  double total;

  Transaksi({required this.tanggal, required this.items, required this.total});

  String formatTanggal(DateTime tanggal) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String tahun = tanggal.year.toString();
    String bulan = twoDigits(tanggal.month);
    String hari = twoDigits(tanggal.day);
    String jam = twoDigits(tanggal.hour);
    String menit = twoDigits(tanggal.minute);
    String detik = twoDigits(tanggal.second);

    return "$tahun-$bulan-$hari $jam:$menit:$detik";
  }

  String cetakStruk() {
    StringBuffer struk = StringBuffer();
    struk.writeln("=== STRUK BELANJA ===");
    struk.writeln("Tanggal: ${formatTanggal(tanggal)}");
    struk.writeln("=====================");
    for (var item in items) {
      if (item.containsKey('produk') && item.containsKey('jumlah')) {
        var produk = item['produk'] as Produk;
        var jumlah = item['jumlah'] as int;

        struk.writeln(
            "${produk.nama} x $jumlah = Rp${(produk.harga * jumlah).toStringAsFixed(2)}");
      } else {
        throw Exception(
            "Data item tidak valid. Pastikan produk dan jumlah disediakan.");
      }
    }
    struk.writeln("=====================");
    struk.writeln("Total: Rp${total.toStringAsFixed(2)}");
    return struk.toString();
  }
}
