import '../entities/projector.dart';

abstract class ProjectorRepository {
  Future<List<Projector>> getAllProjectors();
  Future<Projector> getProjectorById(String id);
  Future<void> addProjector(Projector projector);
  Future<void> updateProjector(Projector projector);
  Future<void> deleteProjector(String id);
  Future<List<Projector>> getAvailableProjectors();
  Future<List<Projector>> getProjectorsByLocation(String location);
}
