clear
clc

timeWOPCA = [18.207 27.898 44.659 42.085 12.707 24.249 20.638 26.336 18.461 15.888 33.695 44.176 610.21 942.66 505.32 589.41];

timeWPCA = [2.544 3.614 3.185 6.680 5.852 7.657 10.366 10.757 2.027 6.111 11.235 12.442 517.38 943.45 1074.0 788.84];

for(i=1:16)

    if(timeWPCA(i)<=timeWOPCA(i))
        inc(i)=((timeWOPCA(i)/timeWPCA(i))*100)-100;
        dec(i)=0;
    else
        dec(i)=((timeWPCA(i)/timeWOPCA(i))*100)-100;
        inc(i)=0;
    end

end

disp(inc)
disp(dec)