// Mocks generated by Mockito 5.4.2 from annotations
// in avantswift_portfolio/test/controllers/view_controllers/recommendation_section_controller_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:avantswift_portfolio/models/Recommendation.dart' as _i4;
import 'package:avantswift_portfolio/reposervice/recommendation_repo_services.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [RecommendationRepoService].
///
/// See the documentation for Mockito's code generation for more information.
class MockRecommendationRepoService extends _i1.Mock
    implements _i2.RecommendationRepoService {
  MockRecommendationRepoService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.Recommendation>?> getAllRecommendations() =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllRecommendations,
          [],
        ),
        returnValue: _i3.Future<List<_i4.Recommendation>?>.value(),
      ) as _i3.Future<List<_i4.Recommendation>?>);
}

/// A class which mocks [Recommendation].
///
/// See the documentation for Mockito's code generation for more information.
class MockRecommendation extends _i1.Mock implements _i4.Recommendation {
  MockRecommendation() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set colleagueName(String? _colleagueName) => super.noSuchMethod(
        Invocation.setter(
          #colleagueName,
          _colleagueName,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set colleagueJobTitle(String? _colleagueJobTitle) => super.noSuchMethod(
        Invocation.setter(
          #colleagueJobTitle,
          _colleagueJobTitle,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set description(String? _description) => super.noSuchMethod(
        Invocation.setter(
          #description,
          _description,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set imageURL(String? _imageURL) => super.noSuchMethod(
        Invocation.setter(
          #imageURL,
          _imageURL,
        ),
        returnValueForMissingStub: null,
      );
  @override
  Map<String, dynamic> toMap() => (super.noSuchMethod(
        Invocation.method(
          #toMap,
          [],
        ),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);
  @override
  _i3.Future<void> create() => (super.noSuchMethod(
        Invocation.method(
          #create,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> delete() => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
