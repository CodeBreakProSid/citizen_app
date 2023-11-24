class ResourceComponentDetails {
  late final int resourceId;
  late final int groupId;
  late final String resourceName;
  late final int resourceSize;
  late final String resourceType;

  ResourceComponentDetails({
    required this.resourceId,
    required this.groupId,
    required this.resourceName,
    required this.resourceSize,
    required this.resourceType,
  });

  ResourceComponentDetails.fromJson(Map<String, dynamic> json) {
    resourceId = json['resource_id'] as int;
    groupId = json['group_id'] as int;
    resourceName = json['resource_name'] as String;
    resourceSize = json['resource_size'] as int;
    resourceType = json['resource_type'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resource_id'] = resourceId;
    data['group_id'] = groupId;
    data['resource_name'] = resourceName;
    data['resource_size'] = resourceSize;
    data['resource_type'] = resourceType;

    return data;
  }
}
