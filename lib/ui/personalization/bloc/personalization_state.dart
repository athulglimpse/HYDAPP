part of 'personalization_bloc.dart';

@immutable
class PersonalizationState extends Equatable {
  final List<PersonalizationItem> personalizationItemList;
  final List<Items> listChild;
  final String groupSelectedId;
  final String groupChildSelectedId;
  final bool isChildScreen;
  final bool submitSuccess;

  PersonalizationState(
      {@required this.groupSelectedId,
      @required this.personalizationItemList,
      this.isChildScreen = false,
      this.groupChildSelectedId,
      @required this.listChild,
      this.submitSuccess});

  factory PersonalizationState.initial(
      PersonalizeRepository personalizationContentRepository) {
    return PersonalizationState(
      personalizationItemList:
          personalizationContentRepository.getLocalListPersonalizeItems(),
      submitSuccess: false,
      isChildScreen: false,
      groupSelectedId: '',
      groupChildSelectedId: '',
      listChild: const [],
    );
  }

  PersonalizationState copyWith({
    List<PersonalizationItem> personalizationItemList,
    List<Items> listChild,
    String groupSelectedId,
    String groupChildSelectedId,
    bool submitSuccess,
    bool isChildScreen,
  }) {
    return PersonalizationState(
        personalizationItemList:
            personalizationItemList ?? this.personalizationItemList,
        groupSelectedId: groupSelectedId ?? this.groupSelectedId,
        listChild: listChild ?? this.listChild,
        groupChildSelectedId: groupChildSelectedId ?? this.groupChildSelectedId,
        isChildScreen: isChildScreen ?? this.isChildScreen,
        submitSuccess: submitSuccess ?? this.submitSuccess);
  }

  @override
  List<Object> get props => [
        personalizationItemList,
        groupSelectedId,
        listChild,
        groupChildSelectedId,
        isChildScreen,
        submitSuccess
      ];

  @override
  String toString() {
    return '''PersonalizationState {
      personalizationItemList: $personalizationItemList,
      listChild: $listChild,
      groupChildSelectedId: $groupChildSelectedId,
      isChildScreen: $isChildScreen,
      submitSuccess: $submitSuccess,
    }''';
  }
}
