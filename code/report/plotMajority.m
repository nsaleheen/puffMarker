for i=length(outputClasses):-1:1 
    if outputClasses(i)==1 
        plot(outputClasses(i),'.','Color','r'); 
    else
        plot(outputClasses(i),'.');
    end;
end;