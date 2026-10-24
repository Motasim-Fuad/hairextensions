/// Converts a decoded JSON body into a typed value. Must be a top-level or
/// static function when used with background parsing.
typedef JsonParser<T> = T Function(Object? json);
