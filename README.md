# SceneLabeling


Please node first one needs to generate features for each segments, then by using classifiers, in our case RF find confidences for those segments.
Afterwards, using Graphical lasso ( the codes are in the folder) the graph structure can be found and the optimization is done by graph cut or similar methods.

FindStructureFromData_param is the main function to label test images.

M is the matrix you can find based on probabilities or features.  The trained tree model using Random forest should be trained first, any other classifier that can proceed the probability or scores for super-pixel features can be used.
smoothcovsel_solver and GraphicalLasso are packages used for finding correlations between variables.
get connectivity is supposed to find which super pixels are connected based on the position of their centers.
