// Mocks generated by Mockito 5.4.2 from annotations
// in avantswift_portfolio/test/controllers/view_controllers/project_section_controller_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:avantswift_portfolio/models/Project.dart' as _i4;
import 'package:avantswift_portfolio/reposervice/project_repo_services.dart'
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

/// A class which mocks [ProjectRepoService].
///
/// See the documentation for Mockito's code generation for more information.
class MockProjectRepoService extends _i1.Mock
    implements _i2.ProjectRepoService {
  MockProjectRepoService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.Project>?> getAllProjects() => (super.noSuchMethod(
        Invocation.method(
          #getAllProjects,
          [],
        ),
        returnValue: _i3.Future<List<_i4.Project>?>.value(),
      ) as _i3.Future<List<_i4.Project>?>);
  @override
  _i3.Future<Map<String, dynamic>?>? getDocumentById(String? documentId) =>
      (super.noSuchMethod(Invocation.method(
        #getDocumentById,
        [documentId],
      )) as _i3.Future<Map<String, dynamic>?>?);
  @override
  _i3.Future<void> updateDocumentField(
    String? documentId,
    String? fieldName,
    dynamic newValue,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateDocumentField,
          [
            documentId,
            fieldName,
            newValue,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [Project].
///
/// See the documentation for Mockito's code generation for more information.
class MockProject extends _i1.Mock implements _i4.Project {
  MockProject() {
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
  set name(String? _name) => super.noSuchMethod(
        Invocation.setter(
          #name,
          _name,
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
  set link(String? _link) => super.noSuchMethod(
        Invocation.setter(
          #link,
          _link,
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