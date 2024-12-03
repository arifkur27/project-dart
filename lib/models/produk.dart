class Produk {
  String nama;
  double harga;
  int stok;

  Produk({required this.nama, required this.harga, required this.stok});

  void kurangiStok(int jumlah) {
    if (stok >= jumlah) {
      stok -= jumlah;
    } else {
      throw Exception("Stok tidak cukup untuk produk $nama");
    }
  }
}
