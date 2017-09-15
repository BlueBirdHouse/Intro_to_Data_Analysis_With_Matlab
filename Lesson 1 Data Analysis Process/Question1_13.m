load('MatlabDatas.mat');
dailyengagement.Properties.VariableNames{'acct'} = 'account_key';

%将测试账户排除在外
c_True = categorical({'True'});
c_False = categorical({'False'});
test_accounts = (enrollments.is_udacity == c_True);
test_accounts = enrollments.account_key(test_accounts,:);
test_accounts = unique(test_accounts);
%调用函数去除测试账户
enrollments = remove_udacity_accounts(enrollments,test_accounts);
projectsubmissions = remove_udacity_accounts(projectsubmissions,test_accounts);
dailyengagement = remove_udacity_accounts(dailyengagement,test_accounts);
size(enrollments,1)
size(dailyengagement,1)
size(projectsubmissions,1)


function [Out] = remove_udacity_accounts(In,test_accounts)
    test_accounts_Row = ismember(In.account_key,test_accounts);
    In(test_accounts_Row,:) = [];
    Out = In;
end
