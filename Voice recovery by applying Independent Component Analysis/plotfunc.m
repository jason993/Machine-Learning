function  plotfunc(time, sounds, X, Y)
%PLOT Summary of this function goes here
%   Detailed explanation goes here
   
%====================plot the original signal=============================
[mean11,scalar11] = scalar(sounds(1,:), time(1), time(end));
[mean12,scalar12] = scalar(sounds(2,:), time(1), time(end));
[mean13,scalar13] = scalar(sounds(3,:), time(1), time(end));
[mean14,scalar14] = scalar(sounds(4,:), time(1), time(end));
[mean15,scalar15] = scalar(sounds(5,:), time(1), time(end));

plot(time, 0.5 + (sounds(1,time(1): time(end)) - mean11)/scalar11,'r-');
hold all
plot(time, 1.5 + (sounds(2,time(1): time(end)) - mean12)/scalar12,'g-');
plot(time, 2.5 + (sounds(3,time(1): time(end)) - mean13)/scalar13,'b-');
plot(time, 3.5 + (sounds(4,time(1): time(end)) - mean14)/scalar14,'y-')
plot(time, 4.5 + (sounds(5,time(1): time(end)) - mean15)/scalar15,'c-')

%================Plot the mix signal

[mean21,scalar21] = scalar(X(1,:), time(1), time(end));
[mean22,scalar22] = scalar(X(2,:), time(1), time(end));
[mean23,scalar23] = scalar(X(3,:), time(1), time(end));
[mean24,scalar24] = scalar(X(4,:), time(1), time(end));
[mean25,scalar25] = scalar(X(5,:), time(1), time(end));

plot(time, 5.5 + (X(1,time(1): time(end)) - mean21)/scalar21,'r-');
plot(time, 6.5 + (X(2,time(1): time(end)) - mean22)/scalar22,'g-');
plot(time, 7.5 + (X(3,time(1): time(end)) - mean23)/scalar23,'b-');
plot(time, 8.5 + (X(4,time(1): time(end)) - mean24)/scalar24,'y-');
plot(time, 9.5 + (X(5,time(1): time(end)) - mean25)/scalar25,'c-');

%===================plot the recovery signal===============================
[mean31,scalar31] = scalar(Y(1,:), time(1), time(end));
[mean32,scalar32] = scalar(Y(2,:), time(1), time(end));
[mean33,scalar33] = scalar(Y(3,:), time(1), time(end));
[mean34,scalar34] = scalar(Y(4,:), time(1), time(end));
[mean35,scalar35] = scalar(Y(5,:), time(1), time(end));

plot(time, 10.5 + (Y(1,time(1): time(end)) - mean31)/scalar31,'r-');
plot(time, 11.5 + (Y(2,time(1): time(end)) - mean32)/scalar32,'g-');
plot(time, 12.5 + (Y(3,time(1): time(end)) - mean33)/scalar33,'b-');
plot(time, 13.5 + (Y(4,time(1): time(end)) - mean34)/scalar34,'y-');
plot(time, 14.5 + (Y(5,time(1): time(end)) - mean35)/scalar35,'c-');

end

