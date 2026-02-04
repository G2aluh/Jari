import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
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

  Alat? _tempSelectedAlat;
  final TextEditingController _jumlahController = TextEditingController(
    text: '1',
  );
  final RxList<AlatSelection> _selectedAlatList = <AlatSelection>[].obs;
  final Map<dynamic, int> _originalQuantities = {};

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
        _originalQuantities[detail.alat!.id] = detail.jumlah;
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
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final dialogWidth = isTablet ? 560.0 : 500.0;
    final titleSize = isTablet ? 24.0 : 20.0;
    final labelSize = isTablet ? 16.0 : 14.0;
    final textSize = isTablet ? 16.0 : 14.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final spacing = isTablet ? 20.0 : 16.0;
    final borderRadius = isTablet ? 20.0 : 16.0;
    final contentPadding = isTablet ? 28.0 : 24.0;
    final iconSize = isTablet ? 24.0 : 20.0;
    final buttonPadding = isTablet ? 18.0 : 16.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: dialogWidth,
        padding: EdgeInsets.all(contentPadding),
        decoration: BoxDecoration(
          color: Warna.hitamBackground,
          borderRadius: BorderRadius.circular(borderRadius),
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
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Warna.putih,
                      size: isTablet ? 28 : 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 12 : 8),

              // Kode Peminjaman (read-only)
              Text(
                'Kode: ${widget.peminjaman.kodePeminjaman ?? "-"}',
                style: TextStyle(color: Warna.ungu, fontSize: labelSize),
              ),
              SizedBox(height: spacing + 8),

              // Status Dropdown
              Text(
                'Status',
                style: TextStyle(
                  color: Warna.putih.withOpacity(0.7),
                  fontSize: labelSize,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 16 : 12,
                  vertical: isTablet ? 6 : 4,
                ),
                decoration: BoxDecoration(
                  color: Warna.hitamTransparan,
                  borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
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
                          style: TextStyle(
                            color: Warna.putih,
                            fontSize: textSize,
                          ),
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
              SizedBox(height: spacing),

              // Tanggal Jatuh Tempo
              Text(
                'Tanggal Jatuh Tempo',
                style: TextStyle(
                  color: Warna.putih.withOpacity(0.7),
                  fontSize: labelSize,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: EdgeInsets.all(isTablet ? 18 : 16),
                  decoration: BoxDecoration(
                    color: Warna.hitamTransparan,
                    borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    border: Border.all(color: Warna.putih.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.event, color: Warna.ungu, size: iconSize),
                      SizedBox(width: isTablet ? 16 : 12),
                      Text(
                        _formatDate(_tanggalJatuhTempo),
                        style: TextStyle(
                          color: Warna.putih,
                          fontSize: textSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing),

              Divider(color: Warna.putih.withOpacity(0.1)),
              SizedBox(height: spacing),

              // Alat Selection Section
              Text(
                'Daftar Alat',
                style: TextStyle(
                  color: Warna.putih.withOpacity(0.7),
                  fontSize: labelSize,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),

              // Row 1: Dropdown Full Width
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 16 : 12,
                    vertical: isTablet ? 6 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: Warna.hitamTransparan,
                    borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    border: Border.all(color: Warna.putih.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Alat>(
                      isExpanded: true,
                      dropdownColor: Warna.hitamBackground,
                      hint: Text(
                        'Tambah Alat',
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.5),
                          fontSize: textSize,
                        ),
                      ),
                      value: _tempSelectedAlat,
                      items: widget.controller.alatList.map((alat) {
                        return DropdownMenuItem<Alat>(
                          value: alat,
                          child: Text(
                            '${alat.namaAlat} (Stok: ${alat.stokTersedia})',
                            style: TextStyle(
                              color: Warna.putih,
                              fontSize: textSize,
                            ),
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
              SizedBox(height: isTablet ? 16 : 12),

              // Row 2: Quantity and Add Button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _jumlahController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Warna.putih, fontSize: textSize),
                      decoration: InputDecoration(
                        hintText: 'Jumlah Item',
                        prefixIcon: Icon(
                          Icons.numbers,
                          color: Warna.putih.withOpacity(0.5),
                          size: isTablet ? 22 : 18,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 16 : 12,
                          vertical: isTablet ? 18 : 14,
                        ),
                        filled: true,
                        fillColor: Warna.hitamTransparan,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                          borderSide: BorderSide(
                            color: Warna.putih.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Warna.ungu,
                      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    ),
                    child: IconButton(
                      onPressed: _addAlatToList,
                      icon: Icon(Icons.add, color: Warna.putih, size: iconSize),
                      tooltip: 'Tambah Alat',
                      padding: EdgeInsets.all(isTablet ? 14 : 12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing),

              // Loading Items Indicator
              if (_isLoadingDetails)
                Center(child: CircularProgressIndicator(color: Warna.ungu)),

              // Selected Alat List
              Obx(
                () => _selectedAlatList.isNotEmpty
                    ? Container(
                        constraints: BoxConstraints(
                          maxHeight: isTablet ? 180 : 150,
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _selectedAlatList.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: isTablet ? 12 : 8),
                          itemBuilder: (context, index) {
                            final selection = _selectedAlatList[index];
                            return Container(
                              padding: EdgeInsets.all(isTablet ? 16 : 12),
                              decoration: BoxDecoration(
                                color: Warna.hitamTransparan,
                                borderRadius: BorderRadius.circular(
                                  isTablet ? 16 : 12,
                                ),
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
                                      style: TextStyle(
                                        color: Warna.putih,
                                        fontSize: textSize,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${selection.jumlah}x',
                                    style: TextStyle(
                                      color: Warna.ungu,
                                      fontWeight: FontWeight.bold,
                                      fontSize: textSize,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _selectedAlatList.removeAt(index);
                                    },
                                    icon: Padding(
                                      padding: EdgeInsets.only(
                                        left: isTablet ? 12 : 8,
                                      ),
                                      child: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red.withOpacity(0.7),
                                        size: iconSize,
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

              SizedBox(height: spacing),

              // Catatan (visible when ditolak)
              if (_status == StatusPeminjaman.ditolak) ...[
                Text(
                  'Catatan Penolakan',
                  style: TextStyle(
                    color: Warna.putih.withOpacity(0.7),
                    fontSize: labelSize,
                  ),
                ),
                SizedBox(height: isTablet ? 12 : 8),
                TextField(
                  controller: _catatanController,
                  maxLines: 3,
                  style: TextStyle(color: Warna.putih, fontSize: textSize),
                  decoration: InputDecoration(
                    hintText: 'Masukkan alasan penolakan...',
                    hintStyle: TextStyle(
                      color: Warna.putih.withOpacity(0.5),
                      fontSize: textSize,
                    ),
                    filled: true,
                    fillColor: Warna.hitamTransparan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                      borderSide: BorderSide(
                        color: Warna.putih.withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                      borderSide: BorderSide(
                        color: Warna.putih.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                      borderSide: BorderSide(color: Warna.ungu),
                    ),
                  ),
                ),
                SizedBox(height: spacing),
              ],

              SizedBox(height: isTablet ? 12 : 8),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: buttonPadding),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: Warna.putih,
                          fontSize: buttonFontSize,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Warna.ungu,
                        padding: EdgeInsets.symmetric(vertical: buttonPadding),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: isTablet ? 24 : 20,
                              height: isTablet ? 24 : 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Warna.putih,
                              ),
                            )
                          : Text(
                              'Simpan',
                              style: TextStyle(
                                color: Warna.putih,
                                fontSize: buttonFontSize,
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
        margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      );
      return;
    }

    final existingIndex = _selectedAlatList.indexWhere(
      (item) => item.alat.id == _tempSelectedAlat!.id,
    );

    final currentQty = existingIndex != -1
        ? _selectedAlatList[existingIndex].jumlah
        : 0;
    final originalQty = _originalQuantities[_tempSelectedAlat!.id] ?? 0;
    final proposedTotal = currentQty + jumlah;
    final neededFromWarehouse = proposedTotal - originalQty;

    if (neededFromWarehouse > _tempSelectedAlat!.stokTersedia) {
      Get.snackbar(
        'Stok Tidak Cukup',
        'Stok tidak mencukupi (Tersedia: ${_tempSelectedAlat!.stokTersedia})',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      );
      return;
    }

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

    final headerSuccess = await widget.controller.updatePeminjaman(
      id: widget.peminjaman.id,
      status: _status,
      tanggalJatuhTempo: _tanggalJatuhTempo,
      catatanPenolakan: _status == StatusPeminjaman.ditolak
          ? _catatanController.text
          : null,
    );

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
