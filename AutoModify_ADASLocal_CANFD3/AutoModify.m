% 本程序用于ADAS Local CANFD对应IO模型中信号列表顺序变化后，批量修改BusSlector中的信号顺序，并重新与物理值进行mapping
for i = 1:16
    src=sprintf('ADAS_LocalCANFD3_Model_EP2/CANIOModel_LocalCANFD3/CANIO/MDLSoftECUDataToBus/ADAS_Local_CANFD3/FDR_ADAS_LocalCANFD3_FrP%02d/FDR_ADAS_LocalCANFD3_FrP%02d/SignalSelector',i,i);
    id=2*i-1;
    modify_adas_local_canfd3(src,id);
end