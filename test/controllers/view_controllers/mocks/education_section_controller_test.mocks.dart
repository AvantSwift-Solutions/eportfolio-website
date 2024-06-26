// Mocks generated by Mockito 5.4.2 from annotations
// in avantswift_portfolio/test/controllers/view_controllers/education_section_controller_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:avantswift_portfolio/models/Education.dart' as _i4;
import 'package:avantswift_portfolio/reposervice/education_repo_services.dart'
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

/// A class which mocks [EducationRepoService].
///
/// See the documentation for Mockito's code generation for more information.
class MockEducationRepoService extends _i1.Mock
    implements _i2.EducationRepoService {
  MockEducationRepoService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.Education>?> getAllEducation() => (super.noSuchMethod(
        Invocation.method(
          #getAllEducation,
          [],
        ),
        returnValue: _i3.Future<List<_i4.Education>?>.value(),
      ) as _i3.Future<List<_i4.Education>?>);
}

/// A class which mocks [Education].
///
/// See the documentation for Mockito's code generation for more information.
class MockEducation extends _i1.Mock implements _i4.Education {
  MockEducation() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set creationTimestamp(_i5.Timestamp? _creationTimestamp) =>
      super.noSuchMethod(
        Invocation.setter(
          #creationTimestamp,
          _creationTimestamp,
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
  set logoURL(String? _logoURL) => super.noSuchMethod(
        Invocation.setter(
          #logoURL,
          _logoURL,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set schoolName(String? _schoolName) => super.noSuchMethod(
        Invocation.setter(
          #schoolName,
          _schoolName,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set degree(String? _degree) => super.noSuchMethod(
        Invocation.setter(
          #degree,
          _degree,
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
  set major(String? _major) => super.noSuchMethod(
        Invocation.setter(
          #major,
          _major,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set grade(double? _grade) => super.noSuchMethod(
        Invocation.setter(
          #grade,
          _grade,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set gradeDescription(String? _gradeDescription) => super.noSuchMethod(
        Invocation.setter(
          #gradeDescription,
          _gradeDescription,
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
  _i3.Future<bool> create(String? id) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [id],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
}
