load('MatlabDatas.mat');
dailyengagement.Properties.VariableNames{'acct'} = 'account_key';

account_engagement = dailyengagement.account_key(:);
account_enrollment = enrollments.account_key(:);
%�������������ϵĽ����е�Ԫ��
account_XOR = setxor(account_engagement,account_enrollment);

%�����Щ�����Ƿ���engagement��
IsIn_engagement = ismember(account_XOR,account_engagement);
sum(IsIn_engagement)
%˵��account_engagement��һ��С���ϣ������ڴ󼯺����档
IsIn_enrollment = ismember(account_enrollment,account_XOR);
enrollments(IsIn_enrollment,:)
%��Ȼ��ʦ��Ϊ��½ʱ����˳�ʱ����ͬһ�죬����û�м�¼���ʿγ̵������
%�����������ܽ��������쳣��