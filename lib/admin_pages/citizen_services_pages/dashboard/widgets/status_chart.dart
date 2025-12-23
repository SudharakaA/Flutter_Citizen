import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusChart extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> chartData;
  final double height;
  final bool showLegend;

  const StatusChart({
    super.key,
    required this.title,
    required this.chartData,
    required this.height,
    this.showLegend = true,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: screenWidth * 0.02),

          // Legend
          if (showLegend) _buildLegend(screenWidth),

          SizedBox(height: screenWidth * 0.03),

          // Chart Area
          SizedBox(
            height: height,
            child: chartData.isEmpty
                ? _buildEmptyState(screenWidth)
                : _buildChart(screenWidth, height),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Rejected', const Color(0xFFFFD700), screenWidth),
        SizedBox(width: screenWidth * 0.04),
        _buildLegendItem('Completed', const Color(0xFF4ECDC4), screenWidth),
        SizedBox(width: screenWidth * 0.04),
        _buildLegendItem('Pending', const Color(0xFFFFC0CB), screenWidth),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, double screenWidth) {
    return Row(
      children: [
        Container(
          width: screenWidth * 0.03,
          height: screenWidth * 0.03,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: screenWidth * 0.015),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: screenWidth * 0.03,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(double screenWidth) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: screenWidth * 0.15,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: screenWidth * 0.03),
          Text(
            'No data available',
            style: GoogleFonts.inter(
              fontSize: screenWidth * 0.035,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: screenWidth * 0.02),
          Text(
            'Select filters and click "View Data" to load chart',
            style: GoogleFonts.inter(
              fontSize: screenWidth * 0.03,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChart(double screenWidth, double chartHeight) {
    // Find max value for scaling
    int maxValue = 1;
    for (var data in chartData) {
      int total = (data['pending'] ?? 0) + 
                 (data['completed'] ?? 0) + 
                 (data['rejected'] ?? 0);
      if (total > maxValue) maxValue = total;
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: chartData.length,
      itemBuilder: (context, index) {
        final data = chartData[index];
        return _buildBar(
          data: data,
          maxValue: maxValue,
          chartHeight: chartHeight,
          screenWidth: screenWidth,
        );
      },
    );
  }

  Widget _buildBar({
    required Map<String, dynamic> data,
    required int maxValue,
    required double chartHeight,
    required double screenWidth,
  }) {
    final pending = data['pending'] ?? 0;
    final completed = data['completed'] ?? 0;
    final rejected = data['rejected'] ?? 0;
    final total = pending + completed + rejected;

    final barHeight = total > 0 ? (total / maxValue) * (chartHeight * 0.8) : 0.0;

    return Container(
      width: screenWidth * 0.15,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Bar
          if (total > 0)
            Container(
              height: barHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFFFFC0CB), // Pending - Pink
                    const Color(0xFF4ECDC4), // Completed - Cyan
                    const Color(0xFFFFD700), // Rejected - Yellow
                  ],
                  stops: [
                    pending / total,
                    (pending + completed) / total,
                    1.0,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ),

          SizedBox(height: screenWidth * 0.01),

          // Label
          Text(
            data['date']?.toString().substring(0, 10) ?? '',
            style: GoogleFonts.inter(
              fontSize: screenWidth * 0.025,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
