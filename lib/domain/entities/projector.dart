class Projector {
  final String id;
  final String model;
  final String serialNumber;
  final bool isAvailable;
  final String? currentLocation;
  final DateTime? lastMaintenance;

  Projector({
    required this.id,
    required this.model,
    required this.serialNumber,
    this.isAvailable = true,
    this.currentLocation,
    this.lastMaintenance,
  });

  Projector copyWith({
    String? id,
    String? model,
    String? serialNumber,
    bool? isAvailable,
    String? currentLocation,
    DateTime? lastMaintenance,
  }) {
    return Projector(
      id: id ?? this.id,
      model: model ?? this.model,
      serialNumber: serialNumber ?? this.serialNumber,
      isAvailable: isAvailable ?? this.isAvailable,
      currentLocation: currentLocation ?? this.currentLocation,
      lastMaintenance: lastMaintenance ?? this.lastMaintenance,
    );
  }
}
