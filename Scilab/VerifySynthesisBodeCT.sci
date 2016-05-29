// ControlSynthesisBodeCT.sce

function VerifySynthesisBodeCT(Grat, Gdel, R, wmin, ndec, wcmin,wcmax, pmmin, wa1, wa2, AadB, wr1, wr2, ArdB, nfig)
    dmin              = floor(log10(wmin))
    w                 = logspace(dmin,dmin+ndec,500);
    f                 = w/2/%pi;
    hGrat             = repfreq(Grat,f);
    hR                = repfreq(R,f);
    [mLdB,pLdeg]      = dbphi(hR.*hGrat);
    pLdeg             = pLdeg-w*Gdel*180/%pi;
    [pm,fc]           = p_margin(R*Grat);
    wc                = 2*%pi*fc;
    pm                = pm-wc*Gdel*180/%pi;
    scf(nfig); clf;
    drawlater();
    subplot(211);
        plot(w,mLdB,'b');
        plot(w,zeros(w),'k:');
        plot([wcmin,wcmin],[-5,+5],'r');
        plot([wcmax,wcmax],[-5,+5],'g');
        if wa2-max(wa1,wmin)>0 & AadB>0
            xrect([max(wa1,wmin),AadB, wa2-max(wa1,wmin),AadB]);
        end;
        if min(wr2,max(w))-wr1>0 & -ArdB>0
            xrect([wr1,0,min(wr2,max(w))-wr1,-ArdB]);
        end;
        ax            = get("current_axes");
        ax.log_flags  = "ln";
        ylabel("|L(jw)|, dB");
    subplot(212);
        plot(w,pLdeg,'b');
        plot(w,-180*ones(w),'r');
        plot(w,(pmmin-180)*ones(w),'c');
        plot([wc,wc],[-180,pm-180],'g');
        ax            = get("current_axes");
        ax.log_flags  = "ln";
        xlabel("w (r/s)");
        ylabel("arg(L(jw)),deg");
        title(sprintf("wc= %f r/s, pm = %f deg", wc, pm));
    drawnow();               
endfunction;
//-----------------------------------------------------------------
s    = poly(0,'s');
//-----------------------------------------------------------------
// Dati del problema
    //Funzione di trasferimento della din. razionale del processo
    Grat = syslin('c', 5/(1+0.5*s));
    //Ritardo del processo (s, >=0)
    Gdel = 0;
    // Funzione di trasferimento del regolatore
    R    = syslin('c',(6*((1+s/0.6)^3)*(1+s/3)*(1+s/100))/(s*((1+s/0.2)^3)*(1-s/20)));
    // Valore minimo ammesso per la pulsazione critica wc (r/s)
    wcmin = 0.1;
    // Valore massimo ammesso per wc (r/s, eventualmente %inf)
    wcmax = 1;
    // Valore minimo ammesso per il margine di fase pm (deg)
    pmmin = 45;
    // Limite inf. della banda di da (r/s, event. 0 o %nan)
    wa1   = 0;
    // Limite sup. della banda di da (r/s, event. %nan)
    wa2   = 0.1;
    // Val minimo ammesso per |L| in [wa1,wa2] (dB, ev %nan)
    AadB  = 40;
    // Limite inf. della banda di dr (r/s, event %nan)
    wr1   = 200;
    // Limite inf della banda di da (r/s, event %nan o %inf)
    wr2   = 500;
    // Val massimo ammesso per |L| in [wr1,wa2] (dB, ev %nan)
    ArdB  = -60;
// Dati per il plot
    // Minima pulsazione sul plot semilogaritmico (r/s)
    wmin = 0.01;
    // Numerdo di decadi sul plot semilogaritmico (#)
    ndec = 4;
    // Numero della finestra grafica da usare (>=0)
    nfig = 0;
//----------------------------------------------------------------------
VerifySynthesisBodeCT(Grat, Gdel, R, wmin, ndec, wcmin, wcmax, pmmin, wa1, wa2, AadB, wr1, wr2,ArdB,nfig);