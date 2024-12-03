import 'dart:io';
import '../lib/models/produk.dart';
import '../lib/models/keranjang.dart';
import '../lib/models/transaksi.dart';
import '../lib/models/kasir.dart';

void main() {
  // Input nama kasir
  stdout.write("Masukkan nama kasir: ");
  String? namaKasir = stdin.readLineSync();
  Kasir kasir = Kasir(
    nama: namaKasir ?? "Kasir Tanpa Nama", // Default jika nama kosong
  );

  List<Produk> produkList = [
    Produk(nama: "Merk Umama", harga: 40000, stok: 20),
    Produk(nama: "Merk Button", harga: 100000, stok: 50),
    Produk(nama: "Merk Azzura", harga: 55000, stok: 70),
    Produk(nama: "Merk Rhein", harga: 80000, stok: 40),
    Produk(nama: "Merk Candy", harga: 65000, stok: 40),
  ];

  Keranjang keranjang = Keranjang();

  while (true) {
    print("\n=== MOKA HIJAB ===");
    print("1. Lihat Produk");
    print("2. Tambah Produk ke Keranjang");
    print("3. Lihat Keranjang");
    print("4. Checkout");
    print("5. Hapus Produk dari Keranjang");
    print("6. Keluar");
    print("7. Laporan Penjualan");
    stdout.write("Pilih opsi: ");
    String? pilihan = stdin.readLineSync();

    switch (pilihan) {
      case '1':
        print("\n=== Daftar Produk Hijab ===");
        for (int i = 0; i < produkList.length; i++) {
          Produk p = produkList[i];
          print("${i + 1}. ${p.nama} - Rp${p.harga} (Stok: ${p.stok})");
        }
        break;

      case '2':
        stdout.write("Masukkan nama pembeli: ");
        String? namaPembeli = stdin.readLineSync();

        print("\n=== Daftar Produk Hijab ===");
        for (int i = 0; i < produkList.length; i++) {
          Produk p = produkList[i];
          print("${i + 1}. ${p.nama} - Rp${p.harga} (Stok: ${p.stok})");
        }

        stdout.write(
            "Masukkan nomor produk dan jumlah (angka awal untuk nomor produk : angka berikutnya untuk jumlah beli disertakan koma untuk pembelian berikutnya)= ");
        String? input = stdin.readLineSync();

        if (input != null && input.isNotEmpty) {
          List<String> pairs = input.split(',');
          bool berhasil = true;

          for (String pair in pairs) {
            List<String> parts = pair.split(':');
            if (parts.length != 2) {
              print("Format input salah untuk entri: $pair");
              berhasil = false;
              continue;
            }

            int? index = int.tryParse(parts[0]);
            int? jumlah = int.tryParse(parts[1]);

            if (index == null ||
                jumlah == null ||
                index < 1 ||
                index > produkList.length ||
                jumlah <= 0) {
              print("Nomor produk atau jumlah tidak valid untuk entri: $pair");
              berhasil = false;
              continue;
            }

            try {
              keranjang.tambahProduk(
                produkList[index - 1],
                jumlah,
                namaPembeli ?? "Pembeli Tidak Diketahui",
              );
            } catch (e) {
              print(
                  "Error saat menambahkan produk ${produkList[index - 1].nama}: $e");
              berhasil = false;
            }
          }

          if (berhasil) {
            print("Semua produk berhasil ditambahkan ke keranjang.");
          } else {
            print(
                "Ada beberapa kesalahan saat menambahkan produk ke keranjang.");
          }
        } else {
          print("Input kosong, tidak ada produk yang ditambahkan.");
        }
        break;

      case '3':
        print("\n=== Isi Keranjang ===");
        if (keranjang.items.isEmpty) {
          print("Keranjang kosong.");
        } else {
          Map<String, List<Map<String, dynamic>>> groupedByPembeli = {};

          // Grupkan item berdasarkan nama pembeli
          for (var item in keranjang.items) {
            String pembeli = item['pembeli'];
            if (!groupedByPembeli.containsKey(pembeli)) {
              groupedByPembeli[pembeli] = [];
            }
            groupedByPembeli[pembeli]!.add(item);
          }

          // Tampilkan isi keranjang untuk setiap pembeli
          groupedByPembeli.forEach((pembeli, items) {
            print("\nPembeli: $pembeli");
            double totalPembeli = 0.0;

            for (var item in items) {
              Produk p = item['produk'];
              int jumlah = item['jumlah'];
              print(
                  "- ${p.nama} x $jumlah = Rp${(p.harga * jumlah).toStringAsFixed(2)}");
              totalPembeli += p.harga * jumlah;
            }
            print("Total untuk $pembeli: Rp${totalPembeli.toStringAsFixed(2)}");
          });
          print("Total keseluruhan: Rp${keranjang.total.toStringAsFixed(2)}");
        }
        break;

      case '4':
        if (keranjang.items.isEmpty) {
          print("Keranjang kosong.");
        } else {
          // Grupkan item berdasarkan pembeli
          Map<String, List<Map<String, dynamic>>> groupedByPembeli = {};
          for (var item in keranjang.items) {
            String pembeli = item['pembeli'];
            if (!groupedByPembeli.containsKey(pembeli)) {
              groupedByPembeli[pembeli] = [];
            }
            groupedByPembeli[pembeli]!.add(item);
          }

          print("\n=== Checkout Berdasarkan Pembeli ===");
          groupedByPembeli.forEach((pembeli, items) {
            print("\nPembeli: $pembeli");
            double totalPembeli = 0.0;

            items.forEach((item) {
              Produk p = item['produk'];
              int jumlah = item['jumlah'];
              print(
                  "- ${p.nama} x $jumlah = Rp${(p.harga * jumlah).toStringAsFixed(2)}");
              totalPembeli += p.harga * jumlah;
            });
            print("Total untuk $pembeli: Rp${totalPembeli.toStringAsFixed(2)}");
          });

          stdout.write("\nMasukkan nama pembeli yang ingin di-checkout: ");
          String? namaPembeliCheckout = stdin.readLineSync();

          if (groupedByPembeli.containsKey(namaPembeliCheckout)) {
            List<Map<String, dynamic>> itemsCheckout =
                groupedByPembeli[namaPembeliCheckout!]!;

            Transaksi transaksi = Transaksi(
              tanggal: DateTime.now(),
              items: itemsCheckout,
              total: itemsCheckout.fold(0.0,
                  (sum, item) => sum + (item['produk'].harga * item['jumlah'])),
            );

            kasir.tambahTransaksi(transaksi);

            // Cetak struk dengan nama kasir
            print("\n====================");
            print("Kasir: ${kasir.nama}");
            print(transaksi.cetakStruk());

            // Hapus item pembeli yang di-checkout dari keranjang
            keranjang.items
                .removeWhere((item) => item['pembeli'] == namaPembeliCheckout);

            // Hitung ulang total keranjang
            keranjang.total = keranjang.items.fold(0.0,
                (sum, item) => sum + (item['produk'].harga * item['jumlah']));
          } else {
            print("Nama pembeli tidak ditemukan di keranjang.");
          }
        }
        break;

      case '5':
        print("\n=== Hapus Produk dari Keranjang ===");
        if (keranjang.items.isEmpty) {
          print("Keranjang kosong.");
        } else {
          for (int i = 0; i < keranjang.items.length; i++) {
            var item = keranjang.items[i];
            Produk p = item['produk'];
            int jumlah = item['jumlah'];
            String namaPembeli = item['pembeli'];
            print(
                "${i + 1}. ${p.nama} x $jumlah = Rp${p.harga * jumlah} (Pembeli: $namaPembeli)");
          }

          stdout.write(
              "Masukkan nomor produk yang ingin dihapus (atau dikurangi jumlahnya): ");
          int? hapusIndex = int.tryParse(stdin.readLineSync()!) ?? -1;

          if (hapusIndex > 0 && hapusIndex <= keranjang.items.length) {
            var item = keranjang.items[hapusIndex - 1];
            Produk p = item['produk'];
            int jumlahSaatIni = item['jumlah'];
            stdout.write(
                "Masukkan jumlah produk yang ingin dihapus (1 - $jumlahSaatIni): ");
            int? jumlahHapus = int.tryParse(stdin.readLineSync()!) ?? 0;

            if (jumlahHapus > 0 && jumlahHapus <= jumlahSaatIni) {
              keranjang.kurangiProduk(hapusIndex - 1, jumlahHapus);
              print("$jumlahHapus ${p.nama} berhasil dihapus dari keranjang.");
            } else {
              print("Jumlah yang ingin dihapus tidak valid.");
            }
          } else {
            print("Nomor produk tidak valid.");
          }
        }
        break;

      case '7':
        print("\n=== Laporan Penjualan ===");
        if (kasir.laporanPenjualan().isEmpty) {
          print("Belum ada transaksi.");
        } else {
          Map<String, List<Transaksi>> riwayatPerPembeli = {};

          // Grupkan transaksi berdasarkan nama pembeli
          for (var transaksi in kasir.laporanPenjualan()) {
            for (var item in transaksi.items) {
              String pembeli = item['pembeli'];

              if (!riwayatPerPembeli.containsKey(pembeli)) {
                riwayatPerPembeli[pembeli] = [];
              }
              riwayatPerPembeli[pembeli]!.add(transaksi);
            }
          }

          // Tampilkan laporan per pembeli
          riwayatPerPembeli.forEach((pembeli, transaksiList) {
            print("\nPembeli: $pembeli");
            double totalKeseluruhan = 0.0;

            for (var transaksi in transaksiList) {
              print("\nTanggal: ${transaksi.formatTanggal(transaksi.tanggal)}");
              for (var item in transaksi.items) {
                Produk p = item['produk'];
                int jumlah = item['jumlah'];
                print(
                    "- ${p.nama} x $jumlah = Rp${(p.harga * jumlah).toStringAsFixed(2)}");
              }
              print("Subtotal: Rp${transaksi.total.toStringAsFixed(2)}");
              totalKeseluruhan += transaksi.total;
            }

            print(
                "\nTotal untuk $pembeli: Rp${totalKeseluruhan.toStringAsFixed(2)}");
          });
        }
        break;

      case '6':
        print("Terima kasih telah menggunakan POS!");
        exit(0);

      default:
        print("Pilihan tidak valid.");
    }
  }
}
