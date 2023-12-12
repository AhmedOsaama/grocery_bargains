part of 'bot_response_cubit.dart';

@immutable
abstract class BotResponseState {}

class BotResponseInitial extends BotResponseState {}
class BotResponseFailure extends BotResponseState {
  final String errorMessage;

  BotResponseFailure(this.errorMessage);
}
class BotResponseLoading extends BotResponseState {}
class BotResponseSuccess extends BotResponseState {
  final BotResponse botResponse;

  BotResponseSuccess(this.botResponse);
}
