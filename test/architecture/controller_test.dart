import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money/utils/architecture.dart';

void main() {
  group(
    'Architecture',
    () {
      repository(MockRepository());
      final controller = MockController();
      final feature = MockFeature();

      test(
        'repositories available',
        () {
          expect(repositories, isA<Map<Type, Repository>>());
        },
      );
      test(
        'services available',
        () {
          expect(services, isA<Map<Type, Object>>());
        },
      );

      test(
        'depend should inject/use repository',
        () {
          /// injection
          expect(repositories.containsKey(MockRepository), true);

          /// usage
          expect(repository, isA<MockRepository>());
        },
      );

      test(
        'repository should use StreamControllers for state/data',
        () {
          // expectLater(repository.dark.stream, emitsInOrder([true, false]));
          // repository.dark.add(true);
          // repository.dark.add(false);
        },
      );

      test(
        'creating a repository instance auto-registers it',
        () {
          expect(
            repositories[MockRepository],
            repository,
          );
        },
      );

      test(
        'controller depends on repository',
        () {
          expect(
            controller.depend<MockRepository>(),
            isA<Repository>(),
          );
        },
      );

      test(
        'controller listens to repository',
        () {
          expect(controller.dark, emitsInOrder([true]));
          // repository.dark.add(true);
        },
      );

      test(
        'controller disposes',
        () {
          controller.dispose();
          expect(
            controller.disposed,
            true,
          );
        },
      );
      test('feature is created', () {
        expect(feature, isA<MockFeature>());
      });
      testWidgets(
        'feature',
        (tester) async {
          // tester.any(feature.createElement());
        },
      );
    },
  );
}

/// MOCKS

class MockController extends Controller {
  late MockRepository mockRepository = depend();
  bool get dark => mockRepository.dark;
}

class MockRepository extends Repository {
  bool dark = false;
}

class MockFeature extends UI<MockController> {
  const MockFeature({super.key});

  @override
  MockController create() => MockController();
  @override
  Widget build(BuildContext context, MockController controller) => Container();
}
