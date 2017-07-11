function newScores = updateScores(classifier_scores, pixel_map,super_pixels)
gamma=.8;
newScores=  classifier_scores;
sp_centers = round(findCenterSps(super_pixels));
for spIdx=1:size(classifier_scores,1)
    for labelIdx= 1:size(classifier_scores,2)          
      p_label = pixel_map( sp_centers(1,spIdx),sp_centers(2,spIdx),labelIdx);
      newScores(spIdx,labelIdx) = p_label ^ (1-gamma) * classifier_scores(spIdx,labelIdx) ^ gamma;
    end
end

for i=1:size(newScores,1)
  
     newScores(i,:)=  newScores(i,:) / norm( newScores(i,:), 1);
end