import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePageSkeleton extends StatelessWidget {
  const HomePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Skeletonizer(
          enabled: true,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title: Breaking News
                  const Text(
                    "Breaking News",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Fake PageView for Breaking News
                  _carousselSkeleton(),
                  const SizedBox(height: 24),

                  // Title: Top Stories
                  const Text(
                    "Top Stories",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),

                  // Row of story-like cards
                  SizedBox(
                    height: 130,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, __) => ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 110,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(height: 70, color: Colors.grey[300]),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Story title",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // === Suggestion Banner Skeleton (added) ===
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      // use neutral background so Skeletonizer will shimmer it
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title placeholder
                          Container(
                            height: 18,
                            width: width * 0.45,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Description line 1
                          Container(
                            height: 12,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Description line 2 (shorter)
                          Container(
                            height: 12,
                            width: width * 0.7,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Extra spacing to match real layout
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _carousselSkeleton() {
  return SizedBox(
      height: 280,
      child:Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    clipBehavior: Clip.antiAlias,
    elevation: 4,
    child: Stack(
      children: [
        // Placeholder image area
        Positioned.fill(child: Container(color: Colors.grey[300])),
        // Gradient overlay (keep for visual consistency)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: .1),
                  Colors.black.withValues(alpha: .7),
                ],
              ),
            ),
          ),
        ),
        // Text placeholders
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title placeholder
              Container(
                height: 20,
                width: double.infinity,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Source placeholder
                  Container(height: 16, width: 80, color: Colors.white),
                  const Spacer(),
                  // Bookmark icon placeholder
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}
