import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  debugPrint(uri.toString());

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    debugPrint('Could not launch $url');
  }
}

Future<int> _fetchActiveCampaign() async {
  try {
    final baseUrl = dotenv.maybeGet('BASE_URL') ?? '';
    if (baseUrl.isEmpty) {
      throw Exception('BASE_URL is not set in the environment variables.');
    }
    final response = await http.get(Uri.parse('$baseUrl/v1/campaigns/active'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData =
          Map<String, dynamic>.from(jsonDecode(response.body));
      final campaign = responseData['campaign'];
      if (campaign != null) {
        final campaignId = campaign['id'];
        return campaignId;
      } else {
        throw Exception('No active campaign found');
      }
    } else {
      throw Exception('Failed to load active campaign: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    debugPrint('Error fetching active campaign: $e');
    debugPrint('Stack trace:\n$stackTrace');
    rethrow;
  }
}

Future<List<Content>> _fetchCampaignContent(int campaignId) async {
  try {
    final baseUrl = dotenv.maybeGet('BASE_URL') ?? '';
    if (baseUrl.isEmpty) {
      throw Exception('BASE_URL is not set in the environment variables.');
    }
    final response =
        await http.get(Uri.parse('$baseUrl/v1/campaign/$campaignId/content'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> contentsJson = responseData['contents'];
      final List<Content> contents = contentsJson.map((contentJson) {
        return Content.fromJson(contentJson);
      }).toList();
      return contents;
    } else {
      throw Exception(
          'Failed to load campaign content: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    debugPrint('Error fetching campaign content: $e');
    debugPrint('Stack trace:\n$stackTrace');
    rethrow;
  }
}

Future<List<Content>> fetchAdvertisementContent() async {
  try {
    final campaignId = await _fetchActiveCampaign();
    final contentList = await _fetchCampaignContent(campaignId);
    contentList.sort((a, b) => a.order.compareTo(b.order));
    return contentList;
  } catch (e, stackTrace) {
    debugPrint('Error fetching advertisement content: $e');
    debugPrint('Stack trace:\n$stackTrace');
    rethrow;
  }
}

class Content {
  final String? buttonLink;
  final String? buttonText;
  final int campaignId;
  final String? contentType;
  final String? description;
  final String endDate;
  final String? externalUrl;
  final int id;
  final String? imageFilename;
  final String? imagePath;
  final String? imageUrl;
  final int order;
  final String startDate;
  final String? subtitle;
  final String? title;

  Content({
    this.buttonLink,
    this.buttonText,
    required this.campaignId,
    this.contentType,
    this.description,
    required this.endDate,
    this.externalUrl,
    required this.id,
    this.imageFilename,
    this.imagePath,
    this.imageUrl,
    required this.order,
    required this.startDate,
    this.subtitle,
    this.title,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        buttonLink: json["button_link"],
        buttonText: json["button_text"],
        campaignId: json["campaign_id"],
        contentType: json["content_type"],
        description: json["description"],
        endDate: json["end_date"],
        externalUrl: json["external_url"],
        id: json["id"],
        imageFilename: json["image_filename"],
        imagePath: json["image_path"],
        imageUrl: json["image_url"],
        order: json["order"],
        startDate: json["start_date"],
        subtitle: json["subtitle"],
        title: json["title"],
      );
}

class AdvertisementBanner extends StatefulWidget {
  const AdvertisementBanner({super.key});

  @override
  State<AdvertisementBanner> createState() => _AdvertisementBannerState();
}

class _AdvertisementBannerState extends State<AdvertisementBanner> {
  List<Content> _contentList = [];
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _loadContent();
    _startTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_contentList.isEmpty || !_pageController.hasClients) return;

      int nextPage = _pageController.page?.round() ?? 0;
      nextPage = (nextPage + 1) % _contentList.length;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _loadContent() async {
    setState(() => _isLoading = true);
    try {
      final contentList =
          await fetchAdvertisementContent(); // Assume this exists
      if (mounted) {
        setState(() {
          _contentList = contentList;
        });
      }
    } catch (e) {
      debugPrint('Error loading content: $e');
    } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentPage = _currentPage;

    if (_isLoading) {
      return const SizedBox(
        height: 350,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                padEnds: false,
                itemCount: _contentList.length,
                onPageChanged: (int page) {
                  setState(() => _currentPage = page);
                },
                itemBuilder: (context, index) {
                  final content = _contentList[index];
              
                  final baseUrl = dotenv.maybeGet('BASE_URL') ?? '';

                  final imageUrl = content.imageUrl != null ? '$baseUrl${content.imageUrl}' : content.externalUrl;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(color: Colors.grey.shade300),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                        child: Icon(Icons.broken_image,
                                            color: Colors.white)),
                              )
                            : Container(color: Colors.grey.shade300),

                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),

                        // Content aligned to bottom
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (content.title != null)
                                  _buildTitle(content.title!),
                                if (content.subtitle != null)
                                  _buildSubtitle(content.subtitle!),
                                if (content.description != null)
                                  _buildDescription(content.description!),
                                if (content.buttonText != null &&
                                    content.buttonLink != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                      ),
                                      onPressed: () =>
                                          _launchUrl(content.buttonLink!),
                                      child: Text(
                                        content.buttonText!,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildAnimatedPageIndicator(currentPage, _contentList.length),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        description,
        style: GoogleFonts.openSans(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSubtitle(String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        subtitle,
        style: GoogleFonts.raleway(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }
}

Widget _buildAnimatedPageIndicator(int currentPage, int totalPages) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(totalPages, (index) {
      final isActive = index == currentPage;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: isActive ? 16 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: isActive ? Colors.blueAccent : Colors.grey,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }),
  );
}
