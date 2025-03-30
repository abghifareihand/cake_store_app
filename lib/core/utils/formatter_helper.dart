import 'package:intl/intl.dart';

class FormatterHelper {
  static String formatRupiah(int amount) {
    final formatter = NumberFormat("#,##0", "id_ID");
    return 'Rp ${formatter.format(amount)}';
  }

  static String formatDate(DateTime dateTime) {
    // List bulan dalam bahasa Indonesia
    List<String> bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    // Ambil tanggal, bulan, dan tahun
    String tanggal = dateTime.day.toString();
    String bulanIndo = bulan[dateTime.month - 1];
    String tahun = dateTime.year.toString();

    // Gabungkan menjadi format yang diinginkan
    return '$tanggal $bulanIndo $tahun';
  }
}
