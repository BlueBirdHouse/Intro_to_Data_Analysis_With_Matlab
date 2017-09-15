%测试有多少行元素
[enrollment_num_rows,~] = size(enrollments)
[engagement_num_rows,~] = size(dailyengagement)
[submission_num_rows,~] = size(projectsubmissions)

%测试有多少个唯一元素：
[enrollment_num_unique_students,~] = size(unique(enrollments.account_key(:)))
[engagement_num_unique_students,~] = size(unique(dailyengagement.acct(:)))
[submission_num_unique_students,~] = size(unique(projectsubmissions.account_key(:)))