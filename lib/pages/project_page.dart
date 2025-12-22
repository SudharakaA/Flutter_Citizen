import 'project/add_project_form.dart';
import 'package:flutter/material.dart';
import 'package:citizen_care_system/model/project.dart';
import '../component/project/project_card.dart';
import '../component/request_service/action_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class ProjectPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;

  const ProjectPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final List<Project> _projects = [
    Project(
      id: '1',
      category: 'Public',
      type: 'Construction',
      location: 'City Center',
      description: 'Smart city infrastructure development',
      file: 'smart_city.jpg',
      userName: '',
      friendlyName: '',
      citizenName: '',
      gnDivisionId: '',
    ),
    Project(
      id: '2',
      category: 'Private',
      type: 'Purchasing',
      location: 'Research Park',
      description: 'AI research facility setup',
      file: 'ai_research.png',
      userName: '',
      friendlyName: '',
      citizenName: '',
      gnDivisionId: '',
    ),
    Project(
      id: '3',
      category: 'Public',
      type: 'Construction',
      location: 'Downtown',
      description: 'E-commerce platform office building',
      file: 'ecommerce.jpg',
      userName: '',
      friendlyName: '',
      citizenName: '',
      gnDivisionId: '',
    ),
  ];

  void addProject(Project project) {
    setState(() {
      _projects.add(project);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            top: screenHeight * 0.02,
            left: screenWidth * 0.03,
            right: screenWidth * 0.03,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'projects_in_area'.tr(),
                style: GoogleFonts.inter(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.black38,
                indent: screenWidth * 0.05,
                endIndent: screenWidth * 0.05,
              ),
              SizedBox(height: screenHeight * 0.02),
              ActionButton(
                text: 'add_new_idea'.tr(),
                //overflow: TextOverflow.ellipsis,
                icon: Icons.add,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddProjectForm(
                        onSubmit: addProject,
                        accessToken: widget.accessToken,
                        citizenCode: widget.citizenCode,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: _projects.isEmpty
                    ? Center(
                  child: Text(
                    'no_projects_available'.tr(),
                    style: GoogleFonts.inter(
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: _projects.length,
                  itemBuilder: (context, index) {
                    final project = _projects[index];
                    return ProjectCard(
                      project: project,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              project.category,
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${'type'.tr()}: ${project.type}",
                                    style: GoogleFonts.inter(
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                  Text(
                                    "${'location'.tr()}: ${project.location}",
                                    style: GoogleFonts.inter(
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                  Text(
                                    "${'description'.tr()}: ${project.description}",
                                    style: GoogleFonts.inter(
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                  if (project.file != null)
                                    Text(
                                      "${'attached_file'.tr()}: ${project.file}",
                                      style: GoogleFonts.inter(
                                        fontSize: screenWidth * 0.035,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(),
                                child: Text(
                                  'close'.tr(),
                                  style: GoogleFonts.inter(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
