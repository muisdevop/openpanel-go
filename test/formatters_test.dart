import 'package:flutter_test/flutter_test.dart';
import 'package:openpanel_go/core/utils/formatters.dart';

/// Fmt/parseApiDate/urlHost sit under every KPI card, chart label and project
/// row but had no test file. These pin the edges that are easy to break and
/// silent when wrong: the divide-by-zero guard, the UTC-vs-local parsing fork,
/// and the malformed-URL fallback that used to crash the switcher.
void main() {
  group('Fmt.change', () {
    test('guards the undefined cases instead of producing NaN/Infinity', () {
      // previous == 0 is the common "new project, no prior window" case; an
      // unguarded divide would render "∞%" or "NaN%" on a KPI card.
      expect(Fmt.change(5, 0), isNull);
      expect(Fmt.change(0, 0), isNull);
      expect(Fmt.change(null, 10), isNull);
      expect(Fmt.change(10, null), isNull);
    });

    test('is a signed percentage when defined', () {
      expect(Fmt.change(150, 100), 50.0);
      expect(Fmt.change(50, 100), -50.0);
      expect(Fmt.change(100, 100), 0.0);
    });
  });

  group('Fmt.compact', () {
    test('null renders an em dash, not "0" or a crash', () {
      expect(Fmt.compact(null), '–');
    });

    test('below 10k stays fully spelled, integral vs fractional', () {
      expect(Fmt.compact(999), '999');
      expect(Fmt.compact(1234), '1,234');
      expect(Fmt.compact(1234.5), '1,234.5');
      expect(Fmt.compact(-58), '-58');
    });

    test('at or above 10k abbreviates', () {
      expect(Fmt.compact(15000), contains('K'));
    });
  });

  test('Fmt.percent / Fmt.duration', () {
    expect(Fmt.percent(null), '–');
    expect(Fmt.percent(33.33), '33.3%');
    expect(Fmt.percent(33.33, digits: 0), '33%');

    expect(Fmt.duration(null), '–');
    expect(Fmt.duration(45), '45s');
    expect(Fmt.duration(60), '1m 0s');
    expect(Fmt.duration(74), '1m 14s');
    expect(Fmt.duration(3661), '1h 1m');
  });

  group('parseApiDate', () {
    test('a zone-less string is UTC when assumeUtc, local otherwise', () {
      final utc = parseApiDate('2026-10-08 13:00:00');
      expect(utc, isNotNull);
      expect(utc!.isUtc, isTrue);
      expect(utc.year, 2026);
      expect(utc.month, 10);
      expect(utc.day, 8);
      expect(utc.hour, 13);

      final local = parseApiDate('2026-10-08T13:00:00', assumeUtc: false);
      expect(local, isNotNull);
      expect(local!.isUtc, isFalse);
    });

    test('an explicit offset is respected, not re-assumed', () {
      final z = parseApiDate('2026-10-08T13:00:00Z');
      expect(z!.isUtc, isTrue);
      final plus = parseApiDate('2026-10-08T13:00:00+02:00');
      expect(plus!.toUtc().hour, 11);
    });

    test('epoch seconds and epoch millis reach the same instant', () {
      final secs = parseApiDate(1700000000);
      final millis = parseApiDate(1700000000000);
      expect(secs, isNotNull);
      expect(secs, millis);
      expect(secs!.isUtc, isTrue);
    });

    test('empty / garbage / already-a-DateTime', () {
      expect(parseApiDate(''), isNull);
      expect(parseApiDate('not a date'), isNull);
      expect(parseApiDate(null), isNull);
      final d = DateTime.utc(2026, 1, 2);
      expect(parseApiDate(d), d);
    });
  });

  group('urlHost', () {
    test('extracts the host from a well-formed URL', () {
      expect(urlHost('https://api.example.com/v1'), 'api.example.com');
      expect(urlHost('http://10.0.2.2:8000'), '10.0.2.2');
    });

    test('falls back to the raw string instead of throwing', () {
      // A project row saved by an old build with a host-less value used to
      // crash the switcher via Uri.parse; the fallback keeps it renderable.
      expect(urlHost('not a url at all'), 'not a url at all');
      expect(urlHost(''), '');
    });
  });
}
