import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboardController extends GetxController {
  final supabase = Supabase.instance.client;

  final totalTransaksi = 0.obs;
  final menunggu = 0.obs;
  final ditolak = 0.obs;
  final totalAlat = 0.obs;
  final totalKategori = 0.obs;
  late final RealtimeChannel _dashboardChannel;

  final isLoading = false.obs;

  @override
  void onClose() {
    supabase.realtime.removeChannel(_dashboardChannel);
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    fetchSummary();
    _listenRealtime();
  }

  void _listenRealtime() {
    _dashboardChannel = supabase.channel('dashboard-admin');

    _dashboardChannel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'peminjaman',
          callback: (payload) {
            fetchSummary();
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'alat',
          callback: (payload) {
            fetchSummary();
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'kategori_alat',
          callback: (payload) {
            fetchSummary();
          },
        );

    _dashboardChannel.subscribe();
  }

  Future<void> fetchSummary() async {
    try {
      isLoading.value = true;

      final transaksi = await supabase
          .from('peminjaman')
          .select('id')
          .count(CountOption.exact);

      totalTransaksi.value = transaksi.count ?? 0;

      final menungguResult = await supabase
          .from('peminjaman')
          .select('id')
          .eq('status', 'menunggu')
          .count(CountOption.exact);

      menunggu.value = menungguResult.count ?? 0;

      final ditolakResult = await supabase
          .from('peminjaman')
          .select('id')
          .eq('status', 'ditolak')
          .count(CountOption.exact);

      ditolak.value = ditolakResult.count ?? 0;

      final alatResult = await supabase
          .from('alat')
          .select('id')
          .eq('aktif', true)
          .count(CountOption.exact);

      totalAlat.value = alatResult.count ?? 0;

      final kategoriResult = await supabase
          .from('kategori_alat')
          .select('id')
          .count(CountOption.exact);

      totalKategori.value = kategoriResult.count ?? 0;
    } catch (e) {
      print('Dashboard error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
