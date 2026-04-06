import 'package:flutter_test/flutter_test.dart';
import 'package:clean_warden_flutter/clean_warden_flutter.dart';

class MockPresentationMember with WardenMember {
  @override
  WardenLayer get layer => WardenLayer.presentation;
}

class MockDomainMember with WardenMember {
  @override
  WardenLayer get layer => WardenLayer.domain;
}

class MockDataModel {}

class MockDomainEntity {}

class MockNetworkResponse {}

void main() {
  setUp(() {
    WardenConfig.setup(const WardenConfig(mode: LogMode.strictCrash));
  });

  group('WardenEngine.check', () {
    test('throws exception when Presentation layer receives a Model', () {
      final target = MockPresentationMember();
      final data = MockDataModel();

      expect(
        () => WardenEngine.check(target, data),
        throwsA(isA<WardenViolationException>()),
      );
    });

    test(
      'does NOT throw exception when Presentation layer receives an Entity',
      () {
        final target = MockPresentationMember();
        final data = MockDomainEntity();

        expect(() => WardenEngine.check(target, data), returnsNormally);
      },
    );

    test('throws exception when Domain layer receives a Response', () {
      final target = MockDomainMember();
      final data = MockNetworkResponse();

      expect(
        () => WardenEngine.check(target, data),
        throwsA(isA<WardenViolationException>()),
      );
    });
  });

  group('SensitiveDataMasker', () {
    test('masks password in data string', () {
      final message = 'Exception in Login: password: "superSecretPassword123"';
      final masked = SensitiveDataMasker.mask(message);
      expect(masked.contains('superSecretPassword123'), isFalse);
      expect(masked.contains('***'), isTrue);
    });
  });
}
