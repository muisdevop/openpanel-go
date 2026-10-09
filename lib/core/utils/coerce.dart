/// Tolerant readers for server JSON.
///
/// Responses come from OpenPanel Cloud, older self-hosted builds, and proxies
/// that rewrite payloads. A hard `as num?` / `as String?` cast on one
/// unexpected field throws a TypeError that blanks the entire screen and then
/// gets retried forever; a wrong type on one value should cost that value, not
/// the page.
library;

double asDouble(Object? v, {double fallback = 0}) => switch (v) {
  final num n => n.toDouble(),
  final String s => double.tryParse(s) ?? fallback,
  _ => fallback,
};

int asInt(Object? v, {int fallback = 0}) => switch (v) {
  final num n => n.toInt(),
  final String s => int.tryParse(s) ?? fallback,
  _ => fallback,
};

/// Null stays null so "the server didn't say" is distinguishable from "the
/// server said an empty string".
String? asString(Object? v) => switch (v) {
  null => null,
  final String s => s,
  final Object o => o.toString(),
};
