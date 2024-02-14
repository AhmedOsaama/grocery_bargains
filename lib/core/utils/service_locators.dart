import 'package:get_it/get_it.dart';

import '../../features/profile/data/repos/profile_repo_impl.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<ProfileRepoImpl>(ProfileRepoImpl());
}