function modify_adas_local_canfd3(src,id)
% 由于不同造车阶段的数据库会发生变化，因此需要重新把Can信号mapping到仿真的物理信号。
% 本程序用于IO模型中信号列表顺序变化后，批量修改BusSlector中的信号顺序，并重新与物理值进行mapping
% 输入参数src为需要修改的SignalSelector子模块所在路径;id为该子模块下要修改的首个Obj序号
% 如 src='ADAS_LocalCANFD3_Model_EP2/CANIOModel_LocalCANFD3/CANIO/MDLSoftECUDataToBus/ADAS_Local_CANFD3/FDR_ADAS_LocalCANFD3_FrP02/FDR_ADAS_LocalCANFD3_FrP02/SignalSelector'
%    id=3
% author：YinXunzhe date:2021/12/8
%% 删除当前SignalSelector中需要手动mapping的模块和相应的信号线
% 使用正则表达式删除具有如下名字的Constant模块
% 以Constant_MRR_Obj开头，以_加一个数字结尾，
% 中间可以是ID、DistY、DistX、Type、RelVelX、AccelX、RelVelY、AccelY\MovingSts
pattern='Constant_MRR_Obj(ID|Dist(X|Y)|Type|RelVel(X|Y)|Accel(X|Y)|MovingSts)_\d*';
ConstCell=find_system(src,'regexp','on','BlockType','Constant','Name',pattern);
for i = 1:length(ConstCell)
    delete_block(ConstCell{i})
end
% 删除残余的连接线
delete_line(find_system(src,'findall','on','Type','Line','Connected','off'));
%% 增加BusSelector模块，并按需调整信号顺序及连线
% 生成选择信号列表，用于后续属性设置
A=repelem(id,8);
B=repelem(id+1,8);
format_par='Obj_id.obj_id%d,Obj_dy.obj_dy%d,Obj_dx.obj_dx%d,Obj_type.obj_type%d,Obj_RelVelX.obj_vx%d,Obj_ax.obj_ax%d,Obj_RelVelY.obj_vy%d,Obj_ay.obj_ay%d';
par_str1=sprintf(format_par,A);
par_str2=sprintf(format_par,B);
par_str3=sprintf('ObjMovingSts.ObjMovingSts%d,ObjMovingSts.ObjMovingSts%d',id+1,id);
% 生成要连接的Goto模块端口，用于后续连线
GotoPortCell=@(i){sprintf('MRR_ObjID_%d|Goto/1',i),sprintf('MRR_ObjDistY_%d|Goto/1',i),...
   sprintf('MRR_ObjDistX_%d|Goto/1',i),sprintf('MRR_ObjType_%d|Goto/1',i),...
   sprintf('MRR_ObjRelVelX_%d|Goto/1',i),sprintf('MRR_ObjAccelX_%d|Goto/1',i),...
   sprintf('MRR_ObjRelVelY_%d|Goto/1',i),sprintf('MRR_ObjAccelY_%d|Goto/1',i)};
signal_port1=GotoPortCell(id);
signal_port2=GotoPortCell(id+1);
signal_port3={sprintf('MRR_ObjMovingSts_%d|Goto/1',id+1),sprintf('MRR_ObjMovingSts_%d|Goto/1',id)};
% 添加第1个BusSelector
bs1=strcat(src,'/Bus Selector');
add_block('simulink/Commonly Used Blocks/Bus Selector',bs1,'position','[345,569,355,1201]');
add_line(src,'FromMDL/1','Bus Selector/1','autorouting','on');
set_param(bs1,'OutputSignals',par_str1);
add_line(src,...
    {'Bus Selector/1','Bus Selector/2','Bus Selector/3','Bus Selector/4','Bus Selector/5','Bus Selector/6','Bus Selector/7','Bus Selector/8'},...
    signal_port1,...
    'autorouting','on')
% 添加第2个BusSelector
bs2=strcat(src,'/Bus Selector1');
add_block('simulink/Commonly Used Blocks/Bus Selector',bs2,'position','[345,2169,355,2801]');
add_line(src,'FromMDL/1','Bus Selector1/1','autorouting','on');
set_param(bs2,'OutputSignals',par_str2);
add_line(src,...
    {'Bus Selector1/1','Bus Selector1/2','Bus Selector1/3','Bus Selector1/4','Bus Selector1/5','Bus Selector1/6','Bus Selector1/7','Bus Selector1/8'},...
    signal_port2,...
    'autorouting','on')
% 添加第3个BusSelector
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