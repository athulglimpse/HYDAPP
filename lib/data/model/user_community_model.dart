import 'community_model.dart';
import 'experience_model.dart';

class UserCommunityModel extends CommunityPost {
  String _status;
  ExperienceModel _experience;
  String  _createdDate;

  UserCommunityModel.fromJson(Map<String, dynamic> json) {
    doParseFromJson(json);
    _status = json['status'];
    _createdDate = json['created'];
    _experience = json['experience'] != null ? ExperienceModel.fromJson(json['experience']) : null;
  }

  String get status => _status;
  set status(String status) => _status = status;
  String get createdDate => _createdDate;
  set createdDate(String createdDate) => _createdDate = createdDate;
  ExperienceModel get experience => _experience;
  set experience(ExperienceModel experience) => _experience = experience;

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['status'] = _status;
    data['created'] = _createdDate;
    if (_experience != null) {
      data['experience'] = _experience.toJson();
    }
    return data;
  }
}
