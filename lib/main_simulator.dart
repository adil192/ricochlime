import 'package:ricochlime/main.dart' as common;
import 'package:simulator/simulator.dart';

Future<void> main() async {
  await common.main(
    initWidgetsBinding: SimulatorWidgetsFlutterBinding.ensureInitialized,
    runApp: runSimulatorApp,
  );
}
