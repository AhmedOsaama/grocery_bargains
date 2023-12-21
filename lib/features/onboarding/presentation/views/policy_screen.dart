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
              Text("""
Welcome to BargainB.
            
BargainB (“us”, “we”, or “our”) operates theBargainb.com and Bargainb mobile application (hereinafter referred to as “Service”).

Our Privacy Policy governs your visit to theBargainb.com and Bargainb mobile application, and explains how we collect, safeguard and disclose information that results from your use of our Service.

We use your data to provide and improve Service. By using Service, you agree to the collection and use of information in accordance with this policy. Unless otherwise defined in this Privacy Policy, the terms used in this Privacy Policy have the same meanings as in our Terms and Conditions.

Our Terms and Conditions (“Terms”) govern all use of our Service and together with the Privacy Policy constitutes your agreement with us (“agreement”).
              """,
                style: bodyFont,),
              50.ph,
              Text("2. Definitions", style: headerFont,),
              35.ph,
              Text("""SERVICE means the theBargainb.com website and Bargainb mobile application operated by BargainB.
PERSONAL DATA means data about a living individual who can be identified from those data (or from those and other information either in our possession or likely to come into our possession).
USAGE DATA is data collected automatically either generated by the use of Service or from Service infrastructure itself (for example, the duration of a page visit).
COOKIES are small files stored on your device (computer or mobile device).
DATA CONTROLLER means a natural or legal person who (either alone or jointly or in common with other persons) determines the purposes for which and the manner in which any personal data are, or are to be, processed. For the purpose of this Privacy Policy, we are a Data Controller of your data.
DATA PROCESSORS (OR SERVICE PROVIDERS) means any natural or legal person who processes the data on behalf of the Data Controller. We may use the services of various Service Providers in order to process your data more effectively.
DATA SUBJECT is any living individual who is the subject of Personal Data.
THE USER is the individual using our Service. The User corresponds to the Data Subject, who is the subject of Personal Data.""", style: bodyFont,),
              50.ph,
              Text("3. Information Collection and Use", style: headerFont,),
              35.ph,
              Text("""We collect several different types of information for various purposes to provide and improve our Service to you.""" ,style: bodyFont,),
              50.ph,
              Text("4. Types of Data Collected", style: headerFont,),
              35.ph,
              Text("Personal Data", style: subHeaderFont,),
              24.ph,
              Text("While using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you (“Personal Data”)."
                  " Personally identifiable information may include, but is not limited to:", style: bodyFont,),
              20.ph,
              Text("""
a. Email address
b. First name and last name
c. Phone number
d. Cookies and Usage Data""", style: bodyFont,),
              20.ph,
              Text("""We may use your Personal Data to contact you with newsletters, marketing or promotional materials and other information that may be of interest to you. You may opt out of receiving any, or all, of these communications from us by emailing at customersupport@bargainb.com.""", style: bodyFont,),
              50.ph,
              Text("Usage Data", style: subHeaderFont,),
              24.ph,
              Text("""We may also collect information that your browser sends whenever you visit our Service or when you access Service by or through a mobile device (“Usage Data”).
This Usage Data may include information such as your computer's Internet Protocol address (e.g. IP address),
 browser type, browser version, the pages of our Service that you visit,
the time and date of your visit, the time spent on those pages, unique device identifiers and other diagnostic data.
When you access Service with a mobile device, this Usage Data may include information such as the type of mobile device you use,
 your mobile device unique ID, the IP address of your mobile device,
 your mobile operating system, the type of mobile Internet browser you use, unique device identifiers and other diagnostic data.""", style: bodyFont,),
              50.ph,
              Text("Location Data", style: subHeaderFont,),
              24.ph,
              Text("""We may also collect information that your browser sends whenever you visit our Service or when you access Service by or through a mobile device (“Usage Data”).
This Usage Data may include information such as your computer's Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that you visit, the time and date of your visit, the time spent on those pages, unique device identifiers and other diagnostic data.
When you access Service with a mobile device, this Usage Data may include information such as the type of mobile device you use, your mobile device unique ID, 
the IP address of your mobile device, your mobile operating system, the type of mobile Internet browser you use, unique device identifiers and other diagnostic data.""", style: bodyFont,),
              50.ph,
              Text("Tracking Cookies Data", style: subHeaderFont,),
              24.ph,
              Text("""We use cookies and similar tracking technologies to track the activity on our Service and we hold certain information.

Cookies are files with a small amount of data which may include an anonymous unique identifier. Cookies are sent to your browser from a website and stored on your device. Other tracking technologies are also used such as beacons, tags and scripts to collect and track information and to improve and analyze our Service.

You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent. However, if you do not accept cookies, you may not be able to use some portions of our Service.

Examples of Cookies we use:""", style: bodyFont,),
              50.ph,
              Text("""
a. Session Cookies: We use Session Cookies to operate our Service.
b. Preference Cookies: We use Preference Cookies to remember your preferences and various settings.
c. Security Cookies: We use Security Cookies for security purposes.
d. Advertising Cookies: Advertising Cookies are used to serve you with advertisements that may be relevant to you and your interests.""", style: bodyFont,),
              50.ph,
              Text("5.Use of Data", style: headerFont,),
              35.ph,
              Text("BargainB uses the collected data for various purposes:", style: bodyFont,),
              20.ph,
              Text("""
a. to provide and maintain our Service;
b. to notify you about changes to our Service;
c. to allow you to participate in interactive features of our Service when you choose to do so;
d. to provide customer support;
e. to gather analysis or valuable information so that we can improve our Service;
f. to monitor the usage of our Service;
g. to detect, prevent and address technical issues;
h. to fulfill any other purpose for which you provide it;
i. to carry out our obligations and enforce our rights arising from any contracts entered into between you and us, including for billing and collection;
j. to provide you with notices about your account and/or subscription, including expiration and renewal notices, email-instructions, etc.;
k. to provide you with news, special offers and general information about other goods, services and events which we offer that are similar to those that you have already purchased or enquired about unless you have opted not to receive such information;
l. in any other way we may describe when you provide the information;
m. for any other purpose with your consent.""", style: bodyFont,),
              50.ph,
              Text("6. Retention of Data", style: headerFont,),
              35.ph,
              Text("""We will retain your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.

We will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period, except when this data is used to strengthen the security or to improve the functionality of our Service, or we are legally obligated to retain this data for longer time periods.""", style: bodyFont,),
              50.ph,
              Text("7. Transfer of Data", style: headerFont,),
              35.ph,
              Text("""Your information, including Personal Data, may be transferred to – and maintained on – computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ from those of your jurisdiction.

If you are located outside United States and choose to provide information to us, please note that we transfer the data, including Personal Data, to United States and process it there.

Your consent to this Privacy Policy followed by your submission of such information represents your agreement to that transfer.

BargainB will take all the steps reasonably necessary to ensure that your data is treated securely and in accordance with this Privacy Policy and no transfer of your Personal Data will take place to an organisation or a country unless there are adequate controls in place including the security of your data and other personal information.""", style: bodyFont,),
              50.ph,
              Text("8. Disclosure of Data", style: headerFont,),
              35.ph,
              Text("""We may disclose personal information that we collect, or you provide:
 a. Disclosure for Law Enforcement.
Under certain circumstances, we may be required to disclose your Personal Data if required to do so by law or in response to           valid requests by public authorities.
      b. Business Transaction.
If we or our subsidiaries are involved in a merger, acquisition or asset sale, your Personal Data may be transferred.
      c. Other cases. We may disclose your information also:
      a. to our subsidiaries and affiliates;
b. to contractors, service providers, and other third parties we use to support our business;
c. to fulfill the purpose for which you provide it;
d. for the purpose of including your company’s logo on our website;
e. for any other purpose disclosed by us when you provide the information;
f. with your consent in any other cases;
g. if we believe disclosure is necessary or appropriate to protect the rights, property, or safety of the Company, our customers, or others""", style: bodyFont,),
              50.ph,
              Text("9. Security of Data", style: headerFont,),
              35.ph,
              Text("""The security of your data is important to us but remember that no method of transmission over the Internet or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security.

Your Data Protection Rights Under General Data Protection Regulation (GDPR)

If you are a resident of the European Union (EU) and European Economic Area (EEA), you have certain data protection rights, covered by GDPR. – See more at https://eur-lex.europa.eu/eli/reg/2016/679/oj

We aim to take reasonable steps to allow you to correct, amend, delete, or limit the use of your Personal Data.

If you wish to be informed what Personal Data we hold about you and if you want it to be removed from our systems, please email us at customersupport@bargainb.com.

In certain circumstances, you have the following data protection rights:
the right to access, update or to delete the information we have on you;
the right of rectification. You have the right to have your information rectified if that information is inaccurate or incomplete;
the right to object. You have the right to object to our processing of your Personal Data;
the right of restriction. You have the right to request that we restrict the processing of your personal information;
the right to data portability. You have the right to be provided with a copy of your Personal Data in a structured, machine-readable and commonly used format;
the right to withdraw consent. You also have the right to withdraw your consent at any time where we rely on your consent to process your personal information;

Please note that we may ask you to verify your identity before responding to such requests. Please note, we may not able to provide Service without some necessary data.

You have the right to complain to a Data Protection Authority about our collection and use of your Personal Data. For more information, please contact your local data protection authority in the European Economic Area (EEA).

  2. Your Data Protection Rights under the California Privacy Protection Act (CalOPPA)

CalOPPA is the first state law in the nation to require commercial websites and online services to post a privacy policy. The law’s reach stretches well beyond California to require a person or company in the United States (and conceivable the world) that operates websites collecting personally identifiable information from California consumers to post a conspicuous privacy policy on its website stating exactly the information being collected and those individuals with whom it is being shared, and to comply with this policy. – See more at: https://consumercal.org/about-cfc/cfc-education-foundation/california-online-privacy-protection-act-caloppa-3/

According to CalOPPA we agree to the following:
users can visit our site anonymously;
our Privacy Policy link includes the word “Privacy”, and can easily be found on the page specified above on the home page of our website;
users will be notified of any privacy policy changes on our Privacy Policy Page;
users are able to change their personal information by emailing us at customersupport@bargainb.com.

Our Policy on “Do Not Track” Signals:

We honor Do Not Track signals and do not track, plant cookies, or use advertising when a Do Not Track browser mechanism is in place. Do Not Track is a preference you can set in your web browser to inform websites that you do not want to be tracked.

You can enable or disable Do Not Track by visiting the Preferences or Settings page of your web browser.

  3. Your Data Protection Rights under the California Consumer Privacy Act (CCPA)

If you are a California resident, you are entitled to learn what data we collect about you, ask to delete your data and not to sell (share) it. To exercise your data protection rights, you can make certain requests and ask us:
What personal information we have about you. If you make this request, we will return to you:
The categories of personal information we have collected about you.
The categories of sources from which we collect your personal information.
The business or commercial purpose for collecting or selling your personal information.
The categories of third parties with whom we share personal information.
The specific pieces of personal information we have collected about you.
A list of categories of personal information that we have sold, along with the category of any other company we sold it to. If we have not sold your personal information, we will inform you of that fact.
A list of categories of personal information that we have disclosed for a business purpose, along with the category of any other company we shared it with.

Please note, you are entitled to ask us to provide you with this information up to two times in a rolling twelve-month period. When you make this request, the information provided may be limited to the personal information we collected about you in the previous 12 months.
To delete your personal information. If you make this request, we will delete the personal information we hold about you as of the date of your request from our records and direct any service providers to do the same. In some cases, deletion may be accomplished through de-identification of the information. If you choose to delete your personal information, you may not be able to use certain functions that require your personal information to operate.
To stop selling your personal information. We do not sell your personal information for monetary consideration. However, under some circumstances, a transfer of personal information to a third party, or within our family of companies, without monetary consideration may be considered a “sale” under California law.

If you submit a request to stop selling your personal information, we will stop making such transfers. If you are a California resident, to opt-out of the sale of your personal information, click “Do Not Sell My Personal Information” at the bottom of our home page to submit your request.

Please note, if you ask us to delete or stop selling your data, it may impact your experience with us, and you may not be able to participate in certain programs or membership services which require the usage of your personal information to function. But in no circumstances, we will discriminate against you for exercising your rights.

To exercise your California data protection rights described above, please send your request(s) by one of the following means:

By email: customersupport@bargainb.com

Your data protection rights, described above,
 are covered by the CCPA, short for the California Consumer Privacy Act.
  To find out more, visit the official California Legislative Information website. The CCPA took effect on 01/01/2020.""", style: bodyFont,),
              50.ph,
              Text("9. Service Providers", style: headerFont,),
              35.ph,
              Text("""We may employ third party companies and individuals to facilitate our Service (“Service Providers”), provide Service on our behalf, perform Service-related services or assist us in analysing how our Service is used.

These third parties have access to your Personal Data only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.""", style: bodyFont,),
              50.ph,
              Text("10. Analytics", style: headerFont,),
              35.ph,
              Text("""We may use third-party Service Providers to monitor and analyze the use of our Service.

Google Analytics
Google Analytics is a web analytics service offered by Google that tracks and reports website traffic. Google uses the data collected to track and monitor the use of our Service. This data is shared with other Google services. Google may use the collected data to contextualise and personalise the ads of its own advertising network.

For more information on the privacy practices of Google, please visit the Google Privacy Terms web page: https://policies.google.com/privacy?hl=en

We also encourage you to review the Google's policy for safeguarding your data: https://support.google.com/analytics/answer/6004245.

Firebase
Firebase is analytics service provided by Google Inc.

You may opt-out of certain Firebase features through your mobile device settings, such as your device advertising settings or by following the instructions provided by Google in their Privacy Policy: https://policies.google.com/privacy?hl=en

For more information on what type of information Firebase collects, please visit the Google Privacy Terms web page: https://policies.google.com/privacy?hl=en""", style: bodyFont,),
              50.ph,
              Text("11. CI/CD tools", style: headerFont,),
              35.ph,
              Text("""We may use third-party Service Providers to automate the development process of our Service.

GitHub
GitHub is provided by GitHub, Inc.

GitHub is a development platform to host and review code, manage projects, and build software.

For more information on what data GitHub collects for what purpose and how the protection of the data is ensured, please visit GitHub Privacy Policy page: https://help.github.com/en/articles/github-privacy-statement.""", style: bodyFont,),
              50.ph,
              Text("12. Advertising", style: headerFont,),
              35.ph,
              Text("""We may use third-party Service Providers to show advertisements to you to help support and maintain our Service.

Google AdSense DoubleClick Cookie
Google, as a third party vendor, uses cookies to serve ads on our Service. Google's use of the DoubleClick cookie enables it and its partners to serve ads to our users based on their visit to our Service or other websites on the Internet.

You may opt out of the use of the DoubleClick Cookie for interest-based advertising by visiting the Google Ads Settings web page: http://www.google.com/ads/preferences/

AdMob by Google
AdMob by Google is provided by Google Inc.

You can opt-out from the AdMob by Google service by following the instructions described by Google: https://support.google.com/ads/answer/2662922?hl=en

For more information on how Google uses the collected information, please visit the “How Google uses data when you use our partners' sites or app” page: http://www.google.com/policies/privacy/partners/ or visit the Privacy Policy of Google: http://www.google.com/policies/privacy/""", style: bodyFont,),
              50.ph,
              Text("13. Behavioral Remarketing", style: headerFont,),
              35.ph,
              Text("""BargainB uses remarketing services to advertise on third party websites to you after you visited our Service. We and our third-party vendors use cookies to inform, optimise and serve ads based on your past visits to our Service.

Google Ads (AdWords)
Google Ads (AdWords) remarketing service is provided by Google Inc.

You can opt-out of Google Analytics for Display Advertising and customize the Google Display Network ads by visiting the Google Ads Settings page: http://www.google.com/settings/ads

Google also recommends installing the Google Analytics Opt-out Browser Add-on – https://tools.google.com/dlpage/gaoptout – for your web browser. Google Analytics Opt-out Browser Add-on provides visitors with the ability to prevent their data from being collected and used by Google Analytics.

For more information on the privacy practices of Google, please visit the Google Privacy Terms web page: https://policies.google.com/privacy?hl=en

Twitter
Twitter remarketing service is provided by Twitter Inc.

You can opt-out from Twitter's interest-based ads by following their instructions: https://support.twitter.com/articles/20170405
You can learn more about the privacy practices and policies of Twitter by visiting their Privacy Policy page: https://twitter.com/privacy

Facebook
Facebook remarketing service is provided by Facebook Inc.

You can learn more about interest-based advertising from Facebook by visiting this page: https://www.facebook.com/help/164968693837950

To opt-out from Facebook's interest-based ads, follow these instructions from Facebook: https://www.facebook.com/help/568137493302217

Facebook adheres to the Self-Regulatory Principles for Online Behavioural Advertising established by the Digital Advertising Alliance. You can also opt-out from Facebook and other participating companies through the Digital Advertising Alliance in the USA http://www.aboutads.info/choices/, the Digital Advertising Alliance of Canada in Canada http://youradchoices.ca/ or the European Interactive Digital Advertising Alliance in Europe http://www.youronlinechoices.eu/, or opt-out using your mobile device settings.

For more information on the privacy practices of Facebook, please visit Facebook's Data Policy: https://www.facebook.com/privacy/explanation""", style: bodyFont,),
              50.ph,
              Text("14. Payments", style: headerFont,),
              35.ph,
              Text("""We may provide paid products and/or services within Service. In that case, we use third-party services for payment processing (e.g. payment processors).

We will not store or collect your payment card details. That information is provided directly to our third-party payment processors whose use of your personal information is governed by their Privacy Policy. These payment processors adhere to the standards set by PCI-DSS as managed by the PCI Security Standards Council, which is a joint effort of brands like Visa, Mastercard, American Express and Discover. PCI-DSS requirements help ensure the secure handling of payment information.

The payment processors we work with are:

PayPal or Braintree:
Their Privacy Policy can be viewed at https://www.paypal.com/webapps/mpp/ua/privacy-full

Apple Store In-App Payments:
Their Privacy Policy can be viewed at: https://www.apple.com/legal/privacy/en-ww/ / https://support.apple.com/en-us/HT203027

Google Play In-App Payments:
Their Privacy Policy can be viewed at: https://policies.google.com/privacy?hl=en&gl=us / https://payments.google.com/payments/apis-secure/u/0/get_legal_document?ldo=0&ldt=privacynotice&ldl=en

Stripe:
Their Privacy Policy can be viewed at: https://stripe.com/us/privacy""", style: bodyFont,),
              50.ph,
              Text("15. Links to Other Sites", style: headerFont,),
              35.ph,
              Text("""Our Service may contain links to other sites that are not operated by us. If you click a third party link, you will be directed to that third party's site. We strongly advise you to review the Privacy Policy of every site you visit.

We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.""", style: bodyFont,),
              50.ph,
              Text("16. Children’s Privacy", style: headerFont,),
              35.ph,
              Text("""Our Services are not intended for use by children under the age of 13 (“Children”).

We do not knowingly collect personally identifiable information from Children under 13. If you become aware that a Child has provided us with Personal Data, please contact us. If we become aware that we have collected Personal Data from Children without verification of parental consent, we take steps to remove that information from our servers.""", style: bodyFont,),
              50.ph,
              Text("17. Changes to This Privacy Policy", style: headerFont,),
              35.ph,
              Text("""We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.
We will let you know via email and/or a prominent notice on our Service, prior to the change becoming effective and update “effective date” at the top of this Privacy Policy.
You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.""", style: bodyFont,),
              50.ph,
              Text("18. Contact Us", style: headerFont,),
              35.ph,
              Text("""If you have any questions about this Privacy Policy, please contact us:
By email: customersupport@bargainb.com.""", style: bodyFont,),
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
