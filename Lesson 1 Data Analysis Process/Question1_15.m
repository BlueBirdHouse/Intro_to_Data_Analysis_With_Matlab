load('MatlabDatas.mat');
dailyengagement.Properties.VariableNames{'acct'} = 'account_key';

%�������˻��ų�����
c_True = categorical({'True'});
c_False = categorical({'False'});
test_accounts = (enrollments.is_udacity == c_True);
test_accounts = enrollments.account_key(test_accounts,:);
test_accounts = unique(test_accounts);
%���ú���ȥ�������˻�
non_udacity_enrollments = remove_udacity_accounts(enrollments,test_accounts);
non_udacity_submissions = remove_udacity_accounts(projectsubmissions,test_accounts);
non_udacity_engagement = remove_udacity_accounts(dailyengagement,test_accounts);

% size(non_udacity_enrollments,1)
% size(non_udacity_engagement,1)
% size(non_udacity_submissions,1)

%�������1-14
%�ҳ�����Щ"�����ѧ��"(paid_students)��
%1.������Ϊֹ��Ȼû���˳���ѧ��
%2.��ֳ���7���ѧ��
%��Ӧ�ð�����account_key + enrollment_date
%��չ���������еı�����û��Ҫ�����ռ�������Ϣ��
c_canceled = categorical({'canceled'});
c_current = categorical({'current'});
StillIn = (non_udacity_enrollments.is_canceled == c_False);
StillIn = non_udacity_enrollments(StillIn,:);
Longer7 = (non_udacity_enrollments.days_to_cancel > 7);
Longer7 = non_udacity_enrollments(Longer7,:);
paid_students = [StillIn ; Longer7];
paid_students_Temp = paid_students;
paid_students_Temp(:,:) = [];
%������paid_students��ʹ����������µ�enrollment_date
%������paid_students�������µĵ�½��¼
paid_students_account_key = unique(paid_students.account_key);
for Person = (paid_students_account_key)'
    find = (paid_students.account_key == Person);
    Person_record = paid_students(find,:);
    %������Ϣ��������
    Person_record = sortrows(Person_record,'join_date','ascend');
    %ȡ���һ������Ϊ���µ���Ϣ
    Person_record = Person_record(end,:);
    paid_students_Temp = [paid_students_Temp ; Person_record];
end
paid_students = paid_students_Temp;

%�������1-15
%��dailyengagement�������1-15�ҵ���Щ�����ѧ����ע��(join date)�Ժ�һ���ڵĻ
%���������paid_engagement_in_first_week
% �ҵ�����ѧ�������л��Ϣ
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
    %��������ʱ���Ƿ���һ����,������datetime
    InOneWeek = (days(engagement_date - join_date) < 7);
end


