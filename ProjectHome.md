# 2012-Feature detection of triangular meshes via neighbor supporting #

> Wang, X.C., Cao, J.J., Liu, X.P., Li, B.J., Shi, X.Q., Sun, Y.Z. Feature detection on triangular meshes via neighbor supporting. Journal of Zhejiang University-SCIENCE C, 2012, 13(6):440-451.


# Motivation #

> In the process of model analysis, understanding, and editing, feature detection usually plays an important and preliminary role in a variety of applications, such as feature-preserving mesh denoising, simplification, segmentation, and hole-filling.

> A crest point has maximum curvature in its corresponding direction and a crest line naturally follows the direction of the minimum curvature of its composing crest point. That is, the feature vertices lie on the principal curvature line. In fact, if v is a feature vertex, there will be more feature vertices that can be located in the principal direction or the opposite principal direction corresponding to its smallest principal curvature.

# Abstract #

> We propose a robust method for detecting features on triangular meshes by combining normal tensor voting with neighbor supporting. Our method contains two stages: feature detection and feature refinement. First, the normal tensor voting method is modified to detect the initial features, which may include some pseudo features. Then, at the feature refinement stage, a novel salient measure deriving from the idea of neighbor supporting is developed. Benefiting from the integrated reliable salient measure feature, pseudo features can be effectively discriminated from the initially detected features and removed. Compared to previous methods based on the differential geometric property, the main advantage of our method is that it can detect both sharp and weak features. Numerical experiments show that our algorithm is robust, effective, and can produce more accurate results. We also discuss how detected features are incorporated into applications, such as feature-preserving mesh denoising and hole-filling, and present visually appealing results by integrating feature information.

# Keyword #

> Feature detection; Neighbor supporting; Normal tensor voting; Salient measure

# Paper #

> http://www.springerlink.com/content/jh702404v1vk55mw/


# Applications #

  * Mesh denoising

  * Hole-filling

# Bibtex #

@article{wang2012,
> author =        "Wang, X.C., Cao, J.J., Liu, X.P., Li, B.J., Shi, X.Q., Sun, Y.Z.",

> title  =         "Feature detection on triangularmeshes via neighbor supporting",

> journal =        "Journal of Zhejiang University-SCIENCE C",

> year =          "2012",

> volume =        "13",

> number =       "6",

> pages =         "440-451",

> doi =           " doi=10.1631/jzus.C1100324",

}

# Main References #

  * Page, D.L., Sun, Y., Koschan, A.F., Paik, J., Abidi, M.A., 2002.  Normal vector voting: crease detection and curvature estimation on large, noisy meshes. Graphical Models, 64(3-4):199-229.

  * Kim, H.S., Choi, H.K., Lee, K.H., 2009. Feature detection of triangular meshes based on tensor voting theory. Comput. Aided Des., 41(1):47-58.