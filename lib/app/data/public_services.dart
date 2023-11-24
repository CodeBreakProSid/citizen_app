class PublicServices {
  late final int serviceId;
  late final String serviceName;
  late final String defaultPhone;

  PublicServices({
    required this.serviceId,
    required this.serviceName,
    required this.defaultPhone,
  });

  PublicServices.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'] as int;
    serviceName = json['service_name'] as String;
    defaultPhone = json['default_phone'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    data['default_phone'] = defaultPhone;

    return data;
  }
}
