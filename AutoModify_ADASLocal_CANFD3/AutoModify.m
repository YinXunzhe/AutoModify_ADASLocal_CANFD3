% ����������ADAS Local CANFD��ӦIOģ�����ź��б�˳��仯�������޸�BusSlector�е��ź�˳�򣬲�����������ֵ����mapping
for i = 1:16
    src=sprintf('ADAS_LocalCANFD3_Model_EP2/CANIOModel_LocalCANFD3/CANIO/MDLSoftECUDataToBus/ADAS_Local_CANFD3/FDR_ADAS_LocalCANFD3_FrP%02d/FDR_ADAS_LocalCANFD3_FrP%02d/SignalSelector',i,i);
    id=2*i-1;
    modify_adas_local_canfd3(src,id);
end