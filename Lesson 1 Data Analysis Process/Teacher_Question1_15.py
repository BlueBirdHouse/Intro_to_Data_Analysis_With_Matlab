# -*- coding: utf-8 -*-
"""
这个文件是为了找到作业：1-15错误而复制的教师文件
Matlab的计算结果和Python不一致

"""
#包导入区
import unicodecsv
import datetime

#函数定义区
def read_csv(filename):
    #读取文件函数
    with open(filename, 'rb') as f:
        reader = unicodecsv.DictReader(f)
        return list(reader)

def get_unique_students(data):
    #产生唯一账户标识的函数
    unique_students = set()
    for data_point in data:
        unique_students.add(data_point['account_key'])
    return unique_students

def remove_udacity_accounts(data,undacity_test_accounts):
    #移除测试账户
    non_udacity_data = []
    for data_point in data:
        if data_point['account_key'] not in undacity_test_accounts:
            non_udacity_data.append(data_point)
    return non_udacity_data

def within_one_week(join_date, engagement_date):
    #测试两个时间是否在一周内
    #输入是时间
    time_delta = engagement_date - join_date
    return time_delta.days < 7 and time_delta.days >=0

def remove_free_trial_cancels(data,paid_students):
    new_data = []
    for data_point in data:
        if data_point['account_key'] in paid_students:
            new_data.append(data_point)
    return new_data

#文件读入区
enrollments = read_csv('enrollments.csv')
daily_engagement = read_csv('daily-engagement.csv')
project_submissions = read_csv('project-submissions.csv')

#改变daily_engagement里面的acct记录为一致的account_key
for engagement_record in daily_engagement:
    engagement_record['account_key'] = engagement_record['acct']
    del[engagement_record['acct']]

#生成唯一账户集合
unique_enrolled_students = get_unique_students(enrollments)
unique_engagement_students = get_unique_students(daily_engagement)
unique_project_submitters = get_unique_students(project_submissions)

#下面的可以和Matlab对应
# Matlab = 将测试账户排除在外
#生成测试账户数据集
undacity_test_accounts = set()
for enrollment in enrollments:
    #教师代码在这里有问题，'is_udacity'字段是一个字符串，不可以直接入if语句判断
    if enrollment['is_udacity']== 'True':
        undacity_test_accounts.add(enrollment['account_key'])

non_udacity_enrollments = remove_udacity_accounts(enrollments,undacity_test_accounts)
non_udacity_engagement = remove_udacity_accounts(daily_engagement,undacity_test_accounts)
non_udacity_submissions = remove_udacity_accounts(project_submissions,undacity_test_accounts)

#完成任务1-14
paid_students = {}
for enrollment in non_udacity_enrollments:
    if (enrollment['is_canceled'] == 'False') or (int(enrollment['days_to_cancel']) > 7):
        account_key = enrollment['account_key']
        enrollment_date = enrollment['join_date']

        if (account_key not in paid_students): 
            paid_students[account_key] = enrollment_date
    
        AlreadyIn = datetime.datetime.strptime(paid_students[account_key], '%Y-%m-%d')
        enrollment_date_D = datetime.datetime.strptime(enrollment_date, '%Y-%m-%d')
        delta = enrollment_date_D - AlreadyIn
        if delta.days > 0:
            paid_students[account_key] = enrollment_date

#完成任务1-15
#移除没有付款的账户
paid_enrollments = remove_free_trial_cancels(non_udacity_enrollments,paid_students)
paid_engagement = remove_free_trial_cancels(non_udacity_engagement,paid_students)
paid_submissions = remove_free_trial_cancels(non_udacity_submissions,paid_students)

print(len(paid_enrollments))
print(len(paid_engagement))
print(len(paid_submissions))

paid_engagement_in_first_week = []
Counter = 0
for data_point in paid_engagement:
    data_point_utc_date = data_point['utc_date']
    data_point_utc_date = datetime.datetime.strptime(data_point_utc_date, '%Y-%m-%d')
    data_point_account_key = data_point['account_key']

    paid_students_join_date = paid_students[data_point_account_key]
    paid_students_join_date = datetime.datetime.strptime(paid_students_join_date, '%Y-%m-%d')

    if within_one_week(paid_students_join_date, data_point_utc_date):
        paid_engagement_in_first_week.append(data_point)

    Counter = Counter + 1
    print(Counter)

print(len(paid_engagement_in_first_week))









 


