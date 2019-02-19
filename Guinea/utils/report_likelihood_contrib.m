% Copyright (C), OGResearch 2018
function report_likelihood_contrib(db, mult, rng, std_list) 
  enames = regexprep(std_list,'^std_','');
  disp('Contributions des chocs choisis aux probabilités globales moins log');
  for i=1:length(enames)
    s = db.(enames{i})(rng);
    st = mult.(['std_' enames{i}])(rng);
    disp(sprintf('%30s: %12.5g',enames{i},sum((s./st).^2)));
  end
end