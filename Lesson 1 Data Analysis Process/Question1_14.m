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

%完成任务1-14
%找出来那些"付款的学生"(paid_students)：
%1.至现在为止仍然没有退出的学生
%2.坚持超过7天的学生
%表应该包含：account_key + enrollment_date
%扩展，包含所有的变量，没必要减少收集到的信息。
c_canceled = categorical({'canceled'});
c_current = categorical({'current'});
StillIn = (enrollments.is_canceled == c_False);
StillIn = enrollments(StillIn,:);
Longer7 = (enrollments.days_to_cancel > 7);
Longer7 = enrollments(Longer7,:);
paid_students = [StillIn ; Longer7];
size(unique(paid_students.account_key),1)


function [Out] = remove_udacity_accounts(In,test_accounts)
    test_accounts_Row = ismember(In.account_key,test_accounts);
    In(test_accounts_Row,:) = [];
    Out = In;
end
