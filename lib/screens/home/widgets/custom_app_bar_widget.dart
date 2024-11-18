import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBarWidget extends StatelessWidget {
  CustomAppBarWidget({super.key, required this.context});

  final BuildContext context;
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // IconButton(
        //   onPressed: () {},
        //   icon: const Icon(
        //     Icons.menu_rounded,
        //     size: 30,
        //   ),
        // ),
        const Spacer(),
        IconButton(
          onPressed: () {
            _buildUserModelSheet();
          },
          icon: const Icon(
            Icons.people_outline_rounded,
            size: 30,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        const Icon(
          Icons.notifications_none_rounded,
          size: 30,
        ),
        Container(
          height: 12,
          decoration:
              BoxDecoration(borderRadius: BorderRadiusDirectional.circular(20)),
        ),
      ],
    );
  }

  _buildUserModelSheet() {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return showModalBottomSheet(
      showDragHandle: true,
      elevation: 1.5,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Users',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Search Field
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Search Here',
                    prefixIcon: Icon(Icons.search_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // List of Users
                Expanded(
                  // Wrap ListView in Expanded to take remaining space
                  child: homeProvider.userNames.isEmpty
                      ? const Center(
                          child:
                              CircularProgressIndicator()) // Loading indicator
                      : ListView.builder(
                          itemCount: homeProvider.userNames.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      height: 40,
                                      width: 40,
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          homeProvider.userNames[index],
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const Text('Tasks: 10'),
                                      ],
                                    ),
                                  ],
                                ), // Display each user's name

                                const Divider(), // Divider between each ListTile
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
