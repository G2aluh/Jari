import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/admin/controllers/peminjaman_controller.dart';
import 'package:jari/app/modules/admin/models/alat_model.dart';
import 'package:jari/app/modules/admin/models/detail_peminjaman_model.dart';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditLoanDialog extends StatefulWidget {
  final Peminjaman peminjaman;
  final PeminjamanController controller;

  const EditLoanDialog({
    super.key,
    required this.peminjaman,
    required this.controller,
  });

  @override
  State<EditLoanDialog> createState() => _EditLoanDialogState();
}

class _EditLoanDialogState extends State<EditLoanDialog> {
  late StatusPeminjaman _status;
  late DateTime _tanggalJatuhTempo;
  late TextEditingController _catatanController;

  // Alat Selection State
  Alat? _tempSelectedAlat;
  final TextEditingController _jumlahController = TextEditingController(
    text: '1',
  );
  final RxList<AlatSelection> _selectedAlatList = <AlatSelection>[].obs;

  bool _isLoading = false;
  bool _isLoadingDetails = true;

  @override
  void initState() {
    super.initState();
    _status = widget.peminjaman.status;
    _tanggalJatuhTempo = widget.peminjaman.tanggalJatuhTempo ?? DateTime.now();
    _catatanController = TextEditingController(
      text: widget.peminjaman.catatanPenolakan ?? '',
    );
    _loadExistingItems();
  }

  Future<void> _loadExistingItems() async {
    final details = await widget.controller.fetchDetailPeminjaman(
      widget.peminjaman.id,
    );

    for (var detail in details) {
      if (detail.alat != null) {
        _selectedAlatList.add(
          AlatSelection(alat: detail.alat!, jumlah: detail.jumlah),
        );
      }
    }

    setState(() => _isLoadingDetails = false);
  }

  @override
  void dispose() {
    _catatanController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Warna.hitamBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Warna.putih.withOpacity(0.1)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Peminjaman',
                    style: TextStyle(
                      color: Warna.putih,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Warna.putih),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Kode Peminjaman (read-only)
              Text(
                'Kode: ${widget.peminjaman.kodePeminjaman ?? "-"}',
                style: TextStyle(color: Warna.ungu, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Status Dropdown
              Text(
                'Status',
                style: TextStyle(
                  color: Warna.putih.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Warna.hitamTransparan,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Warna.putih.withOpacity(0.2)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<StatusPeminjaman>(
                    isExpanded: true,
                    dropdownColor: Warna.hitamBackground,
                    value: _status,
                    items: StatusPeminjaman.values.map((status) {
                      return DropdownMenuItem<StatusPeminjaman>(
                        value: status,
                        child: Text(
                          status.displayName,
                          style: TextStyle(color: Warna.putih),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _status = value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tanggal Jatuh Tempo
              Text(
                'Tanggal Jatuh Tempo',
                style: TextStyle(
                  color: Warna.putih.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Warna.hitamTransparan,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Warna.putih.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.event, color: Warna.ungu, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(_tanggalJatuhTempo),
                        style: TextStyle(color: Warna.putih),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Divider(color: Warna.putih.withOpacity(0.1)),
              const SizedBox(height: 16),

              // Alat Selection Section
              Text(
                'Daftar Alat',
                style: TextStyle(
                  color: Warna.putih.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),

              // Row 1: Dropdown Full Width
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Warna.hitamTransparan,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Warna.putih.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Alat>(
                      isExpanded: true,
                      dropdownColor: Warna.hitamBackground,
                      hint: Text(
                        'Tambah Alat',
                        style: TextStyle(color: Warna.putih.withOpacity(0.5)),
                      ),
                      value: _tempSelectedAlat,
                      items: widget.controller.alatList.map((alat) {
                        return DropdownMenuItem<Alat>(
                          value: alat,
                          child: Text(
                            '${alat.namaAlat} (Stok: ${alat.stokTersedia})',
                            style: TextStyle(color: Warna.putih),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _tempSelectedAlat = value);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Row 2: Quantity and Add Button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _jumlahController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Warna.putih),
                      decoration: InputDecoration(
                        hintText: 'Jumlah Item',
                        prefixIcon: Icon(
                          Icons.numbers,
                          color: Warna.putih.withOpacity(0.5),
                          size: 18,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        filled: true,
                        fillColor: Warna.hitamTransparan,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Warna.putih.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Warna.ungu,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: _addAlatToList,
                      icon: Icon(Icons.add, color: Warna.putih),
                      tooltip: 'Tambah Alat',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Loading Items Indicator
              if (_isLoadingDetails)
                Center(child: CircularProgressIndicator(color: Warna.ungu)),

              // Selected Alat List
              Obx(
                () => _selectedAlatList.isNotEmpty
                    ? Container(
                        constraints: BoxConstraints(maxHeight: 150),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _selectedAlatList.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final selection = _selectedAlatList[index];
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Warna.hitamTransparan,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Warna.putih.withOpacity(0.1),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      selection.alat.namaAlat,
                                      style: TextStyle(color: Warna.putih),
                                    ),
                                  ),
                                  Text(
                                    '${selection.jumlah}x',
                                    style: TextStyle(
                                      color: Warna.ungu,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _selectedAlatList.removeAt(index);
                                    },
                                    icon: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red.withOpacity(0.7),
                                      ),
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : SizedBox(),
              ),

              const SizedBox(height: 16),

              // Catatan (visible when ditolak)
              if (_status == StatusPeminjaman.ditolak) ...[
                Text(
                  'Catatan Penolakan',
                  style: TextStyle(
                    color: Warna.putih.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _catatanController,
                  maxLines: 3,
                  style: TextStyle(color: Warna.putih),
                  decoration: InputDecoration(
                    hintText: 'Masukkan alasan penolakan...',
                    hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
                    filled: true,
                    fillColor: Warna.hitamTransparan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Warna.putih.withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Warna.putih.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Warna.ungu),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 8),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(color: Warna.putih),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Warna.ungu,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Warna.putih,
                              ),
                            )
                          : Text(
                              'Simpan',
                              style: TextStyle(
                                color: Warna.putih,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addAlatToList() {
    if (_tempSelectedAlat == null) return;

    final jumlahStr = _jumlahController.text;
    final jumlah = int.tryParse(jumlahStr) ?? 0;

    if (jumlah <= 0) {
      Get.snackbar(
        'Error',
        'Jumlah harus lebih dari 0',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Note: Di edit mode, kita tidak bisa validasi stok dengan mudah
    // karena mungkin kita sedang edit item yang sudah ada.
    // Jadi validasi stok sebaiknya di DB trigger atau lenient here.
    // Tapi jika item baru, harusnya cek stok.

    // Cek apakah alat sudah ada di list
    final existingIndex = _selectedAlatList.indexWhere(
      (item) => item.alat.id == _tempSelectedAlat!.id,
    );

    if (existingIndex != -1) {
      _selectedAlatList[existingIndex].jumlah += jumlah;
      _selectedAlatList.refresh();
    } else {
      _selectedAlatList.add(
        AlatSelection(alat: _tempSelectedAlat!, jumlah: jumlah),
      );
    }

    setState(() {
      _tempSelectedAlat = null;
      _jumlahController.text = '1';
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalJatuhTempo,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Warna.ungu,
              onPrimary: Warna.putih,
              surface: Warna.hitamBackground,
              onSurface: Warna.putih,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _tanggalJatuhTempo = picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    // 1. Update Header Peminjaman
    final headerSuccess = await widget.controller.updatePeminjaman(
      id: widget.peminjaman.id,
      status: _status,
      tanggalJatuhTempo: _tanggalJatuhTempo,
      catatanPenolakan: _status == StatusPeminjaman.ditolak
          ? _catatanController.text
          : null,
    );

    // 2. Update Items
    bool itemsSuccess = true;
    if (headerSuccess) {
      itemsSuccess = await widget.controller.updateLoanItems(
        widget.peminjaman.id,
        _selectedAlatList,
      );
    }

    setState(() => _isLoading = false);

    if (headerSuccess && itemsSuccess) {
      Navigator.pop(context);
    }
  }
}
