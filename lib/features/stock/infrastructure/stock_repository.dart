// ignore_for_file: strict_raw_type

import 'package:dartz/dartz.dart';

import '../../core/infrastructure/exceptions.dart';
import 'stock_remote_service.dart';

class StockRepository {
  StockRepository(this._remoteService);

  final StockRemoteService _remoteService;

  // Future<Either<RemoteResponse, List<PatientDataState>>> getPatients(
  //     int pageNumber) async {
  //   try {
  //     final patients = await _remoteService.getPatients(pageNumber);

  //     return right(patients);
  //   } on RestApiException catch (error) {
  //     return left(RemoteResponse.failure(
  //         errorCode: error.errorCode, message: error.message));
  //   } on FormatException {
  //     return left(const RemoteResponse.failure(
  //         errorCode: 0, message: 'Parsing patients error'));
  //   } on NoConnectionException {
  //     return left(const RemoteResponse.failure(
  //         errorCode: 0, message: 'No connection '));
  //   } on UnauthorizedException catch (error) {
  //     return left(RemoteResponse.unauthorized(
  //         errorCode: error.errorCode, message: error.message));
  //   }
  // }
}
