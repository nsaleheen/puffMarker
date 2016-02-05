function [wFeatures,wTrans] = learn_episode_detector(F,Y);

[wFeatures,wTrans] = learn_crf(Y,F,2,MaxIter,lambdaF,lambdaT)

