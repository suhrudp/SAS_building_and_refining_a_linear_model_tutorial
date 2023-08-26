/* IMPORT DATA*/
proc print data=cars;
run;

/*VISUALIZE DATA*/
proc sgplot data=cars;
	reg x=Weight y=MPG_City / lineattrs=(thickness=3 color=red) nomarkers;
	scatter x=Weight y=MPG_City /;
	xaxis grid;
	yaxis grid;
run;
quit;

/*BUILDING A LINEAR MODEL*/
proc reg data=cars alpha=0.05 plots(only)=(diagnostics(stats=(aic)) residuals fitplot 
		observedbypredicted);
	model MPG_City=Weight / clb;
run;
quit;

/*USING RESTRICTED CUBIC SPLINES TO FIT DATA*/
proc glmselect data=cars;
  effect spl = spline(weight / details naturalcubic basis=tpf(noint)                 
                               knotmethod=percentiles(5) );
   model mpg_city = spl / selection=none;
   output out=SplineOut predicted=Fit;
quit;
 
proc sgplot data=SplineOut noautolegend;
   scatter x=weight y=mpg_city;
   series x=weight y=Fit / lineattrs=(thickness=3 color=red);
run;