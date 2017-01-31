import utest.UTest;

class TestAll {
  public static function main() {
    UTest.run([
      new TestFrontMatter(),
      new TestUnsafeFrontMatter()
    ]);
  }
}
