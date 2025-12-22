import 'package:flutter/material.dart';
import '../../component/custom_back_button.dart';

class PrintCharacterCertificatePage extends StatelessWidget {
  final String district;
  final String divisionalSecretariat;
  final String gramaDivision;
  final String known;
  final String nic;

  const PrintCharacterCertificatePage({
    super.key,
    required this.district,
    required this.divisionalSecretariat,
    required this.gramaDivision,
    required this.known,
    required this.nic,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> certificateDetails = {
      "01 ) District": district,
      "02 ) Divisional Secretariat": divisionalSecretariat,
      "03 ) Grama Niladari Division and Number": gramaDivision,
      "04 ) Is the applicant personally known?": known,
      "05 ) NIC": nic,
    };

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: const Text("Certificate of Residence and Character"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            const Divider(thickness: 1),
            const SizedBox(height: 10),

            // Loop through certificate data
            ...certificateDetails.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Text(
                '${entry.key} : ${entry.value}',
                style: const TextStyle(fontSize: 15),
              ),
            )),

            const SizedBox(height: 30),
            const Text(
              "-----------------------------\nAuthorized By",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
