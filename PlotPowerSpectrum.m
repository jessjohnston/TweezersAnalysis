function  PlotPowerSpectrum(fb_plot,Pb_plot)

hd = plot(fb_plot, Pb_plot, '-k'); set(hd,'LineWidth',0.7);
h = xlabel('Frequency (Hz)'); set(h,'FontUnits','normalized','FontSize',0.04,'FontWeight','bold');
h = ylabel(['P(f) (arbitrary units) ']); set(h,'FontUnits','normalized','FontSize',0.04,'FontWeight','bold');
set(gca,'XScale','log','YScale','log','FontUnits','normalized','FontSize',0.04,'FontWeight','bold');


end