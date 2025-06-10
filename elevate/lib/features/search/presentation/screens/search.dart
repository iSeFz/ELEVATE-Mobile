import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/size_config.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16 * SizeConfig.horizontalBlock),
          child: Column(
            children: [
              // Combined container for search and filters
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Search bar
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12 * SizeConfig.horizontalBlock,
                        vertical: 10 * SizeConfig.verticalBlock,
                      ),
                      child: TextField(
                        controller: _searchController,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          hintText: 'Pijama',
                          hintStyle: TextStyle(
                            fontSize: 14 * SizeConfig.textRatio,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, size: 20 * SizeConfig.verticalBlock),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12 * SizeConfig.verticalBlock,
                          ),
                        ),
                      ),
                    ),
                    Divider(height: 1, color: Colors.grey.shade200),
                    // Filters Row
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10 * SizeConfig.horizontalBlock,
                        vertical: 10 * SizeConfig.verticalBlock,
                      ),
                      child: Row(
                        children: [
                          _buildFilterButton('Category'),
                          SizedBox(width: 8 * SizeConfig.horizontalBlock),
                          _buildFilterButton('Brand', isHighlighted: true),
                          SizedBox(width: 8 * SizeConfig.horizontalBlock),
                          _buildFilterButton('Price'),
                          Spacer(),
                          Icon(Icons.image_outlined, size: 24 * SizeConfig.verticalBlock),
                          SizedBox(width: 10 * SizeConfig.horizontalBlock),
                          Icon(Icons.compare_arrows_outlined, size: 24 * SizeConfig.verticalBlock),
                          SizedBox(width: 10 * SizeConfig.horizontalBlock),
                          Stack(
                            children: [
                              Icon(Icons.filter_alt_outlined, size: 26 * SizeConfig.verticalBlock),
                              // Positioned(
                              //   top: 0,
                              //   right: 0,
                              //   child: CircleAvatar(
                              //     radius: 8,
                              //     backgroundColor: Colors.red,
                              //     child: Text(
                              //       '3',
                              //       style: TextStyle(fontSize: 10, color: Colors.white),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, {bool isHighlighted = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12 * SizeConfig.horizontalBlock,
        vertical: 8 * SizeConfig.verticalBlock,
      ),
      decoration: BoxDecoration(
        color: isHighlighted ? Color(0xFFA51930) : Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12 * SizeConfig.textRatio,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(Icons.arrow_drop_down, color: Colors.white, size: 20 * SizeConfig.verticalBlock),
        ],
      ),
    );
  }
}
