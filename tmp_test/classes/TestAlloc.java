public class TestAlloc {
  public int val() {return 30;}
  public static void main(String[] args) {
    //System.out.println("result should be 15, actual is:"+test_allocate(new TestAlloc()));
    System.out.println("result should be 15, actual is:"+test_allocate(5, true));
  }
  
  private static int test_allocate(int i, boolean uncommon) {
    //int i = i_obj.val;
    TestAlloc obj;
    if (uncommon) {
      obj = new UninitObj();
    } else {
      obj = new TestAlloc();
    }
    return obj.val()+i;
  }
  
  static class UninitObj extends TestAlloc {
    public int val() {return 10;}
  }
}
