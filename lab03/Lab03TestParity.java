import org.junit.*;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;

import java.util.Arrays;
import java.util.Random;


public class Lab03TestParity {
    
    @Before
    public void randomizeRegs() {
        // randomize registers to ensure the code does not depend on simulator initialised values or 
        //  illegal parameter passing
        randomizeRegisters(v0, v1, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, k0, k1, a0, a1, a2, a3, ra);
   	    // Set the saved registers to veryify they are preserved after the function call
        set(s0, 0x123);
        set(s1, 0x124);
        set(s2, 0x125);
        set(s3, 0x126);
        set(s4, 0x127);
        set(s5, 0x128);
        set(s6, 0x129);
        set(s7, 0x12a);
    }

    @Test 
    public void verify_parity() {
        int[] tests = {0, 1, 0x1000, 0x11, 0x220, 0x303, 0x82021015, 0xffffffff};
        String[] testMsgs = {"Parity of zero is 0",
                             "Parity of one is 1",
                             "Parity of a value with a single 1 bit is 1",
                             "Parity of a value with two bits set to 1 is 0",
                             "Wrong result. Check expected, received values.",
                             "Wrong result in full 32-bit input. Check expected, received values.",
                             "Wrong result. Check expected, received values.",
                             "Wrong result. Check expected, received values."
                            };
        for (int i = 0; i < tests.length; i += 1) {
            randomizeRegisters(v0, v1, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, k0, k1, a0, a1, a2, a3, ra);
            // Run the programm
            run("parity", tests[i]);
            //System.out.println(testMsgs[i] + " exp: " + Integer.bitCount(tests[i])%2==0 + " got: " + get(v0));
            // Check the output:
            Assert.assertEquals(testMsgs[i], (Integer.bitCount(tests[i])%2==0)? 0: 1, get(v0));
            // check registers
            Assert.assertEquals("$s0 should be preserved across subroutine calls", 0x123, get(s0));
            Assert.assertEquals("$s1 should be preserved across subroutine calls", 0x124, get(s1));
            Assert.assertEquals("$s2 should be preserved across subroutine calls", 0x125, get(s2));
            Assert.assertEquals("$s3 should be preserved across subroutine calls", 0x126, get(s3));
            Assert.assertEquals("$s4 should be preserved across subroutine calls", 0x127, get(s4));
            Assert.assertEquals("$s5 should be preserved across subroutine calls", 0x128, get(s5));
            Assert.assertEquals("$s6 should be preserved across subroutine calls", 0x129, get(s6));
            Assert.assertEquals("$s7 should be preserved across subroutine calls", 0x12a, get(s7));
        }
    }

    @Test 
    public void verify_blockParity() {
        int[] test = new int[32];
        int numTests = 12;
        int parity;
        Random randomeNum =  new Random();
        for (int i = 0; i < numTests; i += 1) {
            parity = 0;
            for (int j = 0; j < 32; j += 1) {
                test[j] = randomeNum.nextInt();
                parity = (parity << 1) | (Integer.bitCount(test[j])%2);
            }
            Label in = wordData(test);
            randomizeRegisters(v0, v1, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, k0, k1, a0, a1, a2, a3, ra);
            // Run the programm
            run("blockParity", in);
            Assert.assertEquals("Wrong result. Check expected, received values.", parity, get(v0));
            // check registers
            Assert.assertEquals("$s0 should be preserved across subroutine calls", 0x123, get(s0));
            Assert.assertEquals("$s1 should be preserved across subroutine calls", 0x124, get(s1));
            Assert.assertEquals("$s2 should be preserved across subroutine calls", 0x125, get(s2));
            Assert.assertEquals("$s3 should be preserved across subroutine calls", 0x126, get(s3));
            Assert.assertEquals("$s4 should be preserved across subroutine calls", 0x127, get(s4));
            Assert.assertEquals("$s5 should be preserved across subroutine calls", 0x128, get(s5));
            Assert.assertEquals("$s6 should be preserved across subroutine calls", 0x129, get(s6));
            Assert.assertEquals("$s7 should be preserved across subroutine calls", 0x12a, get(s7));
        }

    }

    @Test 
    public void verify_blockParity2() {
        int[] test = {0x80000000, 0x00000000, 0xc0001111, 0x88880008, 0x50000005, 0x44444444, 0xaaaa777c, 0x9d9d0009, 
              0x90000000, 0x00010000, 0xb0001111, 0x88880108, 0xc0000005, 0x44444445, 0x55557777, 0x9d9d0008, 
              0x80000000, 0x00000000, 0xc0001111, 0x88880008, 0x50000005, 0x44444444, 0xaaaa777c, 0x9d9d0009, 
              0x90000000, 0x00010000, 0xb0001111, 0x88880108, 0xc0000005, 0x44444445, 0x55557777, 0x9d9d0008};
        Label in = wordData(test);
        int parity;
        randomizeRegisters(v0, v1, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, k0, k1, a0, a1, a2, a3, ra);
        // Run the programm
        run("blockParity", in);
        Assert.assertEquals("Wrong result. Check expected, received values.", 0x92659265, get(v0));
    }
}
