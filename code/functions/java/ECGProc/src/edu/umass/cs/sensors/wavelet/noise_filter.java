

package edu.umass.cs.sensors.wavelet;

import java.util.Vector;

/**
  <p>
  The objective in filtering is to remove noise while keeping the
  features that are interesting.
  </p>

  <p> 
  Wavelets allow a time series to be examined at various
  resolutions.  This can be a powerful tool in filtering out noise.
  This class supports the subtraction of gaussian noise from
  the time series.
  </p>

  <p>
  The identification of noise is complex and I have not found any
  material that I could understand which discussed noise
  identification in the context of wavelets.  I did find some material
  that has been difficult and frustrating.  In particular
  <i>Image Processing and Data Analysis: the multiscale approach</i>
  by Starck, Murtagh and Bijaoui.
  </p>
  
  <p>
  If the price of a stock follows a random walk, its price will be
  distributed in a bell (gaussian) curve.  This is one way of stating
  the concept from financial theory that the daily return is normally
  distributed (here daily return is defined as the difference between
  yesterdays close price and today's close price).  Movement outside
  the bounds of the curve may represent something other than a random walk
  and so, in theory, might be interesting.
  </p>

  <p> 
  At least in the case of the single test case used in developing this
  code (Applied Materials, symbol: AMAT), the coefficient distribution
  in the highest frequency is almost a perfect normal curve.  That is,
  the mean is close to zero and the standard deviation is close to
  one.  The area under this curve is very close to one.  This
  resolution approximates the daily return.  At lower frequencies the
  mean moves away from zero and the standard deviation increases.
  This results is a flattened curve, whose area in the coefficient
  range is increasingly less than one.
  </p>

  <p> 
  The code in this class subtracts the normal curve from the
  coefficients at each frequency up to some minimum.  This leaves only
  the coefficients above the curve which are used to regenerate the
  time series (without the noise, in theory).  This filter removes 50
  to 60 percent of the coefficients.
  </p>

  <p>
  Its probably worth mentioning that there are other kinds of
  noise, most notably Poisson noise.  In theory daily data
  tends to show gaussian noise, while intraday data would
  should Poisson noise.  Intraday Poisson noise would result
  from the random arrival and size of orders.
  </p>

  <p>
  This function has two public methods:
  </p>
  <ol>
  <li>
  <p>n
  <i>filter_time_series</i>, which is passed a file name and a time series
  </p>
  </li>
  <li>
  <p>
  <i>gaussian_filter</i> which is passed a set of Haar coefficient
  spectrum and an array allocated for the noise values.  The
  noise array will be the same size as the coefficient array.
  </p>
  </li>
  <ol>
    
  </p>

 */
@SuppressWarnings({"unchecked","unused"})
public class noise_filter  {

String class_name() { return "noise_filter"; }

  /**
    <p>
    The point class represents a coefficient value so that it can be
    sorted for histogramming and then resorted back into the orignal
    ordering (e.g., sorted by value and then sorted by index)
    </p>
   */
  private class point {
    point(int i, double v)
    {
      index = i;
      val = v;
    }
    public int index;  // index in original array
    public double val; // coefficient value
  } // point


  /**
    <p>
    A histogram bin
    </p>
    <p>
    For a histogram bin b<sub>i</sub>, the range of
    values is b<sub>i</sub>.start to b<sub>i+1</sub>.start.
    </p>
    <p>
    The vector object <i>vals</i> stores references to 
    the point objects which fall in the bin range.
    </p>
    <p>
    The number of values in the bin is <i>vals.size()</i>
    </p>
   */
  @SuppressWarnings("rawtypes")
  private class bin {
    bin( double s ) { start = s; }
    public double start;
    
	public Vector vals = new Vector();
  } // bin

   /**
      Bell curve info: mean, sigma (the standard deviation)
    */
   private class bell_info {
     public bell_info() {}
     
	public bell_info(double m, double s)
     {
       mean = m;
       sigma = s;
     }
     public double mean;
     public double sigma;
   } // bell_info



  /**

    <p>
    Build a histogram from the sorted data in the pointz
    array.  The histogram is constructed by appending a
    point object to the the bin <i>vals</i> Vector if the value
    of the point is between b[i].start and b[i].start + step.
    </p>

   */
  
private void histogram( bin binz[], point pointz[] )
  {
    double step = binz[1].start - binz[0].start;
    double start = binz[0].start;
    double end = binz[1].start;
    int len = pointz.length;
    double max = binz[ binz.length-1 ].start + step;

    int i = 0;
    int ix = 0;
    while (i < len && ix < binz.length) {
      if (pointz[i].val >= start && pointz[i].val < end) {
	binz[ix].vals.addElement( pointz[i] );
	i++;
      }
      else {
	ix++;
	start = end;
	end = end + step;
      }
    } // while
  } // histogram


  
  /**
    Sort an array of <i>point</i> objects by the
    index field.
   */
  private class sort_by_index extends generic_sort {
    
    /**

      if (a.index == b.index) return 0
      if (a.index < b.index) return -1
      if (a.index > b.index) return 1;

     */
    protected int compare( Object a, Object b )
    {
      int rslt = 0;
      point t_a = (point)a;
      point t_b = (point)b;

      if (t_a.index < t_b.index)
	rslt = -1;
      else if (t_a.index > t_b.index)
	rslt = 1;

      return rslt;
    } // compare

  } // sort_by_index


  /**
    Sort an array of <i>point</i> objects by the
    val filed.
   */
  private class sort_by_val extends generic_sort {

    /**

      if (a.val == b.val) return 0
      if (a.val < b.val) return -1
      if (a.val > b.val) return 1;

     */
    protected int compare( Object a, Object b )
    {
      int rslt = 0;
      point t_a = (point)a;
      point t_b = (point)b;

      if (t_a.val < t_b.val)
	rslt = -1;
      else if (t_a.val > t_b.val)
	rslt = 1;

      return rslt;
    } // compare

  } // sort_by_val


  /**
    Allocate an array of histogram bins that is <i>num_bins</i> in
    length.  Initialize the start value of each bin with
    a start value calculated from <i>low</i> and <i>high</i>.
   */
  private bin[] alloc_bins( int num_bins, double low, double high )
  {
    double range = high - low;
    double step = range / (double)num_bins;
    double start = low;

    bin binz[] = new bin[ num_bins ];
    for (int i = 0; i < num_bins; i++) {
      binz[i] = new bin( start );
      start = start + step;
    }

    return binz;
  } // alloc_bins


  /**
    <p>
    Calculate the histogram of the coefficients using 
    <i>num_bins</i> histogram bins
    </p>
    <p>
    The Haar coefficients are stored in point objects
    which consist of the coefficient value and the
    index in the point array.
    </p>
    <p>
    To calculate the histogram, the pointz array is
    sorted by value.  After it is histogrammed it
    is resorted by index to return the original ordering.
    </p>
   */
  private bin[] calc_histo( point pointz[], int num_bins )
  {
    // sort by value
    sort_by_val by_val = new sort_by_val();
    by_val.sort( pointz );

    int len = pointz.length;
    double low = pointz[0].val;
    double high = pointz[len-1].val;

    bin binz[] = alloc_bins( num_bins, low, high );
    histogram( binz, pointz );

    // return the array to its original order by sorting by index
    sort_by_index by_index = new sort_by_index();
    by_index.sort( pointz );
    
    return binz;
  } // calc_histo


  /**
    <p>
    Allocate and initialize an array of <i>point</i> objects.
    The size of the array is <tt><i>end</i> - <i>start</i></tt>.
    Each point object in the array is initialized with its
    index and a Haar coefficient (from the <i>coef</i> array).
    </p>
    <p>
    Since the allocation code has to iterate through the 
    coefficient spectrum the mean and standard deviation
    are also calculated to avoid an extra iteration.  These
    values are returned in the <i>bell_info</i> object.
    </p>
   */
  private point[] alloc_points( double coef[], 
				int start, 
				int end,
				bell_info info )
  {
    int size = end - start;
    point pointz[] = new point[ size ];

    double sum = 0;
    int ix = start;
    for (int i = 0; i < size; i++) {
      pointz[i] = new point( i, coef[ix] );
      sum = sum + coef[ix];
      ix++;
    }
    double mean = sum / (double)size;
    
    // now calculate the standard deviation
    double stdDevSum = 0;
    double x;
    for (int i = 0; i < size; i++) {
      x = pointz[i].val - mean;
      stdDevSum = stdDevSum + (x * x);
    }
    double sigmaSquared = stdDevSum / (size-1);
    double sigma = Math.sqrt( sigmaSquared );

    info.mean = mean;
    info.sigma = sigma;

    return pointz;
  } // alloc_points



  /**
    <p>
    normal_interval
    </p>

    <p>
    Numerically integreate the normal curve with mean
    <i>info.mean</i> and standard deviation <i>info.sigma</i>
    over the range <i>low</i> to <i>high</i>.
    </P>

    <p>
    There normal curve equation that is integrated is:
     </p>
     <pre>
       f(y) = (1/(s * sqrt(2 * pi)) e<sup>-(1/(2 * s<sup>2</sup>)(y-u)<sup>2</sup></sup>
     </pre>

     <p>
     Where <i>u</i> is the mean and <i>s</i> is the standard deviation.
     </p>

     <p>
     The area under the section of this curve from <i>low</i> to
     <i>high</i> is returned as the function result.
     </p>

     <p>
     The normal curve equation results in a curve expressed as
     a probability distribution, where probabilities are expressed
     as values greater than zero and less than one.  The total area
     under a normal curve with a mean of zero and a standard
     deviation of one is is one.
     </p>

     <p>
     The integral is calculated in a dumb fashion (e.g., we're not
     using anything fancy like simpson's rule).  The area in
     the interval <b>x</b><sub>i</sub> to <b>x</b><sub>i+1</sub>
     is 
     </P>

     <pre>
     area = (<b>x</b><sub>i+1</sub> - <b>x</b><sub>i</sub>) * g(<b>x</b><sub>i</sub>)
     </pre>

     <p>
     where the function g(<b>x</b><sub>i</sub>) is the point on the
     normal curve probability distribution at <b>x</b><sub>i</sub>.
     </p>

     @param info       This object encapsulates the mean and standard deviation
     @param low        Start of the integral
     @param high       End of the integral
     @param num_points Number of points to calculate (should be even)

   */
  private double normal_interval(bell_info info,
				 double low, 
				 double high, 
				 int num_points )
  {
    double integral = 0;

    if (info != null) {
      double s = info.sigma;
      // calculate 1/(s * sqrt(2 * pi)), where <i>s</i> is the stddev
      double sigmaSqrt = 1.0 / (s * (Math.sqrt(2 * Math.PI)));
      double oneOverTwoSigmaSqrd = 1.0 / (2 * s * s);

      double range = high - low;
      double step = range / num_points;
      double x = low;
      double f_of_x;
      double area;
      double t;
      for (int i = 0; i < num_points-1; i++) {
	t = x - info.mean;
	f_of_x = sigmaSqrt * Math.exp( -(oneOverTwoSigmaSqrd * t * t) );
	area = step * f_of_x; // area of one rectangle in the interval
	integral = integral + area;  // sum of the rectangles
	x = x + step;
      } // for
    }

    return integral;
  } // normal_interval


  /**
    <p>
    Set num_points values in the histogram bin <i>b</i>
    to zero.  Or, if the number of values is less
    than num_zero, set all values in the bin to zero.
    </p>

    <p>
    The num_zero argument is derived from the area under
    the normal curve in the histogram bin interval.  This
    area is a fraction of the total curve area.  When multiplied
    by the total number of coefficient points we get
    num_zero.
    </p>

    <p>
    The noise coefficients are preserved (returned) in the noise
    array argument.
    </p>

   */
  private void zero_points( bin b, int num_zero, double noise[] )
  {
    int num = b.vals.size();
    int end = num_zero;
    if (end > num)
      end = num;

    point p;
    for (int i = 0; i < end; i++) {
      p = (point)b.vals.elementAt( i );
      noise[ p.index ] = p.val;
      p.val = 0;
    }
  } // zero_points


  /**
    <p>
    Subtract the gaussian (or normal) curve from the histogram
    of the coefficients.  This is done by integrating the 
    gaussian curve over the range of a bin.  If the number of
    items in the bin is less than or equal to the area under the
    curve in that interval, all items in the bin are set to
    zero.  If the number of items in the bin is greater than
    the area under the curve, then a number of bin items equal
    to the curve area is set to zero.
    </p>
    <p>
    The area under a normal curve is always less than or equal
    to one.  So the area returned by normal_interval is the 
    fraction of the total area.  This is multiplied by
    the total number of coefficients.
    </p>
    <p>
    The function returns the number of coefficients that
    are set to zero (e.g., the number of coefficients that
    fell within the gaussian curve).  These coefficients are
    the noise coefficients.  The noise coefficients are returned
    in the noise argument.
    </p>
   */
  private int subtract_gauss_curve( bin binz[], 
			            bell_info info,
				    int total_points,
				    double noise[] )
  {
    int points_in_interval = total_points / binz.length;
    double start = binz[0].start;
    double end = binz[1].start;
    double step = end - start;
    double percent;
    int num_points;
    int total_zeroed = 0;

    for (int i = 0; i < binz.length; i++) {
      percent = normal_interval( info, start, end, points_in_interval );
      num_points = (int)(percent * (double)total_points);
      total_zeroed = total_zeroed + num_points;
      if (num_points > 0) {
	zero_points( binz[i], num_points, noise );
      }
      start = end;
      end = end + step;
    } // for

    return total_zeroed;
  } // subtract_gauss_curve

  
  /**
   <p>
   This function is passed the section of the Haar
   coefficients that correspond to a single spectrum.
   It compares this spectrum to a gaussian
   curve and zeros out the coefficients within the
   gaussian curve.
   </p>
   <p>
   The function returns the number of points filtered out as
   the function result.  The noise spectrum is also returned
   in the <i>noise</i> argument.
   </p>
   */
  private int filter_spectrum( double coef[], int start, int end,
				double noise[] )
  {
    final int num_bins = 32;
    int num_filtered;

    bell_info info = new bell_info();
    point pointz[] = alloc_points( coef, start, end, info );
    bin binz[] = calc_histo( pointz, num_bins );
    num_filtered = subtract_gauss_curve( binz, info, pointz.length, noise );
    
    int zero_count = 0;
    // copy filtered coefficients back into the coefficient array
    int ix = start;
    for (int i = 0; i < pointz.length; i++) {
      coef[ix] = pointz[i].val;
      ix++;
    }

    return num_filtered;
  } // filter_spectrum


  /**
    Normalize the noise array to zero by subtracting
    the smallest value from all points.
   */
  private void normalize_to_zero( double noise[] )
  {
    double min = noise[0];
    for (int i = 1; i < noise.length; i++) {
      if (min > noise[i])
	min = noise[i];
    } // for

    // normalize
    for (int i = 0; i < noise.length; i++) {
      noise[i] = noise[i] - min;
    }
  } // normalize_to_zero


  /**
   <p>
   This function is passed a set of Haar wavelet
   coefficients that result from the Haar wavelet
   transform.  It applies a gaussian noise filter
   to each frequency spectrum.  This filter zeros
   out coefficients that fall within a gaussian
   curve.  This alters the input data (the coef array).
   </p>
   <p>
   The <i>coef</i> argument is the input argument and
   contains the coefficients.  The <i>noise</i> argument
   is an output argument and contains the coefficients
   that have been filtered out.  This allows a noise
   spectrum to be rebuilt.
   </p>
   */
  public void gaussian_filter( double coef[], double noise[] )
  {
    final int min_size = 64;  // minimum spectrum size
    
    int total_filtered = 0;
    int num_filtered;
    int end = coef.length;
    int start = end >> 1;
    while (start >= min_size) {
      num_filtered = filter_spectrum( coef, start, end, noise );
      total_filtered = total_filtered + num_filtered;
      end = start;
      start = end >> 1;
    }

    // Note that coef[0] is the average across the
    // time series.  This value is needed to regenerate
    // the noise spectrum time series.
    noise[0] = coef[0];

    System.out.println("gaussian_filter: total points filtered out = " +
		       total_filtered );
  } // gaussian_filter



  /**
    Calculate the Haar tranform on the time series (whose
    length must be a factor of two) and filter it.  Then
    calculate the inverse transform and write the result
    to a file whose name is <i>file_name</i>.  A noise
    spectrum is written to <i>file_name</i>_noise.
   */
  public void filter_time_series(  double ts[] )
  {
    double noise[] = new double[ ts.length ];
    inplace_haar haar = new inplace_haar();
    haar.wavelet_calc( ts );
    haar.order();
    gaussian_filter( ts, noise );
    haar.inverse();
  } // filter_time_series

} // noise_filter
