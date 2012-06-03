This code requires a toolbox (MCGL) of the Computer Graphics Library available at:
	http://www.cs.technion.ac.il/~zachik/mcgl/index.htm
Our toolbox contains some codes download from Gabriel Peyre's homepage:
	http://www.ceremade.dauphine.fr/~peyre/matlab/graph/content.html
	
The featuare detection algorithm was introduced in the paper:

	Wang, X.C., Cao, J.J., Liu, X.P., Li, B.J., Shi, X.Q., Sun, Y.Z. Feature detection on triangular
	meshes via neighbor supporting. Journal of Zhejiang University-SCIENCE C, 2012, 13(6):440-451.
	
The source code and paper can be downloaded from the author's homepage: 
	http://www.jjcao.net/publications.html 

	  
Instructions for users:

1. The code contains seven parts. 

      PART 0: Read mesh 
      PART 7: Save data
	
      PART 1: Initial feature detection 
      PART 2: Salience measure computation
      PART 3: Connecting to feature lines
	
      PART 4-6: Postprocessings
	
2. The main code can be executed sequentially. During the execution, some visual results may be popped out. 
If the parameters are not properbable which lead to unsatisfy result, the users are allowed to just the parameters 
immediately untill a better result obtained before going to next part. 

3. Postprocessings PARTs are optiaml, you can grasp them in advance and determine which one or some of them are 
executed to get the better result. Certainly, each postprocessing part can be excuted individully to achieve 
specific effectby by pressing Ctrl + Enter.

4. In (PART 4: Filter the feature lines via edge measure), the filtering effect is not very significant, the samller
threshold may be adopted.

5. In subsection of PART 4, during the function: postprocessing_filter_joints, if you recovery the code during line 58 - 60, 
you can determine whether the current edge is need to be deleted by youself. Certainly, it is time-consuming and tedious, but 
better result can be obtained.


Example: filename = '../data/fandisk_noise.off';

Displae information on Command Window are as follows:

	Normal Tensor Voting -- The result is OK?  Input: y or n:--y
	Input a threshold based on salience measure:--0.45
	Filter Non Feature Vertex -- The result is OK? Input: y or n:--y
	Input a threshold based on edge strength:-- 0
	Filter Non Feature Edge -- The result is OK? Input: y or n:--y
	Prolong Feature Edge -- The result is OK?  Input: y or n:--n
	The previous max_k is 10.000000: Please input a new alpha: 9
	The previous min_k is 7.000000: Please input a new alpha: 7
	Prolong Feature Edge -- The result is OK?  Input: y or n:--y



Note: This code is written by MATLAB. It works well for CAD model, for graphic models unsatisfied results may get. 
      The code is not optimized, which can be improved further. If you find some mistakes, you can correct 
      them or contact us. My email is wangixaochao18@gmail.com


