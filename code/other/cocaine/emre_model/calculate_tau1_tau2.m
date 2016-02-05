function [tau1,tau2,mse1,mse2]=calculate_tau1_tau2(E,cocaine,s)
    [tau1,tau2,mse1,mse2]=recoveryfit3(E,cocaine,s);
    [tau1,tau2]=recoveryfit4(E,cocaine,s,mse1,mse2);
end
