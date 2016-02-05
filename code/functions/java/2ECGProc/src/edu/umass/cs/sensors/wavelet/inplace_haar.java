
package edu.umass.cs.sensors.wavelet;


/**
 *
  
<h4>
   Copyright and Use
</h4>

<p>
   You may use this source code without limitation and without
   fee as long as you include:
</p>
<blockquote>
     This software was written and is copyrighted by Ian Kaplan, Bear
     Products International, www.bearcave.com, 2001.
</blockquote>
<p>
   This software is provided "as is", without any warrenty or
   claim as to its usefulness.  Anyone who uses this source code
   uses it at their own risk.  Nor is any support provided by
   Ian Kaplan and Bear Products International.
<p>
   Please send any bug fixes or suggested source changes to:
<pre>
     iank@bearcave.com
</pre>

<p>
   To generate the documentation for the <tt>wavelets</tt> package
   using Sun Microsystem's <tt>javadoc</tt> use the command
<pre>
        javadoc -private wavelets
</pre>

<p>
   The inplace_haar class calculates an in-place Haar wavelet
   transform.  By in-place it's ment that the result occupies the same
   array as the data set on which the Haar transform is calculated.

<p>
   The Haar wavelet calculation is awkward when the data values are
   not an even power of two.  This is especially true for the in-place
   Haar.  So here we only support data that falls into an even power
   of two.

<p>
   The sad truth about computation is that the time-space tradeoff
   is an iron rule.  The Haar in-place wavelet transform is more 
   memory efficient, but it also takes more computation.

<p>
   The algorithm used here is from <i>Wavelets Made Easy</i>
   by Yves Nievergelt, section 1.4.  The in-place transform
   replaces data values when Haar values and coefficients.
   This algorithm uses a butterfly pattern, where the indices
   are calculated by the following:

<pre>
   for (l = 0; l < log<sub>2</sub>( size ); l++) {
     for (j = 0; j < size; j++) {
        <b>a</b><sub>j</sub> = 2<sup>l</sup> * (2 * j);
        <b>c</b><sub>j</sub> = 2<sup>l</sup> * ((2 * j) + 1);
        if (c<sub>j</sub> >= size)
	  break;
     } <i>// for j</i>
   } <i>// for l</i>
</pre>

<p>
   If there are 16 data elements (indexed 0..15), these loops will
   generate the butterfly index pattern shown below, where the first
   element in a pair is <b>a</b><sub>j</sub>, the Haar value and the
   second element is <b>c</b><sub>j</sub>, the Haar coefficient.

<pre>
{0, 1} {2, 3} {4, 5} {6, 7} {8, 9} {10, 11} {12, 13} {14, 15}
{0, 2} {4, 6} {8, 10} {12, 14}
{0, 4} {8, 12}
{0, 8}
</pre>

<p>
  Each of these index sets represents a Haar wavelet frequency (here
  they are listed from the highest frequency to the lowest).

  @author Ian Kaplan

 */
public class inplace_haar extends wavelet_base {
  /** result of calculating the Haar wavelet */
  private double[] wavefx;
  /** initially false: true means wavefx is ordered by frequency */
  boolean isOrdered = false;

  /**
    Set the wavefx reference variable to the data vector.  Also,
    initialize the isOrdered flag to false.  This indicates that the
    Haar coefficients have not been calculated and ordered by
    frequency.
   */
  public void setWavefx( double[] vector )
  {
    if (vector != null) {
      wavefx = vector;
      isOrdered = false;
    }
  }

  public void setIsOrdered() { isOrdered = true; }

  /**
   *
<p>
   Calculate the in-place Haar wavelet function.  The
   data values are overwritten by the coefficient result, which
   is pointed to by a local reference (<tt>wavefx</tt>).

<p>
   The in-place Haar transform leaves the coefficients in a butterfly
   pattern.  The Haar transform calculates a Haar value
   (<tt><b>a</b><tt>) and a coefficient (<tt>c</tt>) from the forumla
   shown below.

<pre>
  <b>a</b><sub>i</sub> = (v<sub>i</sub> + v<sub>i+1</sub>)/2
   c<sub>i</sub> = (v<sub>i</sub> - v<sub>i+1</sub>)/2
</pre>

<p>

   In the in-place Haar transform the values for <tt><b>a</b></tt> and
   <tt>c</tt> replace the values for v<sub>i</sub> and
   v<sub>i+1</sub>. Subsequent passes calculate new <tt><b>a</b></tt>
   and <tt>c</tt> values from the previous
   <tt><b>a</b><sub>i</sub></tt> and <tt><b>a</b><sub>i+1</sub></tt>
   values.  The produces the butterfly pattern outlined below.

<pre>

v<sub>0</sub> v<sub>1</sub> v<sub>2</sub> v<sub>3</sub> v<sub>4</sub> v<sub>5</sub> v<sub>6</sub> v<sub>7</sub>

<b>a</b><sub>0</sub> c<sub>0</sub> <b>a</b><sub>0</sub> c<sub>0</sub> <b>a</b><sub>0</sub> c<sub>0</sub> <b>a</b><sub>0</sub> c<sub>0</sub>

<b>a</b><sub>1</sub> c<sub>0</sub> c<sub>1</sub> c<sub>0</sub> <b>a</b><sub>1</sub> c<sub>0</sub> c<sub>1</sub> c<sub>0</sub>

<b>a</b><sub>2</sub> c<sub>0</sub> c<sub>1</sub> c<sub>0</sub> c<sub>2</sub> c<sub>0</sub> c<sub>1</sub> c<sub>0</sub>

</pre>

<p> 
   For example, Haar wavelet the calculation with the data set 
   {3, 1, 0, 4, 8, 6, 9, 9} is shown below.  Bold type
   denotes an <b>a</b> value which will be used in the 
   next sweep of the calculation.

<pre>
3  1  0  4  8  6  9  9

<b>2</b>  1  <b>2</b> -2  <b>7</b>  1  <b>9</b>  0

<b>2</b>  1  0 -2  <b>8</b>  1 -1  0

<b>5</b>  1  0 -2 -3  1 -1  0
</pre>


   @param values
      An array of double data values from which the
      Haar wavelet function will be calculated.  The
      number of values must be a power of two.

   */
  public void wavelet_calc( double[] values ) {
    int len = values.length;
    setWavefx( values );

    if (len > 0) {
      byte log = binary.log2( len );
      
      len = binary.power2( log );  // calculation must be on 2 ** n values

      for (byte l = 0; l < log; l++) {
	int p = binary.power2( l );
	for (int j = 0; j < len; j++) {
	  int a_ix = p * (2 * j);
	  int c_ix = p * ((2 * j) + 1);

	  if (c_ix < len) {
	    double a = (values[a_ix] + values[c_ix]) / 2;
	    double c = (values[a_ix] - values[c_ix]) / 2;
	    values[a_ix] = a;
	    values[c_ix] = c;
	  }
	  else {
	    break;
	  }
	} // for j
      } // for l
    }
  } // wavelet_calc


  /**
   *

    Recursively calculate the Haar spectrum, replacing data in the
    original array with the calculated averages.

   */
  private void spectrum_calc(double[] values, 
			     int start, 
			     int end ) {
    int j;
    int newEnd;
    if (start > 0) {
      j = start-1;
      newEnd = end >> 1;
    }
    else {
      j = end-1;
      newEnd = end;
    }

    for (int i = end-1; i > start; i = i - 2, j--) {
      values[j] = (values[i-1] + values[i]) / 2;
    } // for
    

    if (newEnd > 1) {
      int newStart = newEnd >> 1;
      spectrum_calc(values, newStart, newEnd);
    }
  } // spectrum_calc


  /**
   *

<p>
   Calculate the Haar wavelet spectrum

<p> 
   Wavelet calculations sample a signal via a window.  In the case of
   the Haar wavelet, this window is a rectangle.  The signal is
   sampled in passes, using a window of a wider width for each pass.
   Each sampling can be thought of as generating a spectrum of the
   original signal at a particular resolution.

<p>
   In the case of the Haar wavelet, the window is initially two values
   wide.  The first spectrum has half as many values as the original
   signal, where each new value is the average of two values from 
   the original signal.

<p>
   The next spectrum is generated by increasing the window
   width by a factor of two and averaging four elements.
   The third spectrum is generated by increasing the
   window size to eight, etc...  Note that each  of these
   averages can be formed from the previous average.

<p>
   For example, if the initial data set is
<pre>
    { 32.0, 10.0, 20.0, 38.0, 37.0, 28.0, 38.0, 34.0,
      18.0, 24.0, 18.0,  9.0, 23.0, 24.0, 28.0, 34.0 }
</pre>
<p>
    The first spectrum is constructed by averaging
    elements {0,1}, {2,3}, {4,5} ...
</p>
<pre>
    {21, 29, 32.5, 36, 21, 13.5, 23.5, 31} <i>1<sup>st</sup> spectrum</i>
</pre>
<p>
    The second spectrum is constructed by averaging elements
    averaging elements {0,1}, {2,3} in the first spectrum:
</p>
<pre>
    {25, 34.25, 17.25, 27.25}           <i>2<sup>nd</sup> spectrum</i>

    {29.625, 22.25}                     <i>3<sup>ed</sup> spectrum</i>

    {25.9375}                           <i>4<sup>th</sup> spectrum</i>
</pre>
<p>
    Note that we can calculate the Haar spectrum "in-place", by
    replacing the original data values with the spectrum values:
<pre>
    {0, 
     25.9375, 
     29.625, 22.25, 
     25, 34.25, 17.25, 27.25,
     21, 29, 32.5, 36, 21, 13.5, 23.5, 31}
</pre>
<p>
    The spetrum is ordered by increasing frequency.
    This is the same ordering used for the Haar coefficients.
    Keeping to this ordering allows the same code to be applied
    to both the Haar spectrum and a set of Haar coefficients.
</p>
<p>
    This function will destroy the original data.
    When the Haar spectrum is calculated information is lost.
    For example, without the Haar coefficients, which provide the
    difference between the two numbers that form the average, there
    may be several numbers which satisify the equation
<pre>
   <b>a</b><sub>i</sub> = (v<sub>j</sub> + v<sub>j+1</sub>)/2
</pre>

<p>
  For 2<sup>n</sup> initial elements, there will be
  2<sup>n</sup> - 1 results.  For example:
</p>
<pre>
    512 : initial length
    256 : 1st spectrum
    128 : 2nd spectrum
     64 : 3ed spectrum
     32 : 4th spectrum
     16 : 5th spectrum
      8 : 6th spectrum
      4 : 7th spectrum
      2 : 8th spectrum
      1 : 9th spectrum (overall average)
</pre>

<p>
  Since this is an in-place algorithm, the result is
  returned in the values argument.
</p>


   */
  public void wavelet_spectrum( double[] values ) {
    int len = values.length;

    if (len > 0) {
      setWavefx( values );
      byte log = binary.log2( len );
      
      len = binary.power2( log );  // calculation must be on 2 ** n values

      int srcStart = 0;
      spectrum_calc(values, srcStart, len);
      values[0] = 0;
    }
  } // wavelet_vals


  /**
   *

     Print the result of the Haar wavelet function.

   */
  public void pr() {
    if (wavefx != null) {
      int len = wavefx.length;

      System.out.print("{");
      for (int i = 0; i < len; i++) {
	System.out.print( wavefx[i] );
	if (i < len-1)
	  System.out.print(", ");
      }
      System.out.println("}");
    }
  } // pr


  /**
   *
<p>
     Print the Haar value and coefficient showing the 
     ordering.  The Haar value is printed first, followed
     by the coefficients in increasing frequency.  An
     example is shown below.  The Haar value is shown in
     bold.  The coefficients are in normal type.

<p>
    Data set
<pre>
    { 32.0, 10.0, 20.0, 38.0,
      37.0, 28.0, 38.0, 34.0,
      18.0, 24.0, 18.0,  9.0, 
      23.0, 24.0, 28.0, 34.0 }
</pre>
<p>
    Ordered Haar transform:
<pre>
   <b>25.9375</b>
   3.6875
   -4.625 -5.0
   -4.0 -1.75 3.75 -3.75
   11.0 -9.0 4.5 2.0 -3.0 4.5 -0.5 -3.0
</pre>

   */
  public void pr_ordered() {
    if (wavefx != null) {
      int len = wavefx.length;

      if (len > 0) {
	System.out.println(wavefx[0]);

	int num_in_freq = 1;
	int cnt = 0;
	for (int i = 1; i < len; i++) {
	  System.out.print(wavefx[i] + " ");
	  cnt++;
	  if (cnt == num_in_freq) {
	    System.out.println();
	    cnt = 0;
	    num_in_freq = num_in_freq * 2;
	  }
	}
      }
    }
  } // pr_ordered


  /**
   *
<p>

     Order the result of the in-place Haar wavelet function,
     referenced by wavefx.  As noted above in the documentation for
     <tt>wavelet_calc()</tt>, the in-place Haar transform leaves the
     coefficients in a butterfly pattern.  This can be awkward for
     some calculations.  The <tt>order</tt> function orders the
     coefficients by frequency, from the lowest frequency to the
     highest.  The number of coefficients for each frequency band
     follow powers of two (e.g., 1, 2, 4, 8 ... 2<sup>n</sup>).
     An example of the coefficient sort performed by the <tt>order()</tt>
     function is shown below;

<pre>
before: <b>a</b><sub>2</sub> c<sub>0</sub> c<sub>1</sub> c<sub>0</sub> c<sub>2</sub> c<sub>0</sub> c<sub>1</sub> c<sub>0</sub>

after:  <b>a</b><sub>2</sub> c<sub>2</sub> c<sub>1</sub> c<sub>1</sub> c<sub>0</sub> c<sub>0</sub> c<sub>0</sub> c<sub>0</sub>

</pre>

<p>
     The results in the same ordering as the ordered Haar wavelet
     transform.

<p>
     If the number of elements is 2<sup>n</sup>, then the largest
     number of coefficients will be 2<sup>n-1</sup>.  Each of the
     coefficients in the largest group is separated by one element
     (which contains other coefficients).  This algorithm pushes these
     together so they are not separated.  These coefficients now make
     up half of the array.  The remaining coefficients take up the
     other half.  The next frequency down is also separated by one
     element.  These are pushed together taking up half of the half.
     The algorithm keeps going until only one coefficient is left.

<p>
     As with wavelet_calc above, this algorithm assumes that
     the number of values is a power of two.

   */
  public void order() {
    if (wavefx != null) {

      int half = 0;
      for (int len = wavefx.length; len > 1; len = half) {
	half = len / 2;
	int skip = 1;
	for (int dest = len - 2; dest >= half; dest--) {
	  int src = dest - skip;
	  double tmp = wavefx[src];
	  for (int i = src; i < dest; i++)
	    wavefx[i] = wavefx[i+1];
	  wavefx[dest] = tmp;
	  skip++;
	} // for dest
      } // for len

      isOrdered = true;
    } // if
  } // order()


  /**
   *
<p>
     Regenerate the data from the Haar wavelet function.

<p>

     There is no information loss in the Haar function.  The original
     data can be regenerated by reversing the calculation.  Given
     a Haar value, <b>a</b> and a coefficient <b>c</b>, two Haar
     values can be generated

<pre>
        <b>a</b><sub>i</sub>  = a + c;
        <b>a</b><sub>i+1</sub> = a - c;
</pre>

<p>
     The transform is calculated from the low frequency coefficients
     to the high frequency coefficients.  An example is shown below
     for the result of the ordered Haar transform.  Note that the
     values are in bold and the coefficients are in normal type.

<p>
To regenerate {<a>a</b><sub>1</sub>, <a>a</b><sub>2</sub>, <a>a</b><sub>3</sub>, <a>a</b><sub>4</sub>, <a>a</b><sub>5</sub>, <a>a</b><sub>6</sub>, <a>a</b><sub>7</sub>, <a>a</b><sub>8</sub>} from
<pre>
<b>a</b><sub>1</sub>
c<sub>1</sub>
c<sub>2</sub> c<sub>3</sub>
c<sub>4</sub> c<sub>5</sub> c<sub>6</sub> c<sub>7</sub>
</pre>
<p>
   The inverse Haar transform is applied:

<pre>
<b>a</b><sub>1</sub> = <b>a</b><sub>1</sub> + c<sub>1</sub>
<b>a</b><sub>2</sub> = <b>a</b><sub>1</sub> - c<sub>1</sub>

<b>a</b><sub>1</sub> = <b>a</b><sub>1</sub> + c<sub>2</sub>
<b>a</b><sub>2</sub> = <b>a</b><sub>1</sub> - c<sub>2</sub>
<b>a</b><sub>3</sub> = <b>a</b><sub>2</sub> + c<sub>3</sub>
<b>a</b><sub>4</sub> = <b>a</b><sub>2</sub> - c<sub>3</sub>

<b>a</b><sub>1</sub> = <b>a</b><sub>1</sub> + c<sub>4</sub>
<b>a</b><sub>2</sub> = <b>a</b><sub>1</sub> - c<sub>4</sub>
<b>a</b><sub>3</sub> = <b>a</b><sub>2</sub> + c<sub>5</sub>
<b>a</b><sub>4</sub> = <b>a</b><sub>2</sub> - c<sub>5</sub>
<b>a</b><sub>5</sub> = <b>a</b><sub>3</sub> + c<sub>6</sub>
<b>a</b><sub>6</sub> = <b>a</b><sub>3</sub> - c<sub>6</sub>
<b>a</b><sub>7</sub> = <b>a</b><sub>4</sub> + c<sub>7</sub>
<b>a</b><sub>8</sub> = <b>a</b><sub>4</sub> - c<sub>7</sub>
</pre>
<p>
    For example:

<pre>
<b>5.0</b>
-3.0
0.0 -1.0
1.0 -2.0 1.0 0.0

<b>5.0</b>+(-3), <b>5.0</b>-(-3) = {<b>2</b> <b>8</b>}

<b>2</b>+0, <b>2</b>-0, <b>8</b>+(-1), <b>8</b>-(-1) = {<b>2, 2, 7, 9</b>}

<b>2</b>+1, <b>2</b>-1, <b>2</b>+(-2), <b>2</b>-(-2), <b>7</b>+1, <b>7</b>-1, <b>9</b>+0, <b>9</b>-0 = {3,1,0,4,8,6,9,9}

</pre>

<p>
   By using the butterfly indices the inverse transform can
   also be applied to an unordered in-place haar function.

<p>
   This function checks the to see whether the wavefx array is
   ordered.  If wavefx is ordered the inverse transform described
   above is applied.  If the data remains in the in-order configuration
   an inverse butterfly is applied.  Note that once the inverse
   Haar is calculated the Haar function data will be replaced by
   the original data.

   */
  public void inverse() {
    if (wavefx != null) {
      if (isOrdered) {
	inverse_ordered();
	// Since the signal has been rebuilt from the
	// ordered coefficients, set isOrdered to false
	isOrdered = false;
      }
      else {
	inverse_butterfly();
      }
    }
  } // inverse


  /**
   *
<p>
     Calculate the inverse Haar transform on an ordered
     set of coefficients.
<p>
     See comment above for the <tt>inverse()</tt> method
     for details.
<p>
     The algorithm above uses an implicit temporary.  The
     in-place algorithm is a bit more complex.  As noted
     above, the Haar value and coefficient are replaced
     with the newly calculated values:

<pre>
     t<sub>1</sub> = <b>a</b><sub>1</sub> + c<sub>1</sub>;
     t<sub>2</sub> = <b>a</b><sub>1</sub> - c<sub>1</sub>;
     <b>a</b><sub>1</sub> = t<sub>1</sub>;
     c<sub>1</sub> = t<sub>2</sub>
</pre>

<p>
    As the calculation proceeds and the coefficients are replaced by
    the newly calculated Haar values, the values are out of order.
    This is shown in the below (use <tt>javadoc -private
    wavelets</tt>).  Here each element is numbered with a subscript as
    it should be ordered.  A sort operation reorders these values
    as the calculation proceeds.  The variable <tt>L</tt> is the power of
    two.

<pre>
start: {<b>5.0</b>, -3.0, 0.0, -1.0, 1.0, -2.0, 1.0, 0.0}
[0, 1]
L = 1
{<b>2.0</b><sub>0</sub>, <b>8.0</b><sub>1</sub>, 0.0, -1.0, 1.0, -2.0, 1.0, 0.0}
 sort:

 start: {<b>2.0</b><sub>0</sub>, <b>8.0</b><sub>1</sub>, 0.0, -1.0, 1.0, -2.0, 1.0, 0.0}
[0, 2], [1, 3]
L = 2
{<b>2.0</b><sub>0</sub>, <b>7.0</b><sub>2</sub>, <b>2.0</b><sub>1</sub>, <b>9.0</b><sub>3</sub>, 1.0, -2.0, 1.0, 0.0}
 sort:
exchange [1, 2]
{<b>2.0</b><sub>0</sub>, <b>2.0</b><sub>1</sub>, <b>7.0</b><sub>2</sub>, <b>9.0</b><sub>3</sub>, 1.0, -2.0, 1.0, 0.0}

 start: {2.0, 2.0, 7.0, 9.0, 1.0, -2.0, 1.0, 0.0}
[0, 4], [1, 5], [2, 6], [3, 7]
L = 4
{<b>3.0</b><sub>0</sub>, <b>0.0</b><sub>2</sub>, <b>8.0</b><sub>4</sub>, <b>9.0</b><sub>6</sub>, <b>1.0</b><sub>1</sub>, <b>4.0</b><sub>3</sub>, <b>6.0</b><sub>5</sub>, <b>9.0</b><sub>7</sub></b>}
 sort:
exchange [1, 4]
{<b>3.0</b><sub>0</sub>, <b>1.0</b><sub>1</sub>, <b>8.0</b><sub>4</sub>, <b>9.0</b><sub>6</sub>, <b>0.0</b><sub>2</sub>, <b>4.0</b><sub>3</sub>, <b>6.0</b><sub>5</sub>, <b>9.0</b><sub>7</sub>}
exchange [2, 5]
{<b>3.0</b><sub>0</sub>, <b>1.0</b><sub>1</sub>, <b>4.0</b><sub>3</sub>, <b>9.0</b><sub>6</sub>, <b>0.0</b><sub>2</sub>, <b>8.0</b><sub>4</sub>, <b>6.0</b><sub>5</sub>, <b>9.0</b><sub>7</sub>}
exchange [3, 6]
{<b>3.0</b><sub>0</sub>, <b>1.0</b><sub>1</sub>, <b>4.0</b><sub>3</sub>, <b>6.0</b><sub>5</sub>, <b>0.0</b><sub>2</sub>, <b>8.0</b><sub>4</sub>, <b>9.0</b><sub>6</sub>, <b>9.0</b><sub>7</sub>}
exchange [2, 4]
{<b>3.0</b><sub>0</sub>, <b>1.0</b><sub>1</sub>, <b>0.0</b><sub>2</sub>, <b>6.0</b><sub>5</sub>, <b>4.0</b><sub>3</sub>, <b>8.0</b><sub>4</sub>, <b>9.0</b><sub>6</sub>, <b>9.0</b><sub>7</sub>}
exchange [3, 5]
{<b>3.0</b><sub>0</sub>, <b>1.0</b><sub>1</sub>, <b>0.0</b><sub>2</sub>, <b>8.0</b><sub>4</sub>, <b>4.0</b><sub>3</sub>, <b>6.0</b><sub>5</sub>, <b>9.0</b><sub>6</sub>, <b>9.0</b><sub>7</sub>}
exchange [3, 4]
{<b>3.0</b><sub>0</sub>, <b>1.0</b><sub>1</sub>, <b>0.0</b><sub>2</sub>, <b>4.0</b><sub>3</sub>, <b>8.0</b><sub>4</sub>, <b>6.0</b><sub>5</sub>, <b>9.0</b><sub>6</sub>, <b>9.0</b><sub>7</sub>}
</pre>   
 
  ********/

  private void inverse_ordered() {
    int len = wavefx.length;
    
    for (int L = 1; L < len; L = L * 2) {
      
      int i;
      
      // calculate
      for (i = 0; i < L; i++) {
	int a_ix = i;
	int c_ix = i + L;
	double a1        = wavefx[a_ix] + wavefx[c_ix];
	double a1_plus_1 = wavefx[a_ix] - wavefx[c_ix];
	wavefx[a_ix] = a1;
	wavefx[c_ix] =a1_plus_1;
      } // for i
      
      // sort
      int offset = L-1;
      for (i = 1; i < L; i++) {
	for (int j = i; j < L; j++) {
	  double tmp = wavefx[j];
	  wavefx[j] = wavefx[j+offset];
	  wavefx[j+offset] = tmp;
	} // for j
	offset = offset - 1;
      } // for i
      
    } // for L
  } // inverse_ordered


  /**
   *
<p>
    Calculate the inverse Haar transform on the result of
    the in-place Haar transform.

<p>
    The inverse butterfly exactly reverses in-place Haar
    transform.  Instead of generating coefficient values
    (<tt>c<sub>i</sub><tt>), the inverse butterfly calculates
    Haar values (<tt><b>a</b><sub>i</sub>) using the 
    equations:
<pre>
        <b>new_a</b><sub>i</sub> = <b>a</b><sub>i</sub> + c<sub>i</sub>
        <b>new_a</b><sub>i+1</sub> = <b>a</b><sub>i</sub> - c<sub>i</sub>
</pre>

<pre>
<b>a</b><sub>0</sub> c<sub>0</sub> c<sub>1</sub> c<sub>0</sub> c<sub>2</sub> c<sub>0</sub> c<sub>1</sub> c<sub>0</sub>

<b>a</b><sub>1</sub> = <b>a</b><sub>0</sub> + c<sub>2</sub>
<b>a</b><sub>1</sub> = <b>a</b><sub>0</sub> - c<sub>2</sub>

<b>a</b><sub>1</sub> c<sub>0</sub> c<sub>1</sub> c<sub>0</sub> <b>a</b><sub>1</sub> c<sub>0</sub> c<sub>1</sub> c<sub>0</sub>

<b>a</b><sub>2</sub> = <b>a</b><sub>1</sub> + c<sub>1</sub>
<b>a</b><sub>2</sub> = <b>a</b><sub>1</sub> - c<sub>1</sub>
<b>a</b><sub>2</sub> = <b>a</b><sub>1</sub> + c<sub>1</sub>
<b>a</b><sub>2</sub> = <b>a</b><sub>1</sub> - c<sub>1</sub>

<b>a</b><sub>2</sub> c<sub>0</sub> <b>a</b><sub>2</sub> c<sub>0</sub> <b>a</b><sub>2</sub> c<sub>0</sub> <b>a</b><sub>2</sub> c<sub>0</sub>

<b>a</b><sub>3</sub> = <b>a</b><sub>2</sub> + c<sub>0</sub>
<b>a</b><sub>3</sub> = <b>a</b><sub>2</sub> - c<sub>0</sub>
<b>a</b><sub>3</sub> = <b>a</b><sub>2</sub> + c<sub>0</sub>
<b>a</b><sub>3</sub> = <b>a</b><sub>2</sub> - c<sub>0</sub>
<b>a</b><sub>3</sub> = <b>a</b><sub>2</sub> + c<sub>0</sub>
<b>a</b><sub>3</sub> = <b>a</b><sub>2</sub> - c<sub>0</sub>
<b>a</b><sub>3</sub> = <b>a</b><sub>2</sub> + c<sub>0</sub>
<b>a</b><sub>3</sub> = <b>a</b><sub>2</sub> - c<sub>0</sub>

<b>a</b><sub>3</sub> <b>a</b><sub>3</sub> <b>a</b><sub>3</sub> <b>a</b><sub>3</sub> <b>a</b><sub>3</sub> <b>a</b><sub>3</sub> <b>a</b><sub>3</sub> <b>a</b><sub>3</sub> 

</pre>

<p>
A numeric example is shown below.

<pre>
<b>5</b><sub>0</sub>  1<sub>0</sub>  0<sub>1</sub> -2<sub>0</sub> -3<sub>2</sub>  1<sub>0</sub> -1<sub>1</sub>  0<sub>0</sub>

<b>a</b><sub>1</sub> = 5 + (-3) = 2
<b>a</b><sub>1</sub> = 5 - (-3) = 8

<b>2</b><sub>1</sub>  1<sub>0</sub>  0<sub>1</sub> -2<sub>0</sub> <b>8</b><sub>1</sub>  1<sub>0</sub> -1<sub>1</sub>  0<sub>0</sub>

<b>a</b><sub>2</sub> = 2 + 0    = 2
<b>a</b><sub>2</sub> = 2 - 0    = 2
<b>a</b><sub>2</sub> = 8 + (-1) = 7
<b>a</b><sub>2</sub> = 8 - (-1) = 9

<b>2</b><sub>2</sub>  1<sub>0</sub>  <b>2</b><sub>2</sub> -2<sub>0</sub> <b>7</b><sub>2</sub>  1<sub>0</sub> <b>9</b><sub>2</sub>  0<sub>0</sub>

<b>a</b><sub>3</sub> = 2 + 1    = 3
<b>a</b><sub>3</sub> = 2 - 1    = 1
<b>a</b><sub>3</sub> = 2 + (-2) = 0
<b>a</b><sub>3</sub> = 2 - (-2) = 4
<b>a</b><sub>3</sub> = 7 + 1    = 8
<b>a</b><sub>3</sub> = 7 - 1    = 6
<b>a</b><sub>3</sub> = 9 + 0    = 9
<b>a</b><sub>3</sub> = 9 - 0    = 9

<b>3</b><sub>3</sub>  <b>1</b><sub>3</sub>  <b>0</b><sub>3</sub>  <b>4</b><sub>3</sub>  <b>8</b><sub>3</sub>  <b>6</b><sub>3</sub>  <b>9</b><sub>3</sub>  <b>9</b><sub>3</sub>

</pre>

<p>
   Note that the inverse_butterfly function is faster than
   the inverse_ordered function, since data does not have
   to be reshuffled during the calculation.

   */
  private void inverse_butterfly() {
    int len = wavefx.length;
    
    if (len > 0) {
      byte log = binary.log2( len );
      
      len = binary.power2( log );  // calculation must be on 2 ** n values
      
      for (byte l = (byte)(log-1); l >= 0; l--) {
	int p = binary.power2( l );
	for (int j = 0; j < len; j++) {
	  int a_ix = p * (2 * j);
	  int c_ix = p * ((2 * j) + 1);
	  
	  if (c_ix < len) {
	    double a = wavefx[a_ix] + wavefx[c_ix];
	    double c = wavefx[a_ix] - wavefx[c_ix];
	    wavefx[a_ix] = a;
	    wavefx[c_ix] = c;
	  }
	  else {
	    break;
	  }
	} // for j
      } // for l
    }
  } // inverse_butterfly


} // inplace_haar
