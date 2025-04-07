
class TeamsResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<TeamMember> results;

  TeamsResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory TeamsResponse.fromJson(Map<String, dynamic> json) {
    return TeamsResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((member) => TeamMember.fromJson(member))
          .toList(),
    );
  }
}

class TeamMember {
  final String id;
  final String username;
  final String phoneNumber;
  final String activePackage;
  final int deposit;
  final String registered;
  final String status;

  TeamMember({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.activePackage,
    required this.deposit,
    required this.registered,
    required this.status,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'],
      username: json['username'],
      phoneNumber: json['phone_number'],
      activePackage: json['active_package'] ?? '',
      deposit: json['deposit'],
      registered: json['registered'],
      status: json['status'],
    );
  }
}