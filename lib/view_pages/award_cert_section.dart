import 'package:avantswift_portfolio/models/AwardCert.dart';
import 'package:avantswift_portfolio/reposervice/award_cert_repo_services.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AwardCertSection extends StatefulWidget {
  const AwardCertSection({Key? key}) : super(key: key);

  @override
  AwardCertSectionState createState() => AwardCertSectionState();
}

class AwardCertSectionState extends State<AwardCertSection> {
  final AwardCertRepoService _awardCertRepoService = AwardCertRepoService();
  List<AwardCert>? awardCerts;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final List<AwardCert>? fetchedAwardCerts =
          await _awardCertRepoService.getAllAwardCert();
      setState(() {
        awardCerts = fetchedAwardCerts;
      });
    } catch (e) {
      print('Error fetching awards and certificates: $e');
      // Handle the error, e.g., show an error message to the user.
    }
  }

  void openLink(String link) async {
    if (await canLaunchUrlString(link)) {
      await launchUrlString(link);
    } else {
      print('Could not launch $link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Section (Awards and Certificates)
        Expanded(
          flex: 1, // Adjust flex as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 80.0),
                child: Text(
                  'Awards & Certifications',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (awardCerts != null)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: GridView.builder(
                    padding: EdgeInsets.all(20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Adjust the number of columns as needed
                      // childAspectRatio: 1.0, // Adjust aspect ratio for circular shape
                      // crossAxisSpacing: 5.0, // Adjust horizontal spacing
                      // mainAxisSpacing: 10.0, // Adjust vertical spacing
                      
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: awardCerts!.length,
                    itemBuilder: (context, index) {
                      return _buildAwardCertCircle(awardCerts![index]);
                    },
                  ),
                ),
              if (awardCerts == null)
                Text(
                  'Error loading awards and certificates.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
        // Right Section (Peer Recommendations or other content)
        Expanded(
          flex: 1, // Adjust flex as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Place your content for the right section here
              // For example, peer recommendations or other content widgets
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAwardCertCircle(AwardCert awardCert) {
    return Column(
      children: [
        InkWell(
          onTap: () => openLink(awardCert.link ?? ''),
          child: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 174, 224, 176),
            radius: 80.0,
            backgroundImage: NetworkImage(awardCert.imageURL ?? ''),
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          awardCert.name ?? 'Certificate Name',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        // SizedBox(height: 10.0),
      ],
    );
  }
}
