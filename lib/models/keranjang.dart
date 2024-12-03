import 'produk.dart';

class Keranjang {
  List<Map<String, dynamic>> items = [];
  double total = 0.0;

  void tambahProduk(Produk produk, int jumlah, String pembeli) {
    if (produk.stok >= jumlah) {
      items.add({
        'produk': produk,
        'jumlah': jumlah,
        'pembeli': pembeli, // Tambahkan pembeli
      });
      total += produk.harga * jumlah;
      produk.kurangiStok(jumlah); // Kurangi stok produk
    } else {
      throw Exception("Stok tidak cukup untuk produk ${produk.nama}");
    }
  }

  void hapusProduk(int index) {
    if (index >= 0 && index < items.length) {
      var item = items[index];
      Produk produk = item['produk'];
      int jumlah = item['jumlah'];
      total -= produk.harga * jumlah;
      produk.stok += jumlah;
      items.removeAt(index);
    } else {
      throw Exception("Index tidak valid");
    }
  }

  void kurangiProduk(int index, int jumlah) {
    if (index >= 0 && index < items.length) {
      var item = items[index];
      Produk produk = item['produk'];
      int jumlahSaatIni = item['jumlah'];

      if (jumlah > jumlahSaatIni) {
        throw Exception(
            "Jumlah penghapusan melebihi jumlah yang ada di keranjang");
      }

      // Mengurangi jumlah produk di keranjang
      item['jumlah'] -= jumlah;
      total -= produk.harga * jumlah;

      // Mengembalikan stok produk
      produk.stok += jumlah;

      // Jika jumlah produk menjadi 0, hapus produk dari keranjang
      if (item['jumlah'] == 0) {
        items.removeAt(index);
      }
    } else {
      throw Exception("Index tidak valid");
    }
  }

  void resetKeranjang() {
    for (var item in items) {
      Produk produk = item['produk'];
      int jumlah = item['jumlah'];
      produk.stok += jumlah;
    }
    items.clear();
    total = 0.0;
  }
}
