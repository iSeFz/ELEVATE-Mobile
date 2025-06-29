import '../../../data/models/brand_model.dart';

abstract class FilterState {}

class FilterInitial extends FilterState {}
class FilterLoading extends FilterState {}

class FilterLoaded extends FilterState {// Categories

  FilterLoaded();
}

class FilterError extends FilterState {
  final String message;
  FilterError(this.message);
}

