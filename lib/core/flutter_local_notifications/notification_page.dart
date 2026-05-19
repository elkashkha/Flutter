import 'package:dio/dio.dart';
import 'package:elkashkha/core/flutter_local_notifications/data/specialist_notifications.dart';
import 'package:elkashkha/core/flutter_local_notifications/view_model/notifications_cubit.dart';
import 'package:elkashkha/core/flutter_local_notifications/view_model/notifications_state.dart';
import 'package:elkashkha/core/widgets/custom_button.dart';
import 'package:elkashkha/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'data/notifications_remote_data_source.dart';
import 'domain/notifications_repo.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => NotificationsCubit(
        NotificationsRepoImpl(
          NotificationsRemoteDataSource(Dio()),
        ),
      )..getNotifications(),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: isDark ? const Color(0xff151414) : const Color(0xFF1E1E1E),
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.notifications,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
            backgroundColor: isDark ? const Color(0xff151414) : const Color(0xFF1E1E1E),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final type = prefs.getString('user_type');
                if (type != null && type == "user") {
                  context.go('/NavBarView');
                } else {
                  context.go('/SpecialistNavBarView');
                }
              },
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff151414) : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsLoading) {
                    return const Center(child: CustomDotsTriangleLoader());
                  } else if (state is NotificationsLoaded) {
                    if (state.notifications.isEmpty) return _buildEmptyState(context);
                    return _buildUserNotifications(context, state);
                  } else if (state is SpecialistNotificationsLoaded) {
                    if (state.notifications.isEmpty) return _buildEmptyState(context);
                    return _buildSpecialistNotifications(context, state);
                  } else if (state is NotificationsError) {
                    return _buildErrorState(context, state.message);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- Empty & Error States ----------------

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/no_notification.svg',
            height: 150,
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18,
              color: isDark ? Colors.white70 : Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر الإشعارات هنا عند وصولها',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white38 : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: isDark ? Colors.white30 : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ',
            style: TextStyle(
              fontSize: 18,
              color: isDark ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<NotificationsCubit>().getNotifications();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? const Color(0xff262626) : Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  // ---------------- User Notifications ----------------

  Widget _buildUserNotifications(
      BuildContext context, NotificationsLoaded state) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final notification = state.notifications[index];
        final isRead = notification.isRead;

        return Dismissible(
          key: Key(notification.id.toString()),
          direction: DismissDirection.endToStart,
          background: _buildDeleteBackground(context),
          onDismissed: (_) {
            context
                .read<NotificationsCubit>()
                .deleteNotification(notification.id);
          },
          child: _buildNotificationTile(context, notification, isRead,
              isSpecialist: false),
        );
      },
    );
  }

  // ---------------- Specialist Notifications ----------------

  Widget _buildSpecialistNotifications(
      BuildContext context, SpecialistNotificationsLoaded state) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final notification = state.notifications[index];
        final isRead = notification.isRead;

        return _buildNotificationTile(context, notification, isRead,
            isSpecialist: true);
      },
    );
  }

  // ---------------- Notification Tile ----------------

  Widget _buildNotificationTile(
      BuildContext context, dynamic notification, bool isRead,
      {required bool isSpecialist}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isRead 
            ? (isDark ? const Color(0xFF222121) : Colors.grey[100]) 
            : (isDark ? const Color(0xFF2C2B2B) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: isRead ? Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey[300]!, width: 1) : null,
        boxShadow: isRead
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: isRead 
              ? (isDark ? const Color(0xFF2C2B2B) : Colors.grey[200]) 
              : (isDark ? const Color(0xFF222121) : Colors.grey[100]),
          backgroundImage: const AssetImage(
            'assets/images/dbd2d9a2-a476-4033-b51f-b25215eccb42.jpg',
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
            fontSize: 16,
            color: isRead 
                ? (isDark ? Colors.white54 : Colors.grey[600]) 
                : (isDark ? Colors.white : Colors.black87),
          ),
        ),
        subtitle: Text(
          notification.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color: isRead 
                ? (isDark ? Colors.white30 : Colors.grey[500]) 
                : (isDark ? Colors.white70 : Colors.grey[700]),
          ),
        ),
        onTap: () {
          if (isSpecialist) {
            _showNotificationDetails1(context, notification, isRead);
          } else {
            _showNotificationDetails(context, notification, isRead);
          }
        },
      ),
    );
  }

  // ---------------- Delete Background ----------------

  Widget _buildDeleteBackground(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.delete, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            AppLocalizations.of(context)!.delete,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Notification Details ----------------

  void _showNotificationDetails(
      BuildContext context, dynamic notification, bool isRead) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog.fullscreen(
        backgroundColor: isDark ? const Color(0xff151414) : Colors.white,
        child: Scaffold(
          backgroundColor: isDark ? const Color(0xff151414) : Colors.white,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xff151414) : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black, size: 28),
              onPressed: () {
                if (!isRead) {
                  context
                      .read<NotificationsCubit>()
                      .markNotificationAsRead(notification.id);
                }
                Navigator.of(dialogContext).pop();
              },
            ),
            title: Text(
              'تفاصيل الإشعار',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black),
                ),
                const SizedBox(height: 10),
                Text(
                  notification.body,
                  style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNotificationDetails1(BuildContext context,
      SpecialistNotificationModel notification, bool isRead) {
    final details = notification.details;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog.fullscreen(
        backgroundColor: isDark ? const Color(0xff151414) : Colors.grey[50],
        child: Scaffold(
          backgroundColor: isDark ? const Color(0xff151414) : Colors.grey[50],
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xff222121) : Colors.white,
            elevation: 2,
            shadowColor: isDark ? Colors.black45 : Colors.grey[300],
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2B2B) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.close_rounded,
                    color: isDark ? Colors.white : Colors.black, size: 20),
              ),
              onPressed: () {
                if (!isRead) {
                  context
                      .read<NotificationsCubit>()
                      .markNotificationAsRead(notification.id);
                }
                Navigator.of(dialogContext).pop();
              },
            ),
            title: Text(
              'تفاصيل الإشعار',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: details == null
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF222121) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 48,
                            color: isDark ? Colors.white38 : Colors.grey,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'لا توجد تفاصيل',
                            style: TextStyle(
                                fontSize: 16,
                                color: isDark ? Colors.white70 : Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoCard(
                            context: context,
                            icon: Icons.schedule_rounded,
                            child: Text(
                                'التاريخ: ${details.date} - الوقت: ${details.time}',
                                style: TextStyle(color: isDark ? Colors.white : Colors.black87))),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          context: context,
                          icon: Icons.person_rounded,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('العميل: ${details.clientName}', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                              Text('البريد الإلكتروني: ${details.clientEmail}', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                              Text('رقم الهاتف: ${details.clientPhone}', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                            ],
                          ),
                        ),
                        if (details.services.isNotEmpty)
                          _buildListCard(
                              context: context,
                              icon: Icons.home_repair_service_rounded,
                              title: 'الخدمات',
                              items: details.services,
                              color: isDark ? const Color(0xFF1B365D) : Colors.blue[50]!,
                              iconColor: isDark ? Colors.blue.shade300 : Colors.blue),
                        if (details.offers.isNotEmpty)
                          _buildListCard(
                              context: context,
                              icon: Icons.local_offer_rounded,
                              title: 'العروض',
                              items: details.offers,
                              color: isDark ? const Color(0xFF5D3E1B) : Colors.orange[50]!,
                              iconColor: isDark ? Colors.orange.shade300 : Colors.orange),
                        if (details.packages.isNotEmpty)
                          _buildListCard(
                              context: context,
                              icon: Icons.inventory_2_rounded,
                              title: 'الباقات',
                              items: details.packages,
                              color: isDark ? const Color(0xFF4A1B5D) : Colors.purple[50]!,
                              iconColor: isDark ? Colors.purple.shade300 : Colors.purple),
                        const SizedBox(height: 16),
                        MyCustomButton(
                          text: 'إغلاق',
                          backgroundColor: const Color(0xff262626),
                          voidCallback: () {
                            if (!isRead) {
                              context
                                  .read<NotificationsCubit>()
                                  .markNotificationAsRead(notification.id);
                            }
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222121) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2B2B) : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: isDark ? Colors.white70 : Colors.grey[600]),
          ),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildListCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<Map<String, String>> items,
    required Color color,
    required Color? iconColor,
  }) {
    final itemStrings = items.map((e) => e['ar'] ?? '').toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222121) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 12),
              Text(
                '$title:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...itemStrings.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: iconColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      e,
                      style: TextStyle(fontSize: 15, color: isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

