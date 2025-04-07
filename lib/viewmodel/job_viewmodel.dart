import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../service/job_service.dart';
import '../models/job.dart';
class JobViewModel extends ChangeNotifier {
  final JobService _jobService = JobService();
  List<Job> jobs = [];
  bool isLoading = false;
  String? applicationError;
  String? applicationSuccess;
  Set<String> applyingJobs = {}; // ⬅️ Track loading state per job
  JobViewModel() {
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      isLoading = true;
      notifyListeners();

      final fetchedJobs = await _jobService.fetchJobs();
      if (fetchedJobs != null) {
        jobs = fetchedJobs;
      }
    } catch (e) {
      print("Error fetching jobs: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyForJob(String jobId) async {
    applicationError = null;
    applicationSuccess = null;

    applyingJobs.add(jobId);
    notifyListeners();

    try {
      final request = JobApplicationRequest(job: jobId);
      final response = await _jobService.applyForJob(request);

      applicationSuccess = response?.details ?? "Application successful";
    } catch (e) {
      applicationError = e.toString(); // this will now show the actual "Insufficient balance" message
      if (kDebugMode) {
        print("Error: $applicationError");
      }
    } finally {
      applyingJobs.remove(jobId);
      notifyListeners();
    }
  }


  void clearMessages() {
    applicationError = null;
    applicationSuccess = null;
    notifyListeners();
  }

}
