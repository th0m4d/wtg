function mean_accuracy   = boh_stratified_xvalidation(histograms,labels,cval,frames_per_song,nfold)
%boh_stratified_xvalidation perform a stratified 10 fold cross-validation
% of the histogram then calculated the mean of the raw performance
% and the performance per clip using a voting scheme.
% returns the mean accuracy for that model 


%let's try to create partituon based on songs
% we know that  a song has 6 "frames"

len = size(labels,1);

sub_labels = labels(1:frames_per_song:len);
cv = cvpartition(sub_labels, 'kfold',nfold);  

confusion = [];

%# Statistics toolbox
indices = zeros(size(labels(1:len)));

%lets expand the thing to get ti per song

for i = 1:nfold
  w = [];  
  for j = 1:frames_per_song
    w = horzcat(w,cv.test(i));
  end
  
  real_idx = reshape(w',size(w,1)*size(w,2),1);
  indices(logical(real_idx)) = i;
  
end

  %correct the size of the indices
  %indices = indices(1:len);

  acc = zeros(nfold,1);
    
    
  multithread = true;
    
  if(multithread)
    
    profileName = parallel.defaultClusterProfile();
    cluster = parcluster(profileName);
    job = createJob(cluster);
        
        
        
    for i=1:nfold
        testIdx = (indices == i); 
        trainIdx = ~testIdx;
         
        train_labels = labels(trainIdx);
        train_hist = histograms(trainIdx,:);
        
        
        
        createTask(job, @svmtrain, 1, {train_labels,train_hist,sprintf('-t 5 -b 1 -c %0.5f',cval)});

    end
    
    
    
    submit(job);
    wait(job);
    taskoutput = fetchOutputs(job);
    
    
    
    
    
    
    for i=1:nfold
       model =  taskoutput{i};
       
       testIdx = (indices == i); 
       trainIdx = ~testIdx;
       
       test_labels =   labels(testIdx);
       test_hist = histograms(testIdx,:); 
        
        

       [svml,svmd,svmap] = svmpredict(test_labels,test_hist,model,'-b 1');
       
       [ a, b ] = calc_predict_clip(test_labels,svml,frames_per_song);
     
        accs_clip(i) = (1 - nnz(a - b)/size(a,2));
    
        fprintf('Accuracy per clip = %0.2f%% (%d/%d) \n', accs_clip(i)*100 ,round(accs_clip(i)*size(a,2)),size(a,2));
        confusion = vertcat(confusion,a(1:100));
        confusion = vertcat(confusion,b(1:100));

       
     
    end
    
   else
       
        for i=1:nfold
           
         testIdx = (indices == i); 
         trainIdx = ~testIdx;
              
         
        train_labels = labels(trainIdx);
        train_hist = histograms(trainIdx,:);
       
        
        model =   svmtrain(train_labels,train_hist,sprintf('-t 5 -b 1 -c  %0.5f',cval));
        
        % svmtrain(labels(trainIdx),histograms(trainIdx),sprintf('-t 5 -b 1 -v 5 -c %0.5f',cval));

        test_labels =   labels(testIdx);
        test_hist = histograms(testIdx,:); 
 
       
         [svml,svmd,svmap] = svmpredict(test_labels,test_hist,model,'-b 1');
       
        % fix me - group size sshould be an paramter
        [ a, b ] = calc_predict_clip(test_labels,svml,frames_per_song);
        accs_clip(i) = (1 - nnz(a - b)/size(a,2));
        fprintf('Accuracy per clip = %0.2f%% (%d/%d) \n', accs_clip(i)*100 ,round(accs_clip(i)*size(a,2)),size(a,2));
        confusion = vertcat(confusion,a);
        confusion = vertcat(confusion,b);

        
        
           
        end
        
        
    end
    
    mean_accuracy = mean(accs_clip);
    std_accuracy = std(accs_clip);
    
    fprintf('Mean Accuracy of %.4f \n',mean_accuracy);
    fprintf('Accuracy standard deviation of %.4f \n',std_accuracy);
    save('confusion','confusion');

end

