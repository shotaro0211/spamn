import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:routemaster/routemaster.dart';
import 'package:spamn/ui/theme/default_theme.dart';

import 'ui/pages/answer_page.dart';
import 'ui/pages/create_page.dart';
import 'ui/pages/home_page.dart';

final routes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomePage(title: 'spamn')),
  '/:contractAddress/create': (info) =>
      const MaterialPage(child: CreatePage(title: 'create')),
  '/:contractAddress/:tokenId': (info) =>
      const MaterialPage(child: AnswerPage(title: 'answer'))
});

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(
    MaterialApp.router(
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) => routes),
      routeInformationParser: const RoutemasterParser(),
      theme: defaultTheme,
    ),
  );
}
