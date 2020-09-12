import org.junit.*;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;

import java.util.Arrays;

public class Lab02TestCountChar {
    

    @Test 
    public void verify_lab02() {
        String[] tests = { "Lets see how many times each char shows up in this one.", "aaa", "AAa", "012" };
		int [] expected;


        // Provide input
        for (int i = 0; i < tests.length; i += 1) {
            Label string = asciiData(true, tests[i]);  // true = 0 terminated
			Label counters = emptyWords(256);
            // Run the program
            randomizeRegisters(v0, v1, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, k0, k1, a0, a1, a2, a3, ra);
            randomizeRegisters(s0, s1, s2, s3, s4, s5, s6, s7);
			expected = new int[256];  // this should be initialised to 0s 
            for (int j = 0; j < tests[i].length(); j += 1)
			    expected[tests[i].charAt(j)] += 1;
//			for (int j = 0; j < 256; j += 1) {
//			    if (expected[j] > 0)
//                   System.out.println( "bin "+j+ " ,count " +  expected[j]);
//          }
            run("countChar", string, counters);
            int[] observed = getWords(counters, 0, 256);
            // Check the output:
//          for (int j = 0; j < 256; j += 1) {
//              if (observed[j] > 0)
//                  System.out.println( "bin "+j+ " ,count " +  observed[j]);
//          }
            Assert.assertArrayEquals("Unexpected counter values", expected, observed);
        }
    }
}
