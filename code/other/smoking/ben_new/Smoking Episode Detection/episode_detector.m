function Yhat = episode_detector(F,wFeatures,wTrans);

%Predict segment labels
Yhat = predict_crf(F,wFeatures,wTrans,'mpe');
