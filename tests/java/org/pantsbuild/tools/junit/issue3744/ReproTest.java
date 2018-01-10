package org.pantsbuild.tools.junit.issue3744;

import org.junit.Test;
import org.junit.runner.RunWith;

import junitparams.JUnitParamsRunner;
import junitparams.Parameters;

import static org.junit.Assert.assertNotNull;

@RunWith(JUnitParamsRunner.class)
public class ReproTest {
  private static int number(String num) {
    if ("42".equals(num)) {
      throw new NullPointerException("Oops!");
    }
    return Integer.parseInt(num);
  }

  private Object parameters() {
    return new Object[] {
      new Object[] {
        "Zaphod",
        number("2")
      },
      new Object[] {
        "Marvin",
        number("42")
      },
    };
  }

  @Test
  @Parameters(method = "parameters")
  public void testParameterized(String character, Integer number) {
    assertNotNull(character);
    assertNotNull(number);
  }
}
