import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/Items.dart';

part 'newest_books_state.dart';

class NewestBooksCubit extends Cubit<NewestBooksState> {
  NewestBooksCubit() : super(NewestBooksInitial());
}
