import 'package:bargainb/features/onboarding/data/models/BotResponse.dart';
import 'package:bargainb/features/onboarding/data/repos/onboarding_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bot_response_state.dart';

class BotResponseCubit extends Cubit<BotResponseState> {
  BotResponseCubit(this.onboardingRepo) : super(BotResponseInitial());

  final OnboardingRepo onboardingRepo;

  Future<void> fetchBotResponse(String storeName) async {
    emit(BotResponseLoading());
    var result = await onboardingRepo.fetchBotResponse(storeName: storeName);
    result.fold((failure) => emit(BotResponseFailure(failure.errorMessage)), (books) => emit(BotResponseSuccess(books)));
  }
}
