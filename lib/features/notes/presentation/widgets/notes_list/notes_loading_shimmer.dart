import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

/// Loading shimmer effect for notes list
class NotesLoadingShimmer extends StatelessWidget {
  const NotesLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final crossAxisCount = isTablet ? 3 : 2;
    
    return Padding(
      padding: EdgeInsets.all(2.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 2.w,
          mainAxisSpacing: 2.w,
          childAspectRatio: isTablet ? 1.2 : 0.8,
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
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with category and pin
                Row(
                  children: [
                    Expanded(
                      child: _buildShimmerBox(
                        width: double.infinity,
                        height: 2.5.h,
                        opacity: _animation.value,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    _buildShimmerBox(
                      width: 6.w,
                      height: 6.w,
                      borderRadius: 3.w,
                      opacity: _animation.value,
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                
                // Title
                _buildShimmerBox(
                  width: double.infinity,
                  height: 2.h,
                  opacity: _animation.value,
                ),
                SizedBox(height: 0.5.h),
                _buildShimmerBox(
                  width: double.infinity,
                  height: 2.h,
                  opacity: _animation.value,
                ),
                SizedBox(height: 1.h),
                
                // Content lines
                _buildShimmerBox(
                  width: double.infinity,
                  height: 1.5.h,
                  opacity: _animation.value * 0.7,
                ),
                SizedBox(height: 0.3.h),
                _buildShimmerBox(
                  width: double.infinity,
                  height: 1.5.h,
                  opacity: _animation.value * 0.7,
                ),
                SizedBox(height: 0.3.h),
                _buildShimmerBox(
                  width: double.infinity,
                  height: 1.5.h,
                  opacity: _animation.value * 0.7,
                ),
                
                const Spacer(),
                
                // Footer with time
                _buildShimmerBox(
                  width: double.infinity,
                  height: 1.5.h,
                  opacity: _animation.value * 0.5,
                ),
              ],
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
