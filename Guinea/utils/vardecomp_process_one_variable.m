function fh = vardecomp_process_one_variable(x, var, ndecomp)
    
  shocks = colnames(x);
  
  %- find the variable in the x
  ii = strmatch(var, rownames(x), 'exact');
  if isempty(ii)
    error(['Could not find a variable ' var ' in decomposition']);
  end
    
  %- select ndecomp-1 largest contributions
  xx = double(squeeze(x(ii(1), :, :)))';
  xxsum = sum(xx, 1);
  [y, jj] = sort(xxsum, 2, 'descend');
  if size(xx, 2) > ndecomp-1
    yy = xx(:, jj(1:ndecomp-1));
    contribs = shocks(jj(1:ndecomp-1));
    %- add the rest as the last column to yy
    jjrest = setdiff([1:size(xx,2)],jj(1:ndecomp-1));
    yyrest = sum(xx(:,jjrest), 2);
    yy = [yy, yyrest];
    contribs{end+1} = 'REST';
  else
    yy = xx;
    contribs = shocks;
  end

  % make a figure
  fh = figure('visible','off');
  variance = sum(yy, 2);
  %- relative contributions
  subplot(2,1,1);
  yyrel = diag(variance)\yy*100;
  bar(yyrel,'stack');
  h = legend(contribs,'orientation','horizontal','location', ...
             'southoutside');
  set(h,'fontsize',8);
  set(h,'interpreter','none');
  grid;
  xlabel('time periods');
  ylabel('rel. contribution to variance (%)'); 
  xlim([0, size(yy, 1)+1]);
  ylim([0, 100]);
  subplot(2,1,2);
  plot([0:1:size(yy, 1)+1],[0;sqrt(variance);NaN],'LineWidth',2);
  grid;
  xlabel('time periods');
  ylabel('absolute standard error');
  xlim([0, size(yy, 1)+1]);
end