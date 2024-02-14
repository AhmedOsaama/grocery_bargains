import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../models/User.dart';

abstract class ProfileRepo{
  Future<Either<Failure, AuthUser>> fetchUserData();
  Future<Either<Failure, bool>> updateUserData(Map<Object, dynamic> data);
}