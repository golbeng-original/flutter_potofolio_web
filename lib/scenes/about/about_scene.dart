import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/about_provider.dart';

import '/components/top_title.dart';

import './components/about_contant_widget.dart';
import './components/about_content_widget.dart';
import './components/about_history_widget.dart';
import './components/about_profile_image_widget.dart';
import './components/about_profile_name_widget.dart';

class AboutScene extends StatefulWidget {
  const AboutScene({Key? key});

  @override
  _AboutSceneState createState() => _AboutSceneState();
}

class _AboutSceneState extends State<AboutScene> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {

      var aboutProvider = context.read<AboutProvider>();
      await aboutProvider.requestAbout(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final aboutProvider = context.watch<AboutProvider>();
    final aboutData = aboutProvider.aboutData;

    return Scaffold(
      body: Column(
        children: [
          const TopTitleWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: _createLayout(aboutData),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createLayout(AboutData aboutData) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth <= 764) {
        return _createMoblieSize(aboutData);
      } else {
        return _createNormalSize(aboutData);
      }
    });
  }

  Widget _createMoblieSize(AboutData aboutData) {
    return Column(
      children: [
        AboutProfileImageWidget(
          profileImage: aboutData.profileImage,
        ),
        const SizedBox(height: 32),
        AboutProfileNameWidget(
          profileName: aboutData.profileName,
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AboutProfileContantWidget(
            contant: aboutData.contact,
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AboutContentWidget(
            content: aboutData.introuceContent,
          ),
        ),
        const SizedBox(height: 32),
        AboutHistoryWidget(
          histroyList: aboutData.historyList,
        )
      ],
    );
  }

  Widget _createNormalSize(AboutData aboutData) {
    return Column(
      children: [
        _createTopRow(aboutData),
        _createBottomRow(aboutData),
      ],
    );
  }

  Widget _createTopRow(AboutData aboutData) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 80,
        vertical: 32,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AboutProfileImageWidget(
            profileImage: aboutData.profileImage,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 32),
              child: AboutContentWidget(
                content: aboutData.introuceContent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createBottomRow(AboutData aboutData) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 80,
        vertical: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 240,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: AboutProfileNameWidget(
                    profileName: aboutData.profileName,
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: AboutProfileContantWidget(
                    contant: aboutData.contact,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 32),
              child: AboutHistoryWidget(
                histroyList: aboutData.historyList,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
