import 'package:bargainb/core/errors/failures.dart';
import 'package:bargainb/features/onboarding/data/models/BotResponse.dart';
import 'package:dartz/dartz.dart';

abstract class OnboardingRepo{
  Future<Either<Failure, BotResponse>> fetchBotResponse({required String storeName});
}