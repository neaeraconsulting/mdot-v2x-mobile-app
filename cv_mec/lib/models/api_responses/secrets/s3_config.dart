class S3Config {
  final String s3AccessKey;
  final String s3SecretKey;
  final String s3BucketName;
  final String s3Region;
  final String s3Destination;

  S3Config({
    required this.s3AccessKey,
    required this.s3SecretKey,
    required this.s3BucketName,
    required this.s3Region,
    required this.s3Destination,
  });

  factory S3Config.fromJson(Map<String, dynamic> json) {
    return S3Config(
      s3AccessKey: json['s3_access_key'] ?? '',
      s3SecretKey: json['s3_secret_key'] ?? '',
      s3BucketName: json['s3_bucket_name'] ?? '',
      s3Region: json['s3_region'] ?? '',
      s3Destination: json['s3_destination']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      's3_access_key': s3AccessKey,
      's3_secret_key': s3SecretKey,
      's3_bucket_name': s3BucketName,
      's3_region': s3Region,
      's3_destination': s3Destination,
    };
  }
}