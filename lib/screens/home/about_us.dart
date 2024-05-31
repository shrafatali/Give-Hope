import 'package:flutter/material.dart';
import 'package:give_hope/components/constants.dart';

class AboutUS extends StatelessWidget {
  const AboutUS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.whiteColor,
          ),
        ),
        title: Text(
          'About Us',
          style: TextStyle(
            fontSize: 18,
            color: AppColor.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
            gradient: LinearGradient(
              colors: [Color(0xff471a91), Color(0xff3cabff)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'Give Hope - Helping Poor People By Donation',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Welcome to Give Hope, an innovative mobile app designed to address the pressing financial crisis facing many in Pakistan, particularly impacting the lower and lower-middle-class communities. At Give Hope, our primary motivation is rooted in serving humanity, providing a platform where people can extend their generosity in various forms.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Give Hope is driven by a profound mission: to alleviate the burdens of poverty and financial distress by connecting those who have resources with those in need. In a country where economic challenges persist, our platform serves as a beacon of hope, offering assistance to those struggling to afford basic necessities.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Objectives',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Our objectives are clear: to support individuals who find themselves unable to pay school fees, purchase essential items like clothing, books, toys, or medicine, and even provide access to groceries. Give Hope aims to be a comprehensive solution, tackling multiple challenges faced by vulnerable populations.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Unique Approach',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Unlike existing systems that often focus on addressing single issues at a time, Give Hope stands out by offering a multifaceted approach. Through our platform, users can participate in fundraising efforts for the poor, donate food, arrange blood donations, contribute to medicine supplies, and offer clothing, all within a single, user-friendly interface.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Community Impact',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Give Hope isn't just about individual assistance; it's about community development and empowerment. By facilitating donations and support, we aim to uplift entire communities, fostering resilience and hope for a brighter future.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Join Us',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "We invite you to join us in our mission to bring hope to those in need. Whether you're an individual looking to make a difference or a nonprofit organization seeking to expand your impact, Give Hope welcomes you to be a part of our community-driven initiative./n     Together, let's create a world where compassion knows no bounds and every person has the opportunity to thrive. Join Give Hope today and make a meaningful difference in the lives of others.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
