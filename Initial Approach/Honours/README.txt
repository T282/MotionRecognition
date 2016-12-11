
Prototype code for selective STIP detection. If used, please cite :     

Bhaskar Chakraborty, Michael B. Holte, Thomas B. Moeslund and Jordi Gonzàlez, "Selective Spatio-Temporal Interest Points". 
Computer Vision and Image Understanding 116(3), pp. 396-410. 2012. 

Content:

  src : This folder contains all the source codes. Please follow the names of
        code to understand its usage. Each code has documentation.
  demo : This folder contains quick demos of the interest point detection.


How to run :

  For interest point detection :

   1. Open the Matlab s/w
   2. Go to the 'demo' folder.
   3. To get the demo of the interest point detection without pruning :
      demo_interest_point_wo_pruning(0,1);
   4. To get the demo of the interest point detection with pruning :
      demo_interest_point_wo_pruning(1,1);
      Note : The second argument is for displaying the result.
   5. To find the selective stips :
      demo_selective_stip(1);
      Note : We are passing "1" for displaying the obtained interest points.
   Parameters present in the demo scripts need to be changed to obtain different
   result.

General comments :

  1. This code is a prototype version of the original selective STIP.
  2. The given code primarily show the way to prune the spatial interest point using
     inhibition mask, which is the main contribution of the work.
  3. A general hint is given about how to apply temporal constraint on the pruned
     spatial interest point to get the final selective STIPs. One need to find other
     ways to apply temporal constraint to adapt to a specific system.
  4. I provide some possible values of different parameters, but please feel free to
     change then to obtain better intrest points.
  5. It is important to note that this prototype is giving a hint to implement the
     concepts that are present in :

     Bhaskar Chakraborty, Michael B. Holte, Thomas B. Moeslund and Jordi Gonzàlez,
     Selective Spatio-Temporal Interest Points. Computer Vision and Image Understanding,
     Elsevier, 116(3), pp. 396-410. 2012.

     Bhaskar Chakraborty, Michael B. Holte, Thomas B. Moeslund, Jordi Gonzàlez and F. Xavier Roca,
     A Selective Spatio-Temporal Interest Point Detector for Human Action Recognition in Complex Scenes.
     ICCV'11: 13th International Conference on Computer Vision, Barcelona, Spain. November, 2011.

     One need to change the code to adapt to different scenario and obtain results that suits better
     for a specific application.
