import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

/// Loading shimmer effect for notes list
class NotesLoadingShimmer extends StatelessWidget {
  /// Creates a [NotesLoadingShimmer]
  const NotesLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive design for different screen sizes
    late int crossAxisCount;
    late double childAspectRatio;
    late double horizontalPadding;
    late double verticalPadding;
    
    if (screenWidth >= 1200) {
      // Desktop
      crossAxisCount = 4;
      childAspectRatio = 1.3;
      horizontalPadding = 3.w;
      verticalPadding = 2.h;
    } else if (screenWidth >= 768) {
      // Tablet
      crossAxisCount = 3;
      childAspectRatio = 1.1;
      horizontalPadding = 2.5.w;
      verticalPadding = 1.5.h;
    } else {
      // Mobile
      crossAxisCount = 2;
      childAspectRatio = 0.95;
      horizontalPadding = 2.w;
      verticalPadding = 1.h;
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: horizontalPadding,
          mainAxisSpacing: verticalPadding,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: 6, // Show 6 skeleton items
        itemBuilder: (context, index) {
          return const _ShimmerNoteCard();
        },
      ),
    );
  }
}

class _ShimmerNoteCard extends StatefulWidget {
  const _ShimmerNoteCard();

  @override
  _ShimmerNoteCardState createState() => _ShimmerNoteCardState();
}

class _ShimmerNoteCardState extends State<_ShimmerNoteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.all(2.5.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with category and pin
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildShimmerBox(
                          width: double.infinity,
                          height: 2.h,
                          opacity: _animation.value,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      _buildShimmerBox(
                        width: 5.w,
                        height: 5.w,
                        borderRadius: 2.5.w,
                        opacity: _animation.value,
                      ),
                    ],
                  ),
                  SizedBox(height: 0.8.h),
                  
                  // Title lines (2 lines max)
                  _buildShimmerBox(
                    width: double.infinity,
                    height: 1.8.h,
                    opacity: _animation.value,
                  ),
                  SizedBox(height: 0.4.h),
                  _buildShimmerBox(
                    width: 70.w,
                    height: 1.8.h,
                    opacity: _animation.value,
                  ),
                  SizedBox(height: 0.8.h),
                  
                  // Content lines (2 lines max for mobile, 3 for larger screens)
                  _buildShimmerBox(
                    width: double.infinity,
                    height: 1.3.h,
                    opacity: _animation.value * 0.7,
                  ),
                  SizedBox(height: 0.3.h),
                  _buildShimmerBox(
                    width: double.infinity,
                    height: 1.3.h,
                    opacity: _animation.value * 0.7,
                  ),
                  SizedBox(height: 0.8.h),
                  
                  // Footer with time
                  _buildShimmerBox(
                    width: 50.w,
                    height: 1.2.h,
                    opacity: _animation.value * 0.5,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    double? borderRadius,
    required double opacity,
  }) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      constraints: width == double.infinity 
          ? const BoxConstraints(minWidth: 0, maxWidth: double.infinity)
          : null,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .onSurface
            .withValues(alpha: 0.1 + (opacity * 0.1)),
        borderRadius: BorderRadius.circular(borderRadius ?? 1.w),
      ),
    );
  }
}
