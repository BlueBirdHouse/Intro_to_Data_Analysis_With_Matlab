load('MatlabDatas.mat');
dailyengagement.Properties.VariableNames{'acct'} = 'account_key';

account_engagement = dailyengagement.account_key(:);
account_enrollment = enrollments.account_key(:);
%不属于两个集合的交集中的元素
account_XOR = setxor(account_engagement,account_enrollment);

%检查这些异类是否在engagement中
IsIn_engagement = ismember(account_XOR,account_engagement);
sum(IsIn_engagement)
%说明account_engagement是一个小集合，包含在大集合里面。
IsIn_enrollment = ismember(account_enrollment,account_XOR);
enrollments(IsIn_enrollment,:)
%虽然老师认为登陆时间和退出时间在同一天，所以没有记录访问课程的情况。
%但是这样不能解释三个异常！