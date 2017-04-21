function [ data_bio2, data_percent_rejected, data_cv ] = chauvenet( x )
% remove zero entries

data_zeros=find(x==0.0);
data_nonzeros=find(x>0.0);

data_bio2 = x(data_nonzeros);

% compute length, mean, std, min max of non-zero data
data_length2=length(data_bio2); %
data_mean2 =mean(data_bio2); %
data_standard2 = std(data_bio2); %
data_max2 = max(data_bio2); %
data_min2 = min(data_bio2); %

% Part three - Identify outliers using Chauvenets criterion
% Z-score data and compute two-sided Z-score for Chauvenets criteria

data_probability = 1/(2*length(data_nonzeros)); %
data_zscore = (data_bio2 - data_mean2)/(data_standard2);
data_ptest = 1 - data_probability/2;
zc=norminv(data_ptest, 0, 1);

% Hence, reject data with biomass > std*zc

data_limit = zc * data_standard2;
data_cv = data_bio2( data_zscore >= -zc & data_zscore <= zc );
data_cvlength = length(data_cv);
index_rejected = find(data_zscore > zc | data_zscore < -zc);
%!!! index_rejected: these are the indices of the rejected values in your data vector

data_rejected = data_bio2(data_zscore > zc | data_zscore < -zc)

index_rejected_original = data_nonzeros(index_rejected); %!!!FLAG THOSE LINES!!!
biomass_rejected_original = x(index_rejected_original);
%!!!index/biomass_rejected_original: these are the lines/biomasses
%of your original data file that need to be flagged
% percent of data rejected by Chavenets criterion

data_percent_rejected = (1- data_cvlength/length(data_bio2))* 100 

% compute histogram using linear bin-size
[M,Y]=hist(data_bio2,1000);
[M_cv]=hist(data_cv,Y);
end