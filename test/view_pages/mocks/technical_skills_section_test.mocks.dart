// Mocks generated by Mockito 5.4.2 from annotations
// in avantswift_portfolio/test/view_pages/technical_skills_section_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:avantswift_portfolio/controllers/view_controllers/technical_skills_controller.dart'
    as _i6;
import 'package:avantswift_portfolio/models/TSkill.dart' as _i3;
import 'package:avantswift_portfolio/reposervice/tskill_repo_services.dart'
    as _i2;
import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:flutter/material.dart' as _i7;
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

class _FakeTSkillRepoService_0 extends _i1.SmartFake
    implements _i2.TSkillRepoService {
  _FakeTSkillRepoService_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [TSkill].
///
/// See the documentation for Mockito's code generation for more information.
class MockTSkill extends _i1.Mock implements _i3.TSkill {
  MockTSkill() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set creationTimestamp(_i4.Timestamp? _creationTimestamp) =>
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
  _i5.Future<bool> create(String? id) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [id],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
}

/// A class which mocks [TechnicalSkillsController].
///
/// See the documentation for Mockito's code generation for more information.
class MockTechnicalSkillsController extends _i1.Mock
    implements _i6.TechnicalSkillsController {
  MockTechnicalSkillsController() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TSkillRepoService get tSkillRepoService => (super.noSuchMethod(
        Invocation.getter(#tSkillRepoService),
        returnValue: _FakeTSkillRepoService_0(
          this,
          Invocation.getter(#tSkillRepoService),
        ),
      ) as _i2.TSkillRepoService);
  @override
  _i5.Future<List<_i7.Image>> getTechnicalSkillImages() => (super.noSuchMethod(
        Invocation.method(
          #getTechnicalSkillImages,
          [],
        ),
        returnValue: _i5.Future<List<_i7.Image>>.value(<_i7.Image>[]),
      ) as _i5.Future<List<_i7.Image>>);
  @override
  _i5.Future<_i7.Image?> getCentralImage() => (super.noSuchMethod(
        Invocation.method(
          #getCentralImage,
          [],
        ),
        returnValue: _i5.Future<_i7.Image?>.value(),
      ) as _i5.Future<_i7.Image?>);
}