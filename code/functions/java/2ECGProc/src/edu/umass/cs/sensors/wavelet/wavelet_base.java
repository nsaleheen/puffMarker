
package edu.umass.cs.sensors.wavelet;



/**
 *

  <p>
  Wavelet base class

  <p>
  The wavelet base class supplies the common functions
  <tt>power2</tt> and <tt>log2</tt> and defines the
  abstract methods for the derived classes.

@author Ian Kaplan   

@see <i>Wavelets Made Easy by Yves Nieverglt, Birkhauser, 1999</i>


 */
abstract class wavelet_base {

  /**
   *
     Abstract function for calculating a wavelet function.

     @param values
        Calculate the wavelet function from the <tt>values</tt>
        array.
   */
  abstract public void wavelet_calc( double[] values );

  /**
   *
     Print the wavelet function result.

   */
  abstract public void pr();

  abstract public void inverse();

}  // wavelet_interface
