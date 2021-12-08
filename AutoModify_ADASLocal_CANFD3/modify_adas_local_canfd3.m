function modify_adas_local_canfd3(src,id)
% ���ڲ�ͬ�쳵�׶ε����ݿ�ᷢ���仯�������Ҫ���°�Can�ź�mapping������������źš�
% ����������IOģ�����ź��б�˳��仯�������޸�BusSlector�е��ź�˳�򣬲�����������ֵ����mapping
% �������srcΪ��Ҫ�޸ĵ�SignalSelector��ģ������·��;idΪ����ģ����Ҫ�޸ĵ��׸�Obj���
% �� src='ADAS_LocalCANFD3_Model_EP2/CANIOModel_LocalCANFD3/CANIO/MDLSoftECUDataToBus/ADAS_Local_CANFD3/FDR_ADAS_LocalCANFD3_FrP02/FDR_ADAS_LocalCANFD3_FrP02/SignalSelector'
%    id=3
% author��YinXunzhe date:2021/12/8
%% ɾ����ǰSignalSelector����Ҫ�ֶ�mapping��ģ�����Ӧ���ź���
% ʹ��������ʽɾ�������������ֵ�Constantģ��
% ��Constant_MRR_Obj��ͷ����_��һ�����ֽ�β��
% �м������ID��DistY��DistX��Type��RelVelX��AccelX��RelVelY��AccelY\MovingSts
pattern='Constant_MRR_Obj(ID|Dist(X|Y)|Type|RelVel(X|Y)|Accel(X|Y)|MovingSts)_\d*';
ConstCell=find_system(src,'regexp','on','BlockType','Constant','Name',pattern);
for i = 1:length(ConstCell)
    delete_block(ConstCell{i})
end
% ɾ�������������
delete_line(find_system(src,'findall','on','Type','Line','Connected','off'));
%% ����BusSelectorģ�飬����������ź�˳������
% ����ѡ���ź��б����ں�����������
A=repelem(id,8);
B=repelem(id+1,8);
format_par='Obj_id.obj_id%d,Obj_dy.obj_dy%d,Obj_dx.obj_dx%d,Obj_type.obj_type%d,Obj_RelVelX.obj_vx%d,Obj_ax.obj_ax%d,Obj_RelVelY.obj_vy%d,Obj_ay.obj_ay%d';
par_str1=sprintf(format_par,A);
par_str2=sprintf(format_par,B);
par_str3=sprintf('ObjMovingSts.ObjMovingSts%d,ObjMovingSts.ObjMovingSts%d',id+1,id);
% ����Ҫ���ӵ�Gotoģ��˿ڣ����ں�������
GotoPortCell=@(i){sprintf('MRR_ObjID_%d|Goto/1',i),sprintf('MRR_ObjDistY_%d|Goto/1',i),...
   sprintf('MRR_ObjDistX_%d|Goto/1',i),sprintf('MRR_ObjType_%d|Goto/1',i),...
   sprintf('MRR_ObjRelVelX_%d|Goto/1',i),sprintf('MRR_ObjAccelX_%d|Goto/1',i),...
   sprintf('MRR_ObjRelVelY_%d|Goto/1',i),sprintf('MRR_ObjAccelY_%d|Goto/1',i)};
signal_port1=GotoPortCell(id);
signal_port2=GotoPortCell(id+1);
signal_port3={sprintf('MRR_ObjMovingSts_%d|Goto/1',id+1),sprintf('MRR_ObjMovingSts_%d|Goto/1',id)};
% ��ӵ�1��BusSelector
bs1=strcat(src,'/Bus Selector');
add_block('simulink/Commonly Used Blocks/Bus Selector',bs1,'position','[345,569,355,1201]');
add_line(src,'FromMDL/1','Bus Selector/1','autorouting','on');
set_param(bs1,'OutputSignals',par_str1);
add_line(src,...
    {'Bus Selector/1','Bus Selector/2','Bus Selector/3','Bus Selector/4','Bus Selector/5','Bus Selector/6','Bus Selector/7','Bus Selector/8'},...
    signal_port1,...
    'autorouting','on')
% ��ӵ�2��BusSelector
bs2=strcat(src,'/Bus Selector1');
add_block('simulink/Commonly Used Blocks/Bus Selector',bs2,'position','[345,2169,355,2801]');
add_line(src,'FromMDL/1','Bus Selector1/1','autorouting','on');
set_param(bs2,'OutputSignals',par_str2);
add_line(src,...
    {'Bus Selector1/1','Bus Selector1/2','Bus Selector1/3','Bus Selector1/4','Bus Selector1/5','Bus Selector1/6','Bus Selector1/7','Bus Selector1/8'},...
    signal_port2,...
    'autorouting','on')
% ��ӵ�3��BusSelector
bs3=strcat(src,'/Bus Selector2');
add_block('simulink/Commonly Used Blocks/Bus Selector',bs3,'position','[345,3444,355,3606]');
add_line(src,'FromMDL/1','Bus Selector2/1','autorouting','on');
set_param(bs3,'OutputSignals',par_str3);
add_line(src,...
    {'Bus Selector2/1','Bus Selector2/2'},...
    signal_port3,...
    'autorouting','on')

fprintf('FDR_ADAS_LocalCANFD3_FrP%02d is processed!\n',(id+1)/2);
end