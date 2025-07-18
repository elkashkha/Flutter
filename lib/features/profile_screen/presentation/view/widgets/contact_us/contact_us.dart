// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../../../../core/app_theme.dart';
// import '../../../../../../core/widgets/custom_app_bar.dart';
// import '../../../../../../core/widgets/emali_fild.dart';
//
// class ContactUs extends StatefulWidget {
//   const ContactUs({super.key});
//
//   @override
//   _ContactUsState createState() => _ContactUsState();
// }
//
// class _ContactUsState extends State<ContactUs> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController messageController = TextEditingController();
//
//   void _openMap(BuildContext context) async {
//     final Uri googleMapUrl = Uri.parse(
//         "https://www.google.com/maps/place/29%C2%B020'31.8%22N+48%C2%B005'40.5%22E/@29.3421667,48.0945833,17z");
//     if (await canLaunchUrl(googleMapUrl)) {
//       await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تعذر فتح الخريطة')),
//       );
//     }
//   }
//
//   void _sendMessageOnWhatsapp(BuildContext context) async {
//     final Uri whatsappUrl =
//         Uri.parse("https://wa.me/96555156388?text=مرحبًا، أرغب في الاستفسار");
//         // Uri.parse("https://wa.me/+96555156388?text=مرحبًا، أرغب في الاستفسار");
//     // if (await canLaunchUrl(whatsappUrl)) {
//     //   await launchUrl(whatsappUrl);
//     // } else {
//     //   print("تعذر فتح واتساب");
//     // }
//     if (await canLaunchUrl(whatsappUrl)) {
//       await launchUrl(whatsappUrl);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("يبدو أن WhatsApp غير مثبت على الجهاز."),
//         ),
//       );
//     }
//   }
//
//   void _openInstagram() async {
//     final Uri instagramUrl = Uri.parse(
//         "https://www.instagram.com/alkashkhakw?igsh=MWs3ZGsxbnAwcW5kZw==");
//     if (await canLaunchUrl(instagramUrl)) {
//       await launchUrl(instagramUrl);
//     } else {
//       print("تعذر فتح إنستجرام");
//     }
//   }
//
//   void _opensciac() async {
//     final Uri instagramUrl = Uri.parse("https://reach.link/alkashkha24");
//     if (await canLaunchUrl(instagramUrl)) {
//       await launchUrl(instagramUrl);
//     } else {
//       print("تعذر فتح إنستجرام");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.75:MediaQuery.of(context).size.width;
//     final screenHeight = mediaQuery.size.height;
//
//     return Scaffold(
//       backgroundColor: const Color(0xffFCFCFC),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: AppTheme.white,
//         title: const CustomAppBar(
//           title: 'اتصل بنا',
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//             horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
//         child: ListView(
//           children: [
//             Text(
//               'هل لديك استفسار أو ترغب في حجز موعد؟ نحن هنا لمساعدتك، تواصل معنا الآن!',
//               style: TextStyle(
//                 fontSize: screenWidth * 0.04,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 const ContactInfoRow(icon: Icons.phone, text: '+96555156388'),
//                 const Spacer(),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.10),
//                   child: GestureDetector(
//                     onTap: _opensciac,
//                     child: const ContactInfoRow(
//                       icon: Icons.link,
//                       text: 'السوشيال ميديا ',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.20),
//               child: GestureDetector(
//                 onTap: _openInstagram,
//                 child: const ContactInfoRow(
//                   icon: Icons.link,
//                   text: 'رابط إنستجرام',
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => _openMap(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xffD1D1D1),
//                   padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   'افتح الموقع على الخريطة',
//                   style: TextStyle(
//                       fontSize: screenWidth * 0.04,
//                       color: const Color(0xff343333)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: GestureDetector(
//                 onTap: () => _openMap(context),
//                 child: Image.asset(
//                   'assets/images/Rectangle.png',
//                   width: screenWidth * 0.85,
//                   height: screenHeight * 0.15,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'أوقات العمل :',
//               style: TextStyle(
//                 fontSize: screenWidth * 0.04,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             Text(
//               'أيام الأسبوع (من 11 صباحًا حتى 12 منتصف الليل)',
//               style: TextStyle(
//                 fontSize: screenWidth * 0.04,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             Text(
//               'الخميس - الجمعة - السبت (من 11 صباحًا حتى 12:30 بعد منتصف الليل)',
//               style: TextStyle(
//                 fontSize: screenWidth * 0.04,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 20),
//             const SizedBox(height: 10),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: 4,
//               itemBuilder: (context, index) {
//                 switch (index) {
//                   case 0:
//                     return EmailField(
//                       taskController: nameController,
//                       icon: Icons.person,
//                       validate: (value) => value!.trim().isEmpty
//                           ? 'الرجاء إدخال الاسم الكامل'
//                           : null,
//                       hint: 'الاسم الكامل',
//                     );
//                   case 1:
//                     return EmailField(
//                       taskController: phoneController,
//                       icon: Icons.phone,
//                       validate: (value) => value!.trim().isEmpty
//                           ? 'الرجاء إدخال رقم الهاتف'
//                           : null,
//                       hint: 'رقم الهاتف',
//                     );
//                   case 2:
//                     return EmailField(
//                       taskController: emailController,
//                       icon: Icons.email,
//                       validate: (value) => value!.trim().isEmpty
//                           ? 'الرجاء إدخال البريد الإلكتروني'
//                           : null,
//                       hint: 'البريد الإلكتروني',
//                     );
//                   case 3:
//                     return EmailField(
//                       taskController: messageController,
//                       icon: Icons.message,
//                       validate: (value) =>
//                           value!.trim().isEmpty ? 'الرجاء إدخال الرسالة' : null,
//                       hint: 'الرسالة',
//                       maxLines: 4,
//                     );
//                   default:
//                     return Container();
//                 }
//               },
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: (){
//                   _sendMessageOnWhatsapp(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppTheme.primary,
//                   padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   'إرسال عبر واتساب',
//                   style: TextStyle(
//                       fontSize: screenWidth * 0.04, color: AppTheme.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ContactInfoRow extends StatelessWidget {
//   final IconData icon;
//   final String text;
//
//   const ContactInfoRow({super.key, required this.icon, required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.75:MediaQuery.of(context).size.width;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Container(
//         color: const Color(0xffFAFAFA),
//         child: Row(
//           children: [
//             Icon(icon, color: AppTheme.primary),
//             SizedBox(width: screenWidth * 0.02),
//             Text(
//               text,
//               style: TextStyle(
//                 fontSize: screenWidth * 0.04,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/app_theme.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../core/widgets/emali_fild.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  void _openMap(BuildContext context) async {
    final Uri googleMapUrl = Uri.parse(
        "https://www.google.com/maps/place/29%C2%B020'31.8%22N+48%C2%B005'40.5%22E/@29.3421667,48.0945833,17z");
    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح الخريطة')),
      );
    }
  }

  void _sendMessageOnWhatsapp(BuildContext context) async {
    final Uri whatsappUrl = Uri.parse(
        "https://wa.me/96555156388?text=مرحبًا، أرغب في الاستفسار");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("يبدو أن WhatsApp غير مثبت على الجهاز."),
        ),
      );
    }
  }

  void _submitFormLocally(BuildContext context) {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول أولًا')),
      );
      return;
    }

    // في المستقبل، يمكنك إرسال البيانات هنا عبر API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال رسالتك بنجاح!')),
    );

    // إفراغ الحقول
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width > 600
        ? mediaQuery.size.width * .75
        : mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: const Color(0xffFCFCFC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.white,
        title: const CustomAppBar(
          title: 'اتصل بنا',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: ListView(
          children: [
            Text(
              'هل لديك استفسار أو ترغب في حجز موعد؟ نحن هنا لمساعدتك!',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),

            // معلومات الاتصال
            const ContactInfoRow(icon: Icons.phone, text: '‪+96555156388‬'),
            const ContactInfoRow(icon: Icons.link, text: 'reach.link/alkashkha24'),
            const ContactInfoRow(icon: Icons.link, text: 'instagram.com/alkashkhakw'),

            const SizedBox(height: 20),

            // زر الخريطة
            ElevatedButton(
              onPressed: () => _openMap(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffD1D1D1),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'افتح الموقع على الخريطة',
                style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: const Color(0xff343333)),
              ),
            ),

            const SizedBox(height: 20),

            // صورة الموقع
            Center(
              child: Image.asset(
                'assets/images/Rectangle.png',
                width: screenWidth * 0.85,
                height: screenHeight * 0.15,
              ),
            ),

            const SizedBox(height: 20),

            // أوقات العمل
            Text(
              'أوقات العمل :',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text('من الأحد إلى الأربعاء ( من الساعة 10 صباحاً حتي الساعه 10:30 مساءً)'),
            const Text(' من  الخميس الي السبت (10من الساعة صباحاً حتي الساعه 11:30 مساءً)'),
            const SizedBox(height: 10),
            Text(
              'ساعات العمل رمضان :',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text('من 1 ظهراً حتي الساعة 4 عصراً'),
            const Text('ومن 8 مساءً حتي الساعة 2 فجراً'),
            const SizedBox(height: 20),


            // نموذج التواصل
            EmailField(
              taskController: nameController,
              icon: Icons.person,
              validate: (value) => value!.trim().isEmpty
                  ? 'الرجاء إدخال الاسم الكامل'
                  : null,
              hint: 'الاسم الكامل',
            ),
            EmailField(
              taskController: phoneController,
              icon: Icons.phone,
              validate: (value) =>
              value!.trim().isEmpty ? 'الرجاء إدخال رقم الهاتف' : null,
              hint: 'رقم الهاتف',
            ),
            EmailField(
              taskController: emailController,
              icon: Icons.email,
              validate: (value) =>
              value!.trim().isEmpty ? 'الرجاء إدخال البريد الإلكتروني' : null,
              hint: 'البريد الإلكتروني',
            ),
            EmailField(
              taskController: messageController,
              icon: Icons.message,
              validate: (value) =>
              value!.trim().isEmpty ? 'الرجاء إدخال الرسالة' : null,
              hint: 'الرسالة',
              maxLines: 4,
            ),

            const SizedBox(height: 20),

            // زر الإرسال الداخلي
            ElevatedButton(
              onPressed: () => _submitFormLocally(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'إرسال من داخل التطبيق',
                style: TextStyle(
                    fontSize: screenWidth * 0.04, color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),

            // زر واتساب (اختياري)
            // ElevatedButton(
            //   onPressed: () => _sendMessageOnWhatsapp(context),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: AppTheme.primary,
            //     padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            //   child: Text(
            //     'إرسال عبر واتساب (اختياري)',
            //     style: TextStyle(
            //         fontSize: screenWidth * 0.04, color: AppTheme.white),
            //   ),
            // ),

            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width > 600
        ? MediaQuery.of(context).size.width * .75
        : MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary),
          SizedBox(width: screenWidth * 0.02),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}