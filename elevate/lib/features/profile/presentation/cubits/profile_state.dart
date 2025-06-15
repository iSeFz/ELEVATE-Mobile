// --- Profile Related States ---
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {}

class ProfileUpdated extends ProfileState {}

class ProfilePictureUpdated extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}

// --- Address Related States ---
class AddressLoading extends ProfileState {}

class AddressSaved extends ProfileState {}

class AddressExpanded extends ProfileState {}

class DefaultAddressUpdated extends ProfileState {}

class AddressDeleted extends ProfileState {}
