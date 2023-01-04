// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class UpdateFullNameEvent {}

class IntializeUpdateFullNameEvent extends UpdateFullNameEvent {
  final String firstName;
  final String lastName;
  IntializeUpdateFullNameEvent({
    required this.firstName,
    required this.lastName,
  });
}

class UpdateFirstNameEvent extends UpdateFullNameEvent {
  final String value;
  UpdateFirstNameEvent({
    required this.value,
  });
}

class UpdateLastNameEvent extends UpdateFullNameEvent {
  final String value;
  UpdateLastNameEvent({
    required this.value,
  });
}

class SubmitNewFullNameEvent extends UpdateFullNameEvent {
  final String firstName;
  final String lastName;
  SubmitNewFullNameEvent({
    required this.firstName,
    required this.lastName,
  });
}
