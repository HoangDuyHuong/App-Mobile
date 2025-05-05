import 'package:intl/intl.dart';

class FarmingLog {
  final String id;
  String productionLocation;
  String productionFacility;
  String plantType;
  String careDetails;
  String fertilization;
  String watering;
  String spraying;
  String sprayingFrequency;
  String harvestDate;
  String storageInDate;
  String storageOutDate;
  List<String> careImages;
  List<String> sprayingImages;
  List<String> harvestImages;
  final DateTime createdAt;

  FarmingLog({
    required this.id,
    required this.productionLocation,
    required this.productionFacility,
    required this.plantType,
    this.careDetails = '',
    this.fertilization = '',
    this.watering = '',
    this.spraying = '',
    this.sprayingFrequency = '',
    this.harvestDate = '',
    this.storageInDate = '',
    this.storageOutDate = '',
    this.careImages = const [],
    this.sprayingImages = const [],
    this.harvestImages = const [],
    required this.createdAt,
  });

  // Tính toán số ngày bảo quản chính xác
  int get storageDays {
    if (storageInDate.isEmpty || storageOutDate.isEmpty) return 0;
    
    try {
      final format = DateFormat('dd/MM/yyyy');
      final inDate = format.parse(storageInDate);
      final outDate = format.parse(storageOutDate);
      return outDate.difference(inDate).inDays;
    } catch (e) {
      return 0;
    }
  }

  // Chuyển đổi thành Map để lưu trữ
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productionLocation': productionLocation,
      'productionFacility': productionFacility,
      'plantType': plantType,
      'careDetails': careDetails,
      'fertilization': fertilization,
      'watering': watering,
      'spraying': spraying,
      'sprayingFrequency': sprayingFrequency,
      'harvestDate': harvestDate,
      'storageInDate': storageInDate,
      'storageOutDate': storageOutDate,
      'careImages': careImages,
      'sprayingImages': sprayingImages,
      'harvestImages': harvestImages,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Tạo từ Map
  factory FarmingLog.fromMap(Map<String, dynamic> map) {
    return FarmingLog(
      id: map['id'],
      productionLocation: map['productionLocation'],
      productionFacility: map['productionFacility'],
      plantType: map['plantType'],
      careDetails: map['careDetails'] ?? '',
      fertilization: map['fertilization'] ?? '',
      watering: map['watering'] ?? '',
      spraying: map['spraying'] ?? '',
      sprayingFrequency: map['sprayingFrequency'] ?? '',
      harvestDate: map['harvestDate'] ?? '',
      storageInDate: map['storageInDate'] ?? '',
      storageOutDate: map['storageOutDate'] ?? '',
      careImages: List<String>.from(map['careImages'] ?? []),
      sprayingImages: List<String>.from(map['sprayingImages'] ?? []),
      harvestImages: List<String>.from(map['harvestImages'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}