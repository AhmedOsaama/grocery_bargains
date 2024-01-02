import 'package:bargainb/features/onboarding/presentation/views/terms_of_service_screen.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/screens/support_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../config/routes/app_navigator.dart';

class PolicyScreen extends StatefulWidget {
  PolicyScreen({Key? key}) : super(key: key);

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  final TextStyle headerFont = TextStylesInter.textViewBold28;

  final TextStyle subHeaderFont = TextStylesInter.textViewBold20;

  final TextStyle bodyFont = TextStylesInter.textViewLight15;
  bool showFAB = false;
  ScrollController scrollController = ScrollController();


  @override
  void initState() {
    addScrollListener();
    super.initState();
  }

  void addScrollListener() {
    return scrollController.addListener(() {
      double showOffset = 200.0;
      if (scrollController.offset > showOffset) {
        if (!showFAB)
          setState(() {
            showFAB = true;
          });
      } else {
        if (showFAB)
          setState(() {
            showFAB = false;
          });
      }
    });
  }

  Opacity buildFAB() {
    return Opacity(
      opacity: showFAB ? 0.6 : 0.0, //set obacity to 1 on visible, or hide
      child: GestureDetector(
        onTap: (){
          scrollController.animateTo(
            //go to top of scroll
              0, //scroll offset to go
              duration: Duration(milliseconds: 500), //duration of scroll
              curve: Curves.fastOutSlowIn //scroll type
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(255, 154, 65, 1), width: 3),
            shape: BoxShape.circle
          ),
          child: Icon(Icons.arrow_upward, color: brightOrange,),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: MyAppBar(
        title: "Privacy Policy".tr(),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Effective date: 03/01/2023",
                style: TextStylesInter.textViewRegular20.copyWith(color: Color(0xFF7C7C7C)),
              ),
              50.ph,
              Text(
                "1. Introduction",
                style: headerFont,
              ),
              35.ph,
              Text("""Welcome to BargainB.
At BargainB ("we", "our", or "us"), we are committed to upholding the trust and confidence of our users. Our website, theBargainb.com, and the Bargainb mobile application (collectively, the "Service") are designed with your privacy in mind.
This Privacy Policy outlines how we handle and protect the personal information you share with us while using our Service. It is structured to not only comply with legal standards but also to ensure transparency and user control over personal data.
By accessing or using our Service, you acknowledge and agree to the practices described in this policy. We encourage you to read this policy thoroughly to understand our approach to data privacy. If there are terms in this Privacy Policy that you do not agree with, please discontinue use of our Services immediately.
This Privacy Policy works in conjunction with our Terms and Conditions, forming a binding part of your agreement with us""",
                style: bodyFont,),
              50.ph,
              Text("2. Definitions", style: headerFont,),
              35.ph,
              Text("""In this Privacy Policy, certain terms have specific meanings:
* Service: Refers to the website (theBargainb.com) and the Bargainb mobile application, both of which are operated by BargainB.
* Personal Data: This is any information relating to an identified or identifiable individual. It's the kind of data that can reveal who you are, either directly or when combined with other information.
* Usage Data: Automatically collected data generated either by the use of the Service or from the Service infrastructure (like the duration of a page visit).
* Cookies: Small data files placed on your device (computer or mobile device) that help us to improve our Service and your experience.
* Data Controller: This is the entity that determines the purposes and ways in which personal data is processed. In this context, BargainB is the Data Controller of your data.
* Data Processors (or Service Providers): Third parties who process data on behalf of the Data Controller. We may engage various Service Providers to process your data more effectively.
* Data Subject: Any living individual who is using our Service and is the subject of Personal Data.
* User: Refers to the individual accessing or using our Service. The User is synonymous with the Data Subject, who is the subject of the Personal Data.""", style: bodyFont,),
              50.ph,
              Text("3. Information Collection and Use", style: headerFont,),
              35.ph,
              Text("""At BargainB, your privacy is our priority. We collect different types of information for diverse purposes to enhance your experience with our Service. Here's what we collect and why:
              
Personal Information: This includes data you provide that can identify you, like your name, email address, and phone number, which helps us to personalize and improve your experience.

Usage Information: We collect information sent by your browser or mobile device whenever you access our Service. This includes your IP address, browser type, browser version, the pages you visit, time and date of your visit, time spent on those pages, and other diagnostic data.

App Usage & In-App Event Tracking: We gather data on how you use our app, including the features you use, the frequency of your interactions, and your in-app preferences. This helps us to understand user behavior, improve app functionality, and develop new features that meet your needs.

Location Data: If you permit, we collect information about your location to offer location-specific services and content.

Tracking & Cookies Data: Cookies and similar tracking technologies are used to track activity on our Service. They help us in maintaining, improving, analyzing our services, and for advertising purposes.

The information we collect is essential for providing a personalized and efficient experience, ensuring the security of our platform, and for understanding how our services are used to continually improve them.""" ,style: bodyFont,),
              50.ph,
              Text("4. Types of Data Collected", style: headerFont,),
              35.ph,
              Text("Personal Data", style: subHeaderFont,),
              24.ph,
              Text("In our commitment to providing a personalized and efficient experience, BargainB may request certain personally identifiable information, known as Personal Data, during your use of our Service. This information is crucial for contact and identification purposes and typically includes, but is not limited to:In our commitment to providing a personalized and efficient experience, BargainB may request certain personally identifiable information, known as Personal Data, during your use of our Service. This information is crucial for contact and identification purposes and typically includes, but is not limited to:", style: bodyFont,),
              20.ph,
              Text("""
a. Email address
b. First name and last name
c. Phone number
"""
                , style: bodyFont,),
              20.ph,
              Text("""We utilize your Personal Data for various reasons, such as sending newsletters, marketing materials, and other relevant information. Should you prefer not to receive these communications, you have the option to opt-out by contacting us at customersupport@bargainb.com.""", style: bodyFont,),
              50.ph,
              Text("Usage Data", style: subHeaderFont,),
              24.ph,
              Text("""As part of our service enhancement efforts, we collect Usage Data, which is information automatically sent by your browser when you access our Service, either via a computer or a mobile device. This data helps us understand how you interact with our Service and includes details like:
- Your computer’s or mobile device’s Internet Protocol (IP) address
- Browser type and version
- Visited pages on our Service
- Dates and times of your visits
- Duration spent on those pages
- Unique device identifiers and other diagnostic data""", style: bodyFont,),
              50.ph,
              Text("Location Data", style: subHeaderFont,),
              24.ph,
              Text("""Similar to Usage Data, Location Data is collected to enhance the functionality and personalization of our Service. This includes the same types of information as Usage Data, focused specifically on your geographic location.""", style: bodyFont,),
              50.ph,
              Text("Tracking Cookies Data", style: subHeaderFont,),
              24.ph,
              Text("""To track activity on our Service and hold certain information, we use cookies and similar tracking technologies. Cookies are small data files that may include an anonymous unique identifier, sent to your browser from a website and stored on your device. Our use of these technologies includes:""", style: bodyFont,),
              20.ph,
              Text("""
a. Session Cookies: We use Session Cookies to operate our Service.
b. Preference Cookies: We use Preference Cookies to remember your preferences and various settings.
c. Security Cookies: We use Security Cookies for security purposes.
d. Advertising Cookies: Advertising Cookies are used to serve you with advertisements that may be relevant to you and your interests.""", style: bodyFont,),
              10.ph,
              Text("""Please note, if you choose not to accept cookies, some portions of our Service may not be accessible.""", style: bodyFont,),
              20.ph,
              Text('Contact List Data', style: subHeaderFont,),
              10.ph,
              Text("""For features that require social interaction or enhanced support, we may access your contact list, which includes:
- Contact names
- Phone numbers
- Email addresses
- Social media profiles
- This data enriches certain functionalities of our Service, like social connectivity and customer support.""", style: bodyFont,),
              20.ph,
              Text('Image data', style: subHeaderFont,),
              10.ph,
              Text("""Our Service allows the upload and sharing of images, such as photographs, screenshots, and other graphical content. This Image Data is used to enhance your experience with our Service, allowing for features like profile personalization and content sharing.""", style: bodyFont,),
              20.ph,
              Text('Usage of Contact List and Image Data', style: subHeaderFont,),
              10.ph,
              Text("""We employ Contact List and Image Data for various purposes:
- Personalizing your Service experience
- Facilitating social features
- Analyzing usage trends
- Providing customer support
- Sending consent-based marketing communications""", style: bodyFont,),
              50.ph,
              Text("5.Data Usage by BargainB", style: headerFont,),
              35.ph,
              Text("At BargainB, we utilize the data we collect in a multitude of ways to enhance your experience and the efficacy of our Service. The specific uses include:", style: bodyFont,),
              20.ph,
              Text("""
- Service Provision and Maintenance: Ensuring the smooth operation and continuous improvement of our Service.

- Updates Notification: Informing you about any changes or updates to our Service.

- Interactive Features Engagement: Allowing you to engage with interactive functionalities within our Service at your discretion.

- Customer Support: Offering assistance and support for any inquiries or issues you may encounter.

- Service Improvement Analysis: Analyzing data to gather valuable insights, aiding in the enhancement and optimization of our Service.

- Usage Monitoring: Tracking the usage of our Service to better understand user behavior and preferences.

- Technical Issues Management: Identifying, preventing, and addressing any technical challenges that may arise.

- Contractual Obligations Fulfillment: Executing our duties and asserting our rights under any agreements we have with you, including billing and collection processes.

- Account and Subscription Notices: Providing important notifications regarding your account and subscription, such as expiration, renewal notices, and email instructions.

- Promotional Communications: Offering news, special deals, and information about our goods, services, and events that might interest you, based on your previous purchases or inquiries. You have the option to opt out of receiving such communications.

- Customized Information Provision: Utilizing data in other ways as specifically described at the point of collection.

- Consent-Based Uses: Processing your data for any other purposes, subject to your explicit consent.

Our commitment lies in using your data responsibly and beneficially, always prioritizing your privacy and preferences in how we manage and apply the information you entrust to us.""", style: bodyFont,),
              50.ph,
              Text("6. Data Retention Policy", style: headerFont,),
              35.ph,
              Text("""At BargainB, the duration for which we retain your Personal Data is strictly aligned with the necessity of meeting the purposes outlined in this Privacy Policy. This includes retaining and utilizing your Personal Data to fulfill legal obligations, resolve disputes, and enforce our agreements and policies. Specifically, we retain your data:
              
- As long as necessary for the purposes stated in this Privacy Policy.
- To the extent required to comply with legal obligations (e.g., compliance with laws).
- For the resolution of disputes and enforcement of legal agreements and policies.

Usage Data, primarily used for internal analysis, is typically kept for a shorter duration. However, there are exceptions where this data may be retained longer, particularly:

- To enhance the security of our Service.
- To improve and maintain the functionality of our Service.
- When legal obligations necessitate longer retention periods.""", style: bodyFont,),
              50.ph,
              Text("7. Data Transfer Policy", style: headerFont,),
              35.ph,
              Text("""Your Personal Data may be transferred and stored on computers located outside your local jurisdiction, where data protection laws may vary. This particularly applies if you are outside the United States and choose to provide information to us. In such cases:
- We transfer and process Personal Data, including yours, in the United States.
- Your consent to this Privacy Policy, followed by your submission of information, constitutes your agreement to this data transfer.
BargainB commits to ensuring the security of your data in alignment with this Privacy Policy. We guarantee that:
- Transfers of Personal Data will only occur to countries or organizations with adequate data protection measures.
- Your data security and privacy are paramount in any data transfer scenario.""", style: bodyFont,),
              50.ph,
              Text("8. Data Disclosure Practices", style: headerFont,),
              35.ph,
              Text("""BargainB may disclose the personal information collected from you in the following scenarios:
a. Law Enforcement and Legal Compliance:
We may disclose your Personal Data in response to lawful requests by public authorities or if required by law.
b. Business Transactions:
In events like mergers, acquisitions, or asset sales involving us or our subsidiaries, your Personal Data may be part of the transferred assets.
c. Other Disclosures:
- To our subsidiaries, affiliates, contractors, and third-party service providers for business support.
- To fulfill the purposes for which you provide the data.
- For including your company’s logo on our website, upon your consent.
- For any other purposes we disclose when you provide the information.
- With your consent in specific cases not listed above.

If necessary to protect the rights, property, or safety of our company, our customers, or others.
In each case, our commitment is to handle your data responsibly, respecting your privacy and rights, and in line with our overarching privacy principles.""", style: bodyFont,),
              50.ph,
              Text("9. Security of Data", style: headerFont,),
              35.ph,
              Text("""Data Security at BargainB
We at BargainB prioritize the security of your data. However, it's important to note that no method of transmission over the Internet or electronic storage is completely secure. While we employ commercially acceptable means to protect your Personal Data, we cannot assure its absolute security.

Your Data Protection Rights Under GDPR
For residents of the European Union (EU) and European Economic Area (EEA), the General Data Protection Regulation (GDPR) grants specific data protection rights:
- Access and Control: You can request access to your Personal Data we hold and can ask for it to be amended or deleted.
- Rectification Right: If your information is incorrect or incomplete, you have the right to have it corrected.
- Objection Right: You have the right to object to our processing of your Personal Data.
- Restriction Right: You can request that we restrict the processing of your information.
- Data Portability Right: You have the right to receive your Personal Data in a structured, commonly used format.
- Withdrawal of Consent: You can withdraw consent at any time for data processing based on your consent.
- Complaint Filing: You have the right to file a complaint with a Data Protection Authority regarding our collection and use of your Personal Data.

For exercising these rights or inquiries, please contact us at customersupport@bargainb.com.

Your Rights Under CalOPPA

Under the California Privacy Protection Act (CalOPPA), you have the following rights:
- Anonymity in Browsing: Users can visit our site anonymously.
- Policy Accessibility: Our Privacy Policy, containing the word “Privacy,” is easily accessible on our website.
- Notification of Policy Changes: Changes to our privacy policy are communicated on our Privacy Policy Page.
- Personal Information Modification: You can change your personal information by contacting us at customersupport@bargainb.com.
Do Not Track Signals
We respect Do Not Track signals and do not track, plant cookies, or use advertising when a Do Not Track browser mechanism is active.

Your Rights Under CCPA

As per the California Consumer Privacy Act (CCPA), if you are a California resident, you are entitled to:
- Know About Personal Data Collected: Request information about the personal information we have collected, used, sold, or disclosed.
- Request Deletion: Ask for the deletion of your personal information.
- Opt-Out of Sale: Direct us not to sell your personal information.

To exercise these rights, contact us at customersupport@bargainb.com. Note that requesting data deletion or not to sell your information may affect your experience with our services. We ensure non-discrimination against any user exercising their CCPA rights.
For more details on CCPA, visit the California Legislative Information website. The CCPA has been effective since 01/01/2020.""", style: bodyFont,),
//               50.ph,
//               Text("9. Service Providers", style: headerFont,),
//               35.ph,
//               Text("""We may employ third party companies and individuals to facilitate our Service (“Service Providers”), provide Service on our behalf, perform Service-related services or assist us in analysing how our Service is used.
//
// These third parties have access to your Personal Data only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.""", style: bodyFont,),
//               50.ph,
//               Text("10. Analytics", style: headerFont,),
//               35.ph,
//               Text("""We may use third-party Service Providers to monitor and analyze the use of our Service.
//
// Google Analytics
// Google Analytics is a web analytics service offered by Google that tracks and reports website traffic. Google uses the data collected to track and monitor the use of our Service. This data is shared with other Google services. Google may use the collected data to contextualise and personalise the ads of its own advertising network.
//
// For more information on the privacy practices of Google, please visit the Google Privacy Terms web page: https://policies.google.com/privacy?hl=en
//
// We also encourage you to review the Google's policy for safeguarding your data: https://support.google.com/analytics/answer/6004245.
//
// Firebase
// Firebase is analytics service provided by Google Inc.
//
// You may opt-out of certain Firebase features through your mobile device settings, such as your device advertising settings or by following the instructions provided by Google in their Privacy Policy: https://policies.google.com/privacy?hl=en
//
// For more information on what type of information Firebase collects, please visit the Google Privacy Terms web page: https://policies.google.com/privacy?hl=en""", style: bodyFont,),
//               50.ph,
//               Text("11. CI/CD tools", style: headerFont,),
//               35.ph,
//               Text("""We may use third-party Service Providers to automate the development process of our Service.
//
// GitHub
// GitHub is provided by GitHub, Inc.
//
// GitHub is a development platform to host and review code, manage projects, and build software.
//
// For more information on what data GitHub collects for what purpose and how the protection of the data is ensured, please visit GitHub Privacy Policy page: https://help.github.com/en/articles/github-privacy-statement.""", style: bodyFont,),
//               50.ph,
//               Text("12. Advertising", style: headerFont,),
//               35.ph,
//               Text("""We may use third-party Service Providers to show advertisements to you to help support and maintain our Service.
//
// Google AdSense DoubleClick Cookie
// Google, as a third party vendor, uses cookies to serve ads on our Service. Google's use of the DoubleClick cookie enables it and its partners to serve ads to our users based on their visit to our Service or other websites on the Internet.
//
// You may opt out of the use of the DoubleClick Cookie for interest-based advertising by visiting the Google Ads Settings web page: http://www.google.com/ads/preferences/
//
// AdMob by Google
// AdMob by Google is provided by Google Inc.
//
// You can opt-out from the AdMob by Google service by following the instructions described by Google: https://support.google.com/ads/answer/2662922?hl=en
//
// For more information on how Google uses the collected information, please visit the “How Google uses data when you use our partners' sites or app” page: http://www.google.com/policies/privacy/partners/ or visit the Privacy Policy of Google: http://www.google.com/policies/privacy/""", style: bodyFont,),
//               50.ph,
//               Text("13. Behavioral Remarketing", style: headerFont,),
//               35.ph,
//               Text("""BargainB uses remarketing services to advertise on third party websites to you after you visited our Service. We and our third-party vendors use cookies to inform, optimise and serve ads based on your past visits to our Service.
//
// Google Ads (AdWords)
// Google Ads (AdWords) remarketing service is provided by Google Inc.
//
// You can opt-out of Google Analytics for Display Advertising and customize the Google Display Network ads by visiting the Google Ads Settings page: http://www.google.com/settings/ads
//
// Google also recommends installing the Google Analytics Opt-out Browser Add-on – https://tools.google.com/dlpage/gaoptout – for your web browser. Google Analytics Opt-out Browser Add-on provides visitors with the ability to prevent their data from being collected and used by Google Analytics.
//
// For more information on the privacy practices of Google, please visit the Google Privacy Terms web page: https://policies.google.com/privacy?hl=en
//
// Twitter
// Twitter remarketing service is provided by Twitter Inc.
//
// You can opt-out from Twitter's interest-based ads by following their instructions: https://support.twitter.com/articles/20170405
// You can learn more about the privacy practices and policies of Twitter by visiting their Privacy Policy page: https://twitter.com/privacy
//
// Facebook
// Facebook remarketing service is provided by Facebook Inc.
//
// You can learn more about interest-based advertising from Facebook by visiting this page: https://www.facebook.com/help/164968693837950
//
// To opt-out from Facebook's interest-based ads, follow these instructions from Facebook: https://www.facebook.com/help/568137493302217
//
// Facebook adheres to the Self-Regulatory Principles for Online Behavioural Advertising established by the Digital Advertising Alliance. You can also opt-out from Facebook and other participating companies through the Digital Advertising Alliance in the USA http://www.aboutads.info/choices/, the Digital Advertising Alliance of Canada in Canada http://youradchoices.ca/ or the European Interactive Digital Advertising Alliance in Europe http://www.youronlinechoices.eu/, or opt-out using your mobile device settings.
//
// For more information on the privacy practices of Facebook, please visit Facebook's Data Policy: https://www.facebook.com/privacy/explanation""", style: bodyFont,),
//               50.ph,
//               Text("14. Payments", style: headerFont,),
//               35.ph,
//               Text("""We may provide paid products and/or services within Service. In that case, we use third-party services for payment processing (e.g. payment processors).
//
// We will not store or collect your payment card details. That information is provided directly to our third-party payment processors whose use of your personal information is governed by their Privacy Policy. These payment processors adhere to the standards set by PCI-DSS as managed by the PCI Security Standards Council, which is a joint effort of brands like Visa, Mastercard, American Express and Discover. PCI-DSS requirements help ensure the secure handling of payment information.
//
// The payment processors we work with are:
//
// PayPal or Braintree:
// Their Privacy Policy can be viewed at https://www.paypal.com/webapps/mpp/ua/privacy-full
//
// Apple Store In-App Payments:
// Their Privacy Policy can be viewed at: https://www.apple.com/legal/privacy/en-ww/ / https://support.apple.com/en-us/HT203027
//
// Google Play In-App Payments:
// Their Privacy Policy can be viewed at: https://policies.google.com/privacy?hl=en&gl=us / https://payments.google.com/payments/apis-secure/u/0/get_legal_document?ldo=0&ldt=privacynotice&ldl=en
//
// Stripe:
// Their Privacy Policy can be viewed at: https://stripe.com/us/privacy""", style: bodyFont,),
//               50.ph,
//               Text("15. Links to Other Sites", style: headerFont,),
//               35.ph,
//               Text("""Our Service may contain links to other sites that are not operated by us. If you click a third party link, you will be directed to that third party's site. We strongly advise you to review the Privacy Policy of every site you visit.
//
// We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.""", style: bodyFont,),
//               50.ph,
//               Text("16. Children’s Privacy", style: headerFont,),
//               35.ph,
//               Text("""Our Services are not intended for use by children under the age of 13 (“Children”).
//
// We do not knowingly collect personally identifiable information from Children under 13. If you become aware that a Child has provided us with Personal Data, please contact us. If we become aware that we have collected Personal Data from Children without verification of parental consent, we take steps to remove that information from our servers.""", style: bodyFont,),
//               50.ph,
//               Text("17. Changes to This Privacy Policy", style: headerFont,),
//               35.ph,
//               Text("""We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.
// We will let you know via email and/or a prominent notice on our Service, prior to the change becoming effective and update “effective date” at the top of this Privacy Policy.
// You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.""", style: bodyFont,),
//               50.ph,
//               Text("18. Contact Us", style: headerFont,),
//               35.ph,
//               Text("""If you have any questions about this Privacy Policy, please contact us:
// By email: customersupport@bargainb.com.""", style: bodyFont,),
              100.ph,
              Row(
                children: [
                  Text('RedCastleCP All right Reserved. 2023', style: TextStyles.textViewLight8,),
                  Spacer(),
                  TextButton(onPressed: () => AppNavigator.pushReplacement(context: context, screen: TermsOfServiceScreen()),
                      child: Text("Terms & Conditions".tr(), style: TextStyles.textViewLight8.copyWith(decoration: TextDecoration.underline),)),
                  TextButton(onPressed: () => AppNavigator.pushReplacement(context: context, screen: PolicyScreen()), child: Text("Privacy Policy".tr(), style: TextStyles.textViewLight8.copyWith(decoration: TextDecoration.underline),))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
