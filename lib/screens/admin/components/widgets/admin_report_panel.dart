// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:foodryp/models/comment.dart';
import 'package:foodryp/models/report.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/comment_service.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/report_service.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class AdminReportPage extends StatefulWidget {
  final String? userRole;

  const AdminReportPage({super.key, this.userRole});

  @override
  _AdminReportPageState createState() => _AdminReportPageState();
}

class _AdminReportPageState extends State<AdminReportPage> {
  late List<Report> reports = [];

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    // Call your API to fetch reports here
    // For example:
    List<Report> fetchedReports = await ReportService.fetchAllReports();
    setState(() {
      reports = fetchedReports;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('Admin Reports'),
        ),
      ),
      body: reports.isNotEmpty
          ? ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return Card(
                  elevation: 4, // Add elevation for a slight shadow effect
                  margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16), // Add margin around the card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Add rounded corners to the card
                  ),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          report.reason,
                          style: TextStyle(
                            fontSize: 16, // Adjust font size as needed
                            fontWeight: FontWeight.bold, // Make text bold
                            color: themeProvider.currentTheme == ThemeType.dark
                                ? Colors.white
                                : Colors.black, // Set text color
                          ),
                        ),
                        IconButton(
                          icon: Icon(MdiIcons.delete),
                          onPressed: () async {
                            try {
                              // Call the deleteReport function from the ReportService
                              bool deleted =
                                  await ReportService.deleteReport(report.id);
                              if (deleted) {
                                setState(() {
                                  fetchReports();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Report deleted successfully'),
                                    duration: Duration(
                                        seconds:
                                            2), // Optional: Adjust duration
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to delete report'),
                                    duration: Duration(
                                        seconds:
                                            2), // Optional: Adjust duration
                                  ),
                                );
                              }
                            } catch (e) {
                              // Handle any errors
                              print('Error deleting report: $e');
                              // Optionally, you can show an error message to the user
                            }
                          },
                        ),
                      ],
                    ),
                    // Add more ListTile properties as needed
                    tileColor: themeProvider.currentTheme == ThemeType.dark
                        ? const Color.fromARGB(255, 70, 70, 70)
                        : Colors.white, // Set background color
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12), // Add padding
                    leading: const Icon(Icons.report_problem,
                        color: Colors.red), // Add a leading icon
                    onTap: () async {
                      try {
                        // Fetch the reported comment using the CommentService
                        Comment reportedComment = await CommentService()
                            .getReportedComment(report.commentId);

                        // Show the bottom sheet with the reported comment
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                final isDesktop =
                                    MediaQuery.of(context).size.width > 700;

                                return Container(
                                  width: isDesktop ? 700 : double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('Reported Comment:'),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SelectableText(
                                        '${AppLocalizations.of(context).translate('CommentId:')} ${reportedComment.id}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),

                                      const SizedBox(height: 8),
                                      SelectableText(
                                        '${AppLocalizations.of(context).translate('Text:')} ${reportedComment.text}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SelectableText(
                                        '${AppLocalizations.of(context).translate('User:')} ${reportedComment.username}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SelectableText(
                                        '${AppLocalizations.of(context).translate('Date:')} ${reportedComment.dateCreated}', // Assuming dateCreated is a DateTime object
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      // Add more details as needed
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the bottom sheet
                                        },
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      } catch (e) {
                        // Handle any errors
                        print('Error fetching reported comment: $e');
                      }
                    },
                  ),
                );
              },
            )
          : Center(
              child: Text(AppLocalizations.of(context).translate(
                  'No reports at this time')), // Show loading indicator while fetching reports
            ),
    );
  }
}
