%�����ж�����Ԫ��
[enrollment_num_rows,~] = size(enrollments)
[engagement_num_rows,~] = size(dailyengagement)
[submission_num_rows,~] = size(projectsubmissions)

%�����ж��ٸ�ΨһԪ�أ�
[enrollment_num_unique_students,~] = size(unique(enrollments.account_key(:)))
[engagement_num_unique_students,~] = size(unique(dailyengagement.acct(:)))
[submission_num_unique_students,~] = size(unique(projectsubmissions.account_key(:)))