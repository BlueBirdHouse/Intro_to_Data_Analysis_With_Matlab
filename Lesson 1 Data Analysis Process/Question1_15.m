load('MatlabDatas.mat');
dailyengagement.Properties.VariableNames{'acct'} = 'account_key';

%将测试账户排除在外
c_True = categorical({'True'});
c_False = categorical({'False'});
test_accounts = (enrollments.is_udacity == c_True);
test_accounts = enrollments.account_key(test_accounts,:);
test_accounts = unique(test_accounts);
%调用函数去除测试账户
non_udacity_enrollments = remove_udacity_accounts(enrollments,test_accounts);
non_udacity_submissions = remove_udacity_accounts(projectsubmissions,test_accounts);
non_udacity_engagement = remove_udacity_accounts(dailyengagement,test_accounts);

% size(non_udacity_enrollments,1)
% size(non_udacity_engagement,1)
% size(non_udacity_submissions,1)

%完成任务1-14
%找出来那些"付款的学生"(paid_students)：
%1.至现在为止仍然没有退出的学生
%2.坚持超过7天的学生
%表应该包含：account_key + enrollment_date
%扩展，包含所有的变量，没必要减少收集到的信息。
c_canceled = categorical({'canceled'});
c_current = categorical({'current'});
StillIn = (non_udacity_enrollments.is_canceled == c_False);
StillIn = non_udacity_enrollments(StillIn,:);
Longer7 = (non_udacity_enrollments.days_to_cancel > 7);
Longer7 = non_udacity_enrollments(Longer7,:);
paid_students = [StillIn ; Longer7];
paid_students_Temp = paid_students;
paid_students_Temp(:,:) = [];
%精炼化paid_students，使其仅包含最新的enrollment_date
%仅保留paid_students里面最新的登陆记录
paid_students_account_key = unique(paid_students.account_key);
for Person = (paid_students_account_key)'
    find = (paid_students.account_key == Person);
    Person_record = paid_students(find,:);
    %个人信息升序排列
    Person_record = sortrows(Person_record,'join_date','ascend');
    %取最后一个，即为最新的信息
    Person_record = Person_record(end,:);
    paid_students_Temp = [paid_students_Temp ; Person_record];
end
paid_students = paid_students_Temp;

%完成任务1-15
%从dailyengagement完成任务1-15找到那些付款的学生在注册(join date)以后一周内的活动
%结果保存在paid_engagement_in_first_week
% 找到付款学生的所有活动信息
paid_enrollments = ismember(non_udacity_enrollments.account_key,paid_students.account_key);
paid_enrollments = non_udacity_enrollments(paid_enrollments,:);
paid_engagement = ismember(non_udacity_engagement.account_key,paid_students.account_key);
paid_engagement = non_udacity_engagement(paid_engagement,:);
paid_submissions = ismember(non_udacity_submissions.account_key,paid_students.account_key);
paid_submissions = non_udacity_engagement(paid_submissions,:);

%size(paid_enrollments,1)
n = size(paid_engagement,1);
%size(paid_submissions,1)

paid_engagement_in_first_week = paid_engagement;
paid_engagement_in_first_week(:,:) = [];
for i = 1:1:n
    data_point = paid_engagement(i,:);
    data_point_utc_date = data_point.utc_date;
    
    paid_students_join_date = paid_students((paid_students.account_key == data_point.account_key),:);
    paid_students_join_date = paid_students_join_date.join_date;
    
    if(within_one_week(paid_students_join_date, data_point_utc_date))
        paid_engagement_in_first_week = [paid_engagement_in_first_week ; data_point];
    end
    disp(i);
end

size(paid_engagement_in_first_week,1)


function [Out] = remove_udacity_accounts(In,test_accounts)
    test_accounts_Row = ismember(In.account_key,test_accounts);
    In(test_accounts_Row,:) = [];
    Out = In;
end

function [InOneWeek] = within_one_week(join_date, engagement_date)
    %测试两个时间是否在一周内,输入是datetime
    InOneWeek = (days(engagement_date - join_date) < 7);
end


