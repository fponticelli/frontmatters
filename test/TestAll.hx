import utest.UTest;

class TestAll {
  public static function main() {
    UTest.run([
      new TestFrontMatters(),
      new TestUnsafeFrontMatters()
    ]);
  }
}
