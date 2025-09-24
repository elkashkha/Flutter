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
import 'data/notifications_remote_data_source.dart';
import 'domain/notifications_repo.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit(
        NotificationsRepoImpl(
          NotificationsRemoteDataSource(Dio()),
        ),
      )..getNotifications(),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.notifications,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 1,
            shadowColor: Colors.grey[300],
            iconTheme: const IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
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
          body: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoading) {
                return const Center(child: CustomDotsTriangleLoader());
              } else if (state is NotificationsLoaded) {
                if (state.notifications.isEmpty) return _buildEmptyState();
                return _buildUserNotifications(context, state);
              } else if (state is SpecialistNotificationsLoaded) {
                if (state.notifications.isEmpty) return _buildEmptyState();
                return _buildSpecialistNotifications(context, state);
              } else if (state is NotificationsError) {
                return _buildErrorState(context, state.message);
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  // ---------------- Empty & Error States ----------------

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر الإشعارات هنا عند وصولها',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<NotificationsCubit>().getNotifications();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
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
    return Container(
      decoration: BoxDecoration(
        color: isRead ? Colors.grey[100] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isRead ? Border.all(color: Colors.grey[300]!, width: 1) : null,
        boxShadow: isRead
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
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
          backgroundColor: isRead ? Colors.grey[200] : Colors.grey[100],
          backgroundImage: const AssetImage(
            'assets/images/dbd2d9a2-a476-4033-b51f-b25215eccb42.jpg',
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
            fontSize: 16,
            color: isRead ? Colors.grey[600] : Colors.black87,
          ),
        ),
        subtitle: Text(
          notification.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color: isRead ? Colors.grey[500] : Colors.grey[700],
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
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog.fullscreen(
        backgroundColor: Colors.white,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.black, size: 28),
              onPressed: () {
                if (!isRead) {
                  context
                      .read<NotificationsCubit>()
                      .markNotificationAsRead(notification.id);
                }
                Navigator.of(dialogContext).pop();
              },
            ),
            title: const Text(
              'تفاصيل الإشعار',
              style: TextStyle(
                color: Colors.black,
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
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  notification.body,
                  style: const TextStyle(fontSize: 16),
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
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog.fullscreen(
        backgroundColor: Colors.grey[50],
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            shadowColor: Colors.grey[300],
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.close_rounded,
                    color: Colors.black, size: 20),
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
            title: const Text(
              'تفاصيل الإشعار',
              style: TextStyle(
                color: Colors.black,
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'لا توجد تفاصيل',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
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
                            icon: Icons.schedule_rounded,
                            child: Text(
                                'التاريخ: ${details.date} - الوقت: ${details.time}')),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.person_rounded,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('العميل: ${details.clientName}'),
                              Text('البريد الإلكتروني: ${details.clientEmail}'),
                              Text('رقم الهاتف: ${details.clientPhone}'),
                            ],
                          ),
                        ),
                        if (details.services.isNotEmpty)
                          _buildListCard(
                              icon: Icons.home_repair_service_rounded,
                              title: 'الخدمات',
                              items: details.services,
                              color: Colors.blue[50]!,
                              iconColor: Colors.blue),
                        if (details.offers.isNotEmpty)
                          _buildListCard(
                              icon: Icons.local_offer_rounded,
                              title: 'العروض',
                              items: details.offers,
                              color: Colors.orange[50]!,
                              iconColor: Colors.orange),
                        if (details.packages.isNotEmpty)
                          _buildListCard(
                              icon: Icons.inventory_2_rounded,
                              title: 'الباقات',
                              items: details.packages,
                              color: Colors.purple[50]!,
                              iconColor: Colors.purple),
                        const SizedBox(height: 16),
                        MyCustomButton(
                          text: 'إغلاق',
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
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
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
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.grey[600]),
          ),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildListCard({
    required IconData icon,
    required String title,
    required List<Map<String, String>> items,
    required Color color,
    required Color? iconColor,
  }) {
    final itemStrings = items.map((e) => e['ar'] ?? '').toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
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
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87),
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
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black87),
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
