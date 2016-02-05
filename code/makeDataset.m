clear all
close all
G=config();
% G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
% G=config_run_MinnesotaLab(G);
    G=config_run_MinnesotaLab_dataset(G);
PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s \n',pid,sid);
        INDIR='frmtdata';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if isempty([indir G.DIR.SEP infile]),    disp(['FILE NOT FOUND' indir G.DIR.SEP infile]);return;end; load([indir G.DIR.SEP infile]);
  
		D1 = D;
		D2=D;
		
		D2.sensor{G.SENSOR.WL9_ACLXID} = D.sensor{G.SENSOR.WR9_ACLXID};
		D2.sensor{G.SENSOR.WL9_ACLYID} = D.sensor{G.SENSOR.WR9_ACLYID};
		D2.sensor{G.SENSOR.WL9_ACLZID} = D.sensor{G.SENSOR.WR9_ACLZID};
		D2.sensor{G.SENSOR.WL9_GYRXID} = D.sensor{G.SENSOR.WR9_GYRXID};
		D2.sensor{G.SENSOR.WL9_GYRYID} = D.sensor{G.SENSOR.WR9_GYRYID};
		D2.sensor{G.SENSOR.WL9_GYRZID} = D.sensor{G.SENSOR.WR9_GYRZID};
		D2.sensor{G.SENSOR.WL9_NULLID} = D.sensor{G.SENSOR.WR9_NULLID};
		
		D2.sensor{G.SENSOR.WR9_ACLXID} = D.sensor{G.SENSOR.WL9_ACLXID};
		D2.sensor{G.SENSOR.WR9_ACLYID} = D.sensor{G.SENSOR.WL9_ACLYID};
		D2.sensor{G.SENSOR.WR9_ACLZID} = D.sensor{G.SENSOR.WL9_ACLZID};
		D2.sensor{G.SENSOR.WR9_GYRXID} = D.sensor{G.SENSOR.WL9_GYRXID};
		D2.sensor{G.SENSOR.WR9_GYRYID} = D.sensor{G.SENSOR.WL9_GYRYID};
		D2.sensor{G.SENSOR.WR9_GYRZID} = D.sensor{G.SENSOR.WL9_GYRZID};
		D2.sensor{G.SENSOR.WR9_NULLID} = D.sensor{G.SENSOR.WL9_NULLID};
        %------- change orientation -----------------------
% 		D3=D1;
%         D3.sensor{G.SENSOR.WL9_ACLXID}.sample = -D1.sensor{G.SENSOR.WL9_ACLXID}.sample;
%         D3.sensor{G.SENSOR.WL9_ACLYID}.sample = -D1.sensor{G.SENSOR.WL9_ACLYID}.sample;
%         D3.sensor{G.SENSOR.WR9_ACLXID}.sample = -D1.sensor{G.SENSOR.WR9_ACLXID}.sample;
%         D3.sensor{G.SENSOR.WR9_ACLYID}.sample = -D1.sensor{G.SENSOR.WR9_ACLYID}.sample;
% 		
% 		D4=D2;
% 		D4.sensor{G.SENSOR.WL9_ACLXID}.sample = -D2.sensor{G.SENSOR.WL9_ACLXID}.sample;
%         D4.sensor{G.SENSOR.WL9_ACLYID}.sample = -D2.sensor{G.SENSOR.WL9_ACLYID}.sample;
%         D4.sensor{G.SENSOR.WR9_ACLXID}.sample = -D2.sensor{G.SENSOR.WR9_ACLXID}.sample;
%         D4.sensor{G.SENSOR.WR9_ACLYID}.sample = -D2.sensor{G.SENSOR.WR9_ACLYID}.sample;
%         ---------------------end-----------------------------------

        %change korte hobe
        %B.selfreport=read_selfreport_smokingposition(G,pid,sid,'raw',B);
        
        OUTDIR='frmtdata';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
		D=D1;
        outfile=[pid '_' sid  '1_' OUTDIR '.mat'];if isempty(dir(outdir)), mkdir(outdir);end; save([outdir G.DIR.SEP outfile],'D');
        D=D2;
		outfile=[pid '_' sid  '2_' OUTDIR '.mat'];if isempty(dir(outdir)), mkdir(outdir);end; save([outdir G.DIR.SEP outfile],'D');
%         D=D3;
% 		outfile=[pid '_' sid  '3_' OUTDIR '.mat'];if isempty(dir(outdir)), mkdir(outdir);end; save([outdir G.DIR.SEP outfile],'D');
% 		D=D4;
%         outfile=[pid '_' sid  '4_' OUTDIR '.mat'];if isempty(dir(outdir)), mkdir(outdir);end; save([outdir G.DIR.SEP outfile],'D');
        
%        plot_custom(G,pid,sid,'basicfeature','b_figure',[G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID],'peakvalley','bar',[-700,0,700],'save',[5,5],'smokinglabel');
    end
end
