class StringSamples {
  public static var bom(default, null) = loadTextFile("examples/bom.md");
  public static var complexYaml(default, null) = loadTextFile("examples/complex-yaml.md");
  public static var dashesSeperator(default, null) = loadTextFile("examples/dashes-seperator.md");
  public static var dotsEnding(default, null) = loadTextFile("examples/dots-ending.md");
  public static var missingBody(default, null) = loadTextFile("examples/missing-body.md");
  public static var noFrontMatter(default, null) = loadTextFile("examples/no-front-matter.md");
  public static var wrappedText(default, null) = loadTextFile("examples/wrapped-text.md");
  public static var yamlSeperator(default, null) = loadTextFile("examples/yaml-seperator.md");

  static function loadTextFile(file: thx.Path)
    return sys.io.File.getContent(file.toString());
}
