within ;
model BuildingTimeSerieswithChillerBorefield
  extends PartialBuildingwithChillerBorefield(
  redeclare Buildings.Experimental.DHC.Loads.Examples.BaseClasses.BuildingTimeSeries bui(
      final filNam=filNam,
      have_hotWat=false,
      facMulHea=10*QHea_flow_nominal/(1.7E5),
      facMulCoo=40*QCoo_flow_nominal/(-1.5E5)),
    ets(
      have_hotWat=false,
      QChiWat_flow_nominal=QCoo_flow_nominal,
      QHeaWat_flow_nominal=QHea_flow_nominal,
      QHotWat_flow_nominal=QHot_flow_nominal));

  parameter Modelica.SIunits.Temperature TChiWatSup_nominal=291.15
    "Chilled water supply temperature"
    annotation(Dialog(group="ETS model parameters"));

  parameter Modelica.SIunits.Temperature THeaWatSup_nominal=313.15
    "Heating water supply temperature"
    annotation(Dialog(group="ETS model parameters"));

  parameter String filNam
    "Library path of the file with thermal loads as time series";
  final parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(
    max=-Modelica.Constants.eps)=bui.facMul * bui.QCoo_flow_nominal
    "Space cooling design load (<=0)"
    annotation (Dialog(group="Design parameter"));
  final parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)=bui.facMul * bui.QHea_flow_nominal
    "Space heating design load (>=0)"
    annotation (Dialog(group="Design parameter"));
  final parameter Modelica.SIunits.HeatFlowRate QHot_flow_nominal(
    min=Modelica.Constants.eps)=bui.facMul *
    Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
      string="#Peak water heating load",
      filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Hot water design load (>=0)"
    annotation (Dialog(group="Design parameter"));

  Buildings.Controls.OBC.CDL.Continuous.Gain loaHeaNor(k=1/bui.QHea_flow_nominal)
    "Normalized heating load"
    annotation (Placement(transformation(extent={{-128,-110},{-108,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold enaHeaCoo[2](each t=1e-4)
    "Threshold comparison to enable heating and cooling"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain loaCooNor(k=1/bui.QCoo_flow_nominal)
    "Normalized cooling load"
    annotation (Placement(transformation(extent={{-128,-150},{-108,-130}})));


equation
  connect(enaHeaCoo[1].y, ets.uHea) annotation (Line(points={{-58,-120},{-46,-120},
          {-46,-48},{-34,-48}}, color={255,0,255}));
  connect(enaHeaCoo[2].y, ets.uCoo) annotation (Line(points={{-58,-120},{-42,-120},
          {-42,-54},{-34,-54}}, color={255,0,255}));
  connect(loaHeaNor.y, enaHeaCoo[1].u) annotation (Line(points={{-106,-100},{-100,
          -100},{-100,-120},{-82,-120}}, color={0,0,127}));
  connect(loaCooNor.y, enaHeaCoo[2].u) annotation (Line(points={{-106,-140},{-100,
          -140},{-100,-120},{-82,-120}}, color={0,0,127}));
  connect(bui.QReqHea_flow, loaHeaNor.u) annotation (Line(points={{20,4},{20,-2},
          {-140,-2},{-140,-100},{-130,-100}}, color={0,0,127}));
  connect(bui.QReqCoo_flow, loaCooNor.u) annotation (Line(points={{24,4},{24,-6},
          {-136,-6},{-136,-140},{-130,-140}}, color={0,0,127}));
  connect(loaHeaNor.y, resTHeaWatSup.u) annotation (Line(points={{-106,-100},{-100,
          -100},{-100,-60},{-120,-60},{-120,-40},{-112,-40}}, color={0,0,127}));


  annotation (uses(PartialBuildingwithChillerBorefield(version="1")));
end BuildingTimeSerieswithChillerBorefield;
