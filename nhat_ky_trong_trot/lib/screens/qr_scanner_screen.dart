import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nhat_ky_trong_trot/models/farming_log.dart';
import 'package:photo_view/photo_view.dart';
import 'package:nhat_ky_trong_trot/theme/app_theme.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  FarmingLog? _scannedLog;
  bool _showResult = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Truy xuất Nguồn gốc'),
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on),
            onPressed: () => cameraController.toggleTorch(),
          ),
        ],
      ),
      body: _showResult ? _buildResultView() : _buildScannerView(),
    );
  }

  Widget _buildScannerView() {
    return MobileScanner(
      controller: cameraController,
      onDetect: (capture) {
        final barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          if (!_showResult) {
            try {
              final logData = jsonDecode(barcode.rawValue ?? '');
              setState(() {
                _scannedLog = FarmingLog.fromMap(logData);
                _showResult = true;
              });
            } catch (e) {
              setState(() {
                _scannedLog = null;
                _showResult = true;
              });
            }
          }
        }
      },
    );
  }

  Widget _buildResultView() {
    if (_scannedLog == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Không thể đọc thông tin sản phẩm'),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => setState(() => _showResult = false),
              icon: Icon(Icons.qr_code_scanner),
              label: Text('Quét lại'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Thông tin sản phẩm', [
            'Địa điểm: ${_scannedLog!.productionLocation}',
            'Cơ sở: ${_scannedLog!.productionFacility}',
            'Giống cây: ${_scannedLog!.plantType}',
          ]),
          if (_scannedLog!.careDetails.isNotEmpty)
            _buildInfoCard('Chăm sóc', [
              _scannedLog!.careDetails,
              'Bón phân: ${_scannedLog!.fertilization}',
              'Tưới nước: ${_scannedLog!.watering}',
            ]),
          if (_scannedLog!.careImages.isNotEmpty)
            _buildImageSection('Hình ảnh chăm sóc', _scannedLog!.careImages),
          if (_scannedLog!.spraying.isNotEmpty)
            _buildInfoCard('Phun thuốc', [
              _scannedLog!.spraying,
              'Tần suất: ${_scannedLog!.sprayingFrequency}',
            ]),
          if (_scannedLog!.sprayingImages.isNotEmpty)
            _buildImageSection('Hình ảnh phun thuốc', _scannedLog!.sprayingImages),
          if (_scannedLog!.harvestDate.isNotEmpty)
            _buildInfoCard('Thu hoạch', [
              'Ngày thu hoạch: ${_scannedLog!.harvestDate}',
            ]),
          if (_scannedLog!.harvestImages.isNotEmpty)
            _buildImageSection('Hình ảnh thu hoạch', _scannedLog!.harvestImages),
          if (_scannedLog!.storageInDate.isNotEmpty && _scannedLog!.storageOutDate.isNotEmpty)
            _buildInfoCard('Bảo quản', [
              'Nhập kho: ${_scannedLog!.storageInDate}',
              'Xuất kho: ${_scannedLog!.storageOutDate}',
              'Thời gian bảo quản: ${_scannedLog!.storageDays} ngày',
            ]),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => setState(() => _showResult = false),
                icon: Icon(Icons.qr_code_scanner),
                label: Text('Quét lại'),
              ),
              ElevatedButton.icon(
                onPressed: _shareInfo,
                icon: Icon(Icons.share),
                label: Text('Chia sẻ'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<String> items) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8),
            ...items.map((item) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(item, style: Theme.of(context).textTheme.bodyLarge),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(String title, List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (ctx, i) => GestureDetector(
              onTap: () => _showFullImage(images[i]),
              child: Container(
                width: 200,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: AppTheme.cardShadow,
                  image: DecorationImage(
                    image: FileImage(File(images[i])),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  void _showFullImage(String imagePath) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: PhotoView(
          imageProvider: FileImage(File(imagePath)),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ),
    );
  }

  void _shareInfo() {
    // TODO: Triển khai chức năng chia sẻ
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
