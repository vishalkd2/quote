import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutDeveloper extends StatefulWidget {
  const AboutDeveloper({super.key});

  @override
  State<AboutDeveloper> createState() => _AboutDeveloperState();
}

class _AboutDeveloperState extends State<AboutDeveloper> {
  Map<String, dynamic>? devData;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final String jsonString =
    await rootBundle.loadString('assets/developer/about.json');
    setState(() {
      devData = json.decode(jsonString);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (devData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final data = devData!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.25),
        backgroundColor: Colors.transparent,
        title: const Text(
          "About Developer",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF5F2C82), // Deep Purple
                Color(0xFF49A09D), // Teal
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFEEF1F5),
                Color(0xFFDDE3EC),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ================= PROFILE IMAGE =================
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 30,
                        offset: const Offset(0, 18),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/developer/profile.jpeg',
                      height: MediaQuery.of(context).size.height * .4,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ================= NAME =================
                Text(
                  data['name'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5F2C82),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  data['role'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  data['experience'],
                  style: const TextStyle(
                    color: Color(0xFF49A09D),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 24),

                // ================= CONTENT =================
                _buildCardSection("Bio", data['bio']),
                _buildCardSection(
                  "Skills",
                  (data['skills'] as List).join(" • "),
                  isChip: true,
                ),
                _buildCardSection("About App", data['about_app']),

                _buildInfoTile(Icons.email_outlined, "Email", data['email']),
                _buildInfoTile(Icons.link, "LinkedIn", data['linkedin']),
                _buildInfoTile(Icons.code, "GitHub", data['github']),
                _buildInfoTile(
                    Icons.location_on, "Location", data['location']),

                _buildCardSection(
                  "Interests",
                  (data['interests'] as List).join(" • "),
                  isChip: true,
                ),

                const SizedBox(height: 25),

                Text(
                  "App Version: ${data['app_version']}",
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= CARD SECTION =================
  Widget _buildCardSection(String title, String content,
      {bool isChip = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5F2C82),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          isChip
              ? Wrap(
            spacing: 8,
            runSpacing: 6,
            children: content
                .split("•")
                .map(
                  (e) => Chip(
                label: Text(e.trim()),
                backgroundColor:
                const Color(0xFF5F2C82).withOpacity(0.12),
                labelStyle: const TextStyle(
                  color: Color(0xFF5F2C82),
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
                .toList(),
          )
              : Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ================= INFO TILE =================
  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF49A09D)),
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
        onTap: () {},
      ),
    );
  }
}
