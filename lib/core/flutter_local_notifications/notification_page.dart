import 'package:dio/dio.dart';
import 'package:elkashkha/core/flutter_local_notifications/view_model/notifications_cubit.dart';
import 'package:elkashkha/core/flutter_local_notifications/view_model/notifications_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              );
            } else if (state is NotificationsLoaded) {
              if (state.notifications.isEmpty) {
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
                    background: Container(
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
                    ),
                    onDismissed: (_) {
                      context
                          .read<NotificationsCubit>()
                          .deleteNotification(notification.id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isRead ? Colors.grey[100] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: isRead
                            ? Border.all(color: Colors.grey[300]!, width: 1)
                            : null,
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
                      child: Stack(
                        children: [
                          if (!isRead)
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isRead
                                    ? Colors.grey[200]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: isRead
                                    ? Colors.grey[200]
                                    : Colors.grey[100],
                                backgroundImage: AssetImage(
                                  'assets/images/dbd2d9a2-a476-4033-b51f-b25215eccb42.jpg',
                                ),
                              ),
                            ),
                            title: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight:
                                isRead ? FontWeight.w500 : FontWeight.bold,
                                fontSize: 16,
                                color:
                                isRead ? Colors.grey[600] : Colors.black87,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  notification.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isRead
                                        ? Colors.grey[500]
                                        : Colors.grey[700],
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    if (isRead)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'مقروء',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    if (isRead) const SizedBox(width: 8),
                                    Text(
                                      notification.createdAt,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isRead
                                            ? Colors.grey[400]
                                            : Colors.grey[500],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
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
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.black,
                                          size: 28,
                                        ),
                                        onPressed: () {
                                          if (!isRead) {
                                            context
                                                .read<NotificationsCubit>()
                                                .markNotificationAsRead(
                                                notification.id);
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
                                          // صورة المستخدم والعنوان
                                          Row(
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(30),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.3),
                                                      spreadRadius: 2,
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: const AssetImage(
                                                    'assets/images/dbd2d9a2-a476-4033-b51f-b25215eccb42.jpg',
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      notification.title,
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      notification.createdAt,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 30),

                                          // الخط الفاصل
                                          Container(
                                            height: 1,
                                            width: double.infinity,
                                            color: Colors.grey[200],
                                          ),

                                          const SizedBox(height: 30),

                                          // محتوى الإشعار
                                          Text(
                                            'محتوى الإشعار',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[700],
                                            ),
                                          ),

                                          const SizedBox(height: 16),

                                          Container(
                                            width: double.infinity,
                                            constraints: BoxConstraints(
                                              minHeight: 100,
                                              maxHeight: MediaQuery.of(dialogContext).size.height * 0.6,
                                            ),
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[50],
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(
                                                color: Colors.grey[200]!,
                                                width: 1,
                                              ),
                                            ),
                                            child: SingleChildScrollView(
                                              child: SelectableText(
                                                notification.body,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black87,
                                                  height: 1.6,
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 30),

                                          // حالة القراءة
                                          if (!isRead)
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[50],
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.blue[200]!,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.info_outline,
                                                    color: Colors.blue[600],
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Text(
                                                    'إشعار جديد - لم يتم قراءته بعد',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.blue[700],
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          const SizedBox(height: 40),

                                          // زر الإغلاق
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (!isRead) {
                                                  context
                                                      .read<NotificationsCubit>()
                                                      .markNotificationAsRead(
                                                      notification.id);
                                                }
                                                Navigator.of(dialogContext).pop();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.black,
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                elevation: 2,
                                              ),
                                              child: Text(
                                                isRead ? 'إغلاق' : 'تم القراءة - إغلاق',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is NotificationsError) {
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
                      state.message,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
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

            return const SizedBox();
          },
        ),
      ),
    );
  }
}