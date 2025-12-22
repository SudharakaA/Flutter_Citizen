import 'package:flutter/material.dart';
import '../../component/custom_back_button.dart';
import '../../component/custom_app_bar.dart';

class SmebDetailView extends StatelessWidget {
  final Map<String, dynamic> businessDetails;

  const SmebDetailView({
    super.key,
    required this.businessDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  children: [
                    Center(
                      child: Text(
                        'Business Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
                _buildDetailRow(
                  'Business name',
                  businessDetails['BUSINESS_NAME']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Registration Number',
                  businessDetails['REGISTRATION_NUMBER']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Contact Number',
                  businessDetails['CONTACT_NUMBER']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Account Year',
                  businessDetails['BUSINESS_YEAR']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Sales Income',
                  businessDetails['INCOME_A']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Other Income',
                  businessDetails['INCOME_B']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Annual Cost Of Raw Materials',
                  businessDetails['COST_C']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Cost Of Marketing',
                  businessDetails['COST_D']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Waiver and Rent Payments',
                  businessDetails['COST_E']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Value Of Equipment Purchased During The Year',
                  businessDetails['COST_S']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Bank Loan Premiums and Interest',
                  businessDetails['COST_F']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Administrative Expenses',
                  businessDetails['COST_G']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Depreciation Value Of Equipment',
                  businessDetails['COST_H']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Cash and Bank Balance As On 31st December',
                  businessDetails['ASSET_I']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Cash To Be Received',
                  businessDetails['ASSET_J']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Value Of Surplus Goods and Raw Materials',
                  businessDetails['ASSET_K']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Value Of Land Owned By The Institution',
                  businessDetails['ASSET_L']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Value of Buildings Owned by The Institution',
                  businessDetails['ASSET_M']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Value of Equipments Owned by The Institution',
                  businessDetails['ASSET_N']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Value of The Company\'s Reputation',
                  businessDetails['ASSET_O']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Value Of Enterprise Softwares',
                  businessDetails['ASSET_P']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Amount Of Loan Outstanding As On 31st December',
                  businessDetails['LIABILITY_Q']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Value Of Bills Payable',
                  businessDetails['LIABILITY_R']?.toString() ?? 'N/A',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Row(
            children: [
              const Icon(Icons.arrow_right_sharp),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 2,
              )
            ],
          ),
        ),
      ],
    );
  }
}
