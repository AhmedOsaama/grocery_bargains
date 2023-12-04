import 'package:bargainb/core/errors/failures.dart';
import 'package:bargainb/core/utils/api_service.dart';
import 'package:bargainb/features/chatlists/data/models/BookModel.dart';
import 'package:bargainb/features/chatlists/data/models/Items.dart';
import 'package:bargainb/features/chatlists/data/repos/home_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class HomeRepoImpl extends HomeRepo{
  final ApiService apiService;

  HomeRepoImpl(this.apiService);
  @override
  Future<Either<Failure, List<Items>>> fetchBooks() async {
    try {
      var data = await apiService.get(endpoint: 'volumes?q=subject: horror');
      BookModel bookModel = BookModel.fromJson(data);
      var books = bookModel.items;
      return Right(books!);
    }catch(e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Items>>> fetchFeaturedBooks() async {
    try {
      var data = await apiService.get(endpoint: 'volumes?filtering=free-ebooks&q=subject: horror');
      BookModel bookModel = BookModel.fromJson(data);
      var books = bookModel.items;
      return Right(books!);
    }catch(e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

}