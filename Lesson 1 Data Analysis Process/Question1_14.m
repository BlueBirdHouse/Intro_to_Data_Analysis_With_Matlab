load('MatlabDatas.mat');
dailyengagement.Properties.VariableNames{'acct'} = 'account_key';

%�������˻��ų�����
c_True = categorical({'True'});
c_False = categorical({'False'});
test_accounts = (enrollments.is_udacity == c_True);
test_accounts = enrollments.account_key(test_accounts,:);
test_accounts = unique(test_accounts);
%���ú���ȥ�������˻�
enrollments = remove_udacity_accounts(enrollments,test_accounts);
projectsubmissions = remove_udacity_accounts(projectsubmissions,test_accounts);
dailyengagement = remove_udacity_accounts(dailyengagement,test_accounts);
size(enrollments,1)
size(dailyengagement,1)
size(projectsubmissions,1)

%�������1-14
%�ҳ�����Щ"�����ѧ��"(paid_students)��
%1.������Ϊֹ��Ȼû���˳���ѧ��
%2.��ֳ���7���ѧ��
%��Ӧ�ð�����account_key + enrollment_date
%��չ���������еı�����û��Ҫ�����ռ�������Ϣ��
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
