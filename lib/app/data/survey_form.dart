class SurveyForm {
  late final int formId;
  late final String formName;
  late final String? description;
  late final String? createdOn;
  late final int createdBy;

  SurveyForm({
    required this.formId,
    required this.formName,
    this.description,
    this.createdOn,
    required this.createdBy,
  });

  SurveyForm.fromJson(Map<String, dynamic> json) {
    formId = json['form_id'] as int;
    formName = json['form_name'] as String;
    description = json['description'] as String?;
    createdOn = json['created_on'] as String?;
    createdBy = json['created_by'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['form_id'] = formId;
    data['form_name'] = formName;
    data['description'] = description;
    data['created_on'] = createdOn;
    data['created_by'] = createdBy;

    return data;
  }
}
