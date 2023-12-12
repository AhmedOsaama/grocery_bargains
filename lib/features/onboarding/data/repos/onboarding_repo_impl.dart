import 'package:bargainb/core/errors/failures.dart';
import 'package:bargainb/core/utils/bot_service.dart';
import 'package:bargainb/features/onboarding/data/models/BotResponse.dart';
import 'package:bargainb/features/onboarding/data/repos/onboarding_repo.dart';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class OnboardingRepoImpl extends OnboardingRepo{
  final BotService botService;

  OnboardingRepoImpl(this.botService);

  @override
  Future<Either<Failure, BotResponse>> fetchBotResponse({required String storeName}) async {
    try{
      var data = await botService.post(message: '@BB show me the top deals from $storeName');
      BotResponse botResponse = BotResponse.fromJson(data);
      return Right(botResponse);
    }catch(e){
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

}