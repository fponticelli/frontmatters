package frontmatter;

using thx.Options;
using thx.Semigroup;
using thx.Strings;
using thx.Validation;
// import thx.Validation.*;
import haxe.ds.Either;
import haxe.ds.Option;

class FrontMatter<E, T> {
  var parseData: String -> Validation<E, T>;
  var semigroup: E -> E -> E;
  var pattern: String;
  public function new(parseData: String -> Validation<E, T>, semigroup: E -> E -> E) {
    this.parseData = parseData;
    this.semigroup = semigroup;

    pattern =  '^(' +
          '\\ufeff?' + // TODO does it work?
          '(= yaml =|---)' +
          '$([\\s\\S]*?)' +
          '^(?:\\2|.{3})' +
          '$' +
          '\\r?' +
          '(?:\\n)?)';
  }

  public function parse(value: String): Validation<E, FrontMatterResult<T>> {
    var lines = (~/(\r?\n)/).split(value),
        ereg = new EReg(pattern, "m");
    return if(lines[0].hasContent() && (~/= yaml =|---/).match(lines[0]) && ereg.match(value)) {
      var yaml = ereg.matched(3);
      var body = ereg.matchedRight();
      Validation.val2(
        function(attributes, body) {
          return {
            attributes: Some(attributes),
            body: body
          };
        },
        parseData(yaml),
        Validation.success(body.hasContent() ? Some(body) : None),
        semigroup
      );
    } else {
      Validation.success({ body: value.hasContent() ? Some(value) : None, attributes: None });
    }
  }

  public static function withParser<T>(parseDynamic: Dynamic -> Validation<String, T>): String -> Validation<String, FrontMatterResult<T>> {
    var parser = new FrontMatter(parseObject(parseDynamic), function(a, b) return '$a,\n$b');
    return parser.parse;
  }

  public static function parseObject<T>(parseObject: Dynamic -> Validation<String, T>): String -> Validation<String, T> {
    return function(value: String) {
      return FrontMatter.parseYamlToObject(value).flatMapV(parseObject);
    };
  }

  public static function parseYamlToObject(value: String): Validation<String, {}> {
    return try {
      Validation.success(yaml.Yaml.parse(value, yaml.Parser.options().useObjects()));
    } catch(e: Dynamic) {
      Validation.failure(Std.string(e));
    };
  }

  public static function unsafeParse(value: String): { body: Null<String>, attributes: Dynamic } {
    return switch new FrontMatter(parseYamlToObject, function(a, b) return '$a,\n$b').parse(value) {
      case Left(e):
        throw e;
      case Right(result):
        {
          body: result.body.get(),
          attributes: result.attributes.get()
        };
    };
  }
}

typedef FrontMatterResult<T> = {
  body: Option<String>,
  attributes: Option<T>
}
