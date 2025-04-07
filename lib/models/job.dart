class Job {
  final String id;
  final String description;

  Job({required this.id, required this.description});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      description: json['description'],
    );
  }
}

class JobApplicationRequest {
  final String job;

  JobApplicationRequest({required this.job});

  Map<String, dynamic> toJson() => {
    'job': job,
  };
}

class JobApplicationResponse {
  final String details;

  JobApplicationResponse({required this.details});

  factory JobApplicationResponse.fromJson(Map<String, dynamic> json) =>
      JobApplicationResponse(
        details: json['details'],
      );
}