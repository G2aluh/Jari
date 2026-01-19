import 'package:flutter/material.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:benang_merah/app/modules/kategori/views/kategori_list_view.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text('Kategori Barang', style: AppTextStyles.primaryText),
        ),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, int index) {
              final kategori = kategoriList[index];
              return Container(
                width: 90,
                padding: EdgeInsets.all(4),
                height: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kategori.warna,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //KATEGORI
                    Icon(
                      kategori.icon,
                      size: kategori.ukuranIcon.width,
                      color: kategori.warnaIcon,
                    ),
                    SizedBox(height: 8),
                    //NAMA KATEGORI
                    Text(
                      kategori.nama,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: kategori.warnaNama,
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, int index) => SizedBox(width: 16),
            itemCount: kategoriList.length,
          ),
        ),
      ],
    );
  }
}
