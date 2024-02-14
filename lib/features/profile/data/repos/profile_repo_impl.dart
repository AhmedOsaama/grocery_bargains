import 'package:bargainb/core/errors/failures.dart';
import 'package:bargainb/core/utils/firestore_utils.dart';
import 'package:bargainb/core/utils/user_utils.dart';
import 'package:bargainb/features/profile/data/models/User.dart';
import 'package:bargainb/features/profile/data/repos/profile_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class ProfileRepoImpl implements ProfileRepo{
  @override
  Future<Either<Failure, AuthUser>> fetchUserData() async {
    try {
      var data = await FirestoreUtils.firestoreUserCollection.doc(UserUtils.userId).get();
      AuthUser user = AuthUser.fromJson(data.data());
      return Right(user);
    }catch(e){
      if(e is FirebaseException){
        return Left(ServerFailure.fromFirebaseException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateUserData(Map<Object, dynamic> data) async {
    try {
      await FirestoreUtils.firestoreUserCollection.doc(UserUtils.userId).update(data);
      return const Right(true);
    }catch(e){
      if(e is FirebaseException){
        return Left(ServerFailure.fromFirebaseException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

}