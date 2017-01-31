import utest.Assert;
import frontmatter.FrontMatter;
using thx.Strings;
import StringSamples.*;

class TestUnsafeFrontMatter {
  public function new() {}

  public function testYamlDelineatedByTripleDash() {
    var result = FrontMatter.unsafeParse(dashesSeperator);
    Assert.notNull(result.attributes);
    Assert.equals(result.attributes.title, 'Three dashes marks the spot');
    Assert.equals(result.attributes.tags.length, 3);

    Assert.notNull(result.body, 'should have a `body` key');
    Assert.isTrue(result.body.contains("don't break"), 'should match body');
    Assert.isTrue(result.body.contains('---'), 'should match body');
    Assert.isTrue(result.body.contains("Also this shouldn't be a problem"), 'should match body');
  }

  public function testYamlDelineatedByEqualYamlEqual() {
    var result = FrontMatter.unsafeParse(yamlSeperator);

    var meta = result.attributes;
    var body = result.body;

    Assert.equals(meta.title, "I couldn't think of a better name");
    Assert.equals(meta.description, 'Just an example of using `= yaml =`');
    Assert.isTrue(body.contains('Plays nice with markdown syntax highlighting'), 'should match body');
  }

  public function testYamlTerminatedByTripleDot() {
    var result = FrontMatter.unsafeParse(dotsEnding);

    var meta = result.attributes;
    var body = result.body;

    Assert.equals(meta.title, 'Example with dots document ending');
    Assert.equals(meta.description, 'Just an example of using `...`');
    Assert.isTrue(body.contains("It shouldn't break with ..."), 'should match body');
  }

  public function testNoFrontMatter() {
    var result = FrontMatter.unsafeParse('No front matter here');
    Assert.isNull(result.attributes, 'should not have attributes');
    Assert.equals(result.body, 'No front matter here');
  }

  public function testNoBody() {
    var result = FrontMatter.unsafeParse(missingBody);

    Assert.equals(result.attributes.title, 'Three dashes marks the spot');
    Assert.equals(result.attributes.tags.length, 3);
    Assert.isNull(result.body);
  }

  public function testWrappedTextInYaml() {
    var result = FrontMatter.unsafeParse(wrappedText);
    var folded = 'There once was a man from Darjeeling
Who got on a bus bound for Ealing
    It said on the door
    "Please don\'t spit on the floor"
So he carefully spat on the ceiling
';

    Assert.equals(Reflect.field(result.attributes, 'folded-text'), folded);
    Assert.isTrue(result.body.contains('Some crazy stuff going on up there'), 'should match body');
  }

  public function testWithBom() {
    var result = FrontMatter.unsafeParse(bom);
    Assert.equals(result.attributes.title, "Relax guy, I'm not hiding any BOMs");
  }

  public function testNoFrontMatterWithHr() {
    var result = FrontMatter.unsafeParse(noFrontMatter);
    Assert.equals(result.body, noFrontMatter);
  }

  public function testComplexYaml() {
    var result = FrontMatter.unsafeParse(complexYaml);
    Assert.isTrue(result.attributes, 'should have `attributes` key');
    Assert.equals(result.attributes.title, 'This is a title!');
    Assert.equals(result.attributes.contact, null);
    Assert.equals(result.attributes.match.toString(), '/pattern/gim');
  }
}
