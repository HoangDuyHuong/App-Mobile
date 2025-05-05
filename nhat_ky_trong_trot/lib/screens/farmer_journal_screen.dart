import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:nhat_ky_trong_trot/models/farming_log.dart';

class FarmerJournalScreen extends StatefulWidget {
  @override
  _FarmerJournalScreenState createState() => _FarmerJournalScreenState();
}

class _FarmerJournalScreenState extends State<FarmerJournalScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final FarmingLog _log = FarmingLog(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    productionLocation: '',
    productionFacility: '',
    plantType: '',
    createdAt: DateTime.now(),
  );

  List<XFile> _careImages = [];
  List<XFile> _sprayingImages = [];
  List<XFile> _harvestImages = [];
  bool _qrGenerated = false;
  String _qrData = '';

  Future<void> _pickImage(List<XFile> imageList) async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => imageList.add(image));
    }
  }

  void _generateQRCode() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final logMap = _log.toMap()
        ..['careImages'] = _careImages.map((e) => e.path).toList()
        ..['sprayingImages'] = _sprayingImages.map((e) => e.path).toList()
        ..['harvestImages'] = _harvestImages.map((e) => e.path).toList();

      setState(() {
        _qrData = jsonEncode(logMap);
        _qrGenerated = true;
      });
    }
  }

  void _saveLog() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nhật ký đã được lưu thành công!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nhật ký Trồng trọt')),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateQRCode,
        child: Icon(Icons.qr_code),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildSection('Thông tin cơ bản', [
                _buildTextField('Địa điểm sản xuất', (v) => _log.productionLocation = v),
                _buildTextField('Cơ sở sản xuất', (v) => _log.productionFacility = v),
                _buildTextField('Giống cây', (v) => _log.plantType = v),
              ]),
              _buildSection('Chăm sóc', [
                _buildTextField('Chi tiết chăm sóc', (v) => _log.careDetails = v, lines: 3),
                _buildTextField('Bón phân', (v) => _log.fertilization = v),
                _buildTextField('Tưới nước', (v) => _log.watering = v),
                _buildImagePicker('Hình ảnh chăm sóc', _careImages),
              ]),
              _buildSection('Phun thuốc', [
                _buildTextField('Chi tiết phun thuốc', (v) => _log.spraying = v),
                _buildTextField('Tần suất (vd: 7 ngày/lần)', (v) => _log.sprayingFrequency = v),
                _buildImagePicker('Hình ảnh phun thuốc', _sprayingImages),
              ]),
              _buildSection('Thu hoạch', [
                _buildTextField('Ngày thu hoạch (dd/MM/yyyy)', (v) => _log.harvestDate = v),
                _buildImagePicker('Hình ảnh thu hoạch', _harvestImages),
              ]),
              _buildSection('Bảo quản', [
                _buildTextField('Ngày nhập kho (dd/MM/yyyy)', (v) => _log.storageInDate = v),
                _buildTextField('Ngày xuất kho (dd/MM/yyyy)', (v) => _log.storageOutDate = v),
                Text('Thời gian bảo quản: ${_log.storageDays} ngày'),
              ]),
              if (_qrGenerated) _buildQRCodeSection(),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _saveLog,
                icon: Icon(Icons.save),
                label: Text('Lưu nhật ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildTextField(String label, Function(String) onSaved, {int lines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        maxLines: lines,
        onSaved: (v) => onSaved(v ?? ''),
      ),
    );
  }

  Widget _buildImagePicker(String label, List<XFile> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () => _pickImage(images),
          icon: Icon(Icons.camera_alt),
          label: Text(label),
        ),
        if (images.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (ctx, i) => Padding(
                padding: EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(images[i].path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQRCodeSection() {
    return Column(
      children: [
        SizedBox(height: 20),
        Text('Mã QR sản phẩm', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 8),
        QrImageView(
          data: _qrData,
          version: QrVersions.auto,
          size: 200,
        ),
        Text('Vui lòng lưu lại mã này'),
      ],
    );
  }
}
