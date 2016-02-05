function plot_all_cocaine(G,urine_pda,pda)
ind=find(urine_pda.pda>0);
for i=ind
    pid=urine_pda.pid{i};
    sid=urine_pda.sid{i};
    plot_rr_activity_mark_cocaine(G,pid,sid,urine_pda,pda);
end
end