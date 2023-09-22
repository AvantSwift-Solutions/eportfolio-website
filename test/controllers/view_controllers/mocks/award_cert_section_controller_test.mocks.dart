// Mocks generated by Mockito 5.4.2 from annotations
// in avantswift_portfolio/test/controllers/view_controllers/award_cert_section_controller_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:avantswift_portfolio/models/AwardCert.dart' as _i4;
import 'package:avantswift_portfolio/reposervice/award_cert_repo_services.dart'
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

/// A class which mocks [AwardCertRepoService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAwardCertRepoService extends _i1.Mock
    implements _i2.AwardCertRepoService {
  MockAwardCertRepoService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.AwardCert>?> getAllAwardCert() => (super.noSuchMethod(
        Invocation.method(
          #getAllAwardCert,
          [],
        ),
        returnValue: _i3.Future<List<_i4.AwardCert>?>.value(),
      ) as _i3.Future<List<_i4.AwardCert>?>);
}

/// A class which mocks [AwardCert].
///
/// See the documentation for Mockito's code generation for more information.
class MockAwardCert extends _i1.Mock implements _i4.AwardCert {
  MockAwardCert() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set name(String? _name) => super.noSuchMethod(
        Invocation.setter(
          #name,
          _name,
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
  set link(String? _link) => super.noSuchMethod(
        Invocation.setter(
          #link,
          _link,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set source(String? _source) => super.noSuchMethod(
        Invocation.setter(
          #source,
          _source,
        ),
        returnValueForMissingStub: null,
      );
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
