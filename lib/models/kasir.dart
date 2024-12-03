import 'transaksi.dart';

class Kasir {
  String nama;
  List<Transaksi> daftarTransaksi = [];

  Kasir({required this.nama});

  void tambahTransaksi(Transaksi transaksi) {
    daftarTransaksi.add(transaksi);
  }

  List<Transaksi> laporanPenjualan() {
    return daftarTransaksi;
  }
}
