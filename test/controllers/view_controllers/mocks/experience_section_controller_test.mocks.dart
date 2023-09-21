// Mocks generated by Mockito 5.4.2 from annotations
// in avantswift_portfolio/test/controllers/view_controllers/experience_section_controller_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:avantswift_portfolio/models/Experience.dart' as _i4;
import 'package:avantswift_portfolio/reposervice/experience_repo_services.dart'
    as _i2;
import 'package:cloud_firestore/cloud_firestore.dart' as _i5;
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

/// A class which mocks [ExperienceRepoService].
///
/// See the documentation for Mockito's code generation for more information.
class MockExperienceRepoService extends _i1.Mock
    implements _i2.ExperienceRepoService {
  MockExperienceRepoService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.Experience>?> getAllExperiences() => (super.noSuchMethod(
        Invocation.method(
          #getAllExperiences,
          [],
        ),
        returnValue: _i3.Future<List<_i4.Experience>?>.value(),
      ) as _i3.Future<List<_i4.Experience>?>);
}

/// A class which mocks [Experience].
///
/// See the documentation for Mockito's code generation for more information.
class MockExperience extends _i1.Mock implements _i4.Experience {
  MockExperience() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set jobTitle(String? _jobTitle) => super.noSuchMethod(
        Invocation.setter(
          #jobTitle,
          _jobTitle,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set companyName(String? _companyName) => super.noSuchMethod(
        Invocation.setter(
          #companyName,
          _companyName,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set location(String? _location) => super.noSuchMethod(
        Invocation.setter(
          #location,
          _location,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set startDate(_i5.Timestamp? _startDate) => super.noSuchMethod(
        Invocation.setter(
          #startDate,
          _startDate,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set endDate(_i5.Timestamp? _endDate) => super.noSuchMethod(
        Invocation.setter(
          #endDate,
          _endDate,
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
  set logoURL(String? _logoURL) => super.noSuchMethod(
        Invocation.setter(
          #logoURL,
          _logoURL,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set index(int? _index) => super.noSuchMethod(
        Invocation.setter(
          #index,
          _index,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set employmentType(String? _employmentType) => super.noSuchMethod(
        Invocation.setter(
          #employmentType,
          _employmentType,
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
