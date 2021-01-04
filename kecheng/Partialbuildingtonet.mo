within ;
partial model Partialbuildingtonet
  "Partial model for buildings connected to distribution network"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  constant Real facMul = 10
    "Building loads multiplier factor";
  parameter Real dpDis_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate - Distribution line";
  parameter Real dpCon_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate - Connection line";
  parameter Boolean allowFlowReversalSer = true
    "Set to true to allow flow reversal in the service lines"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalBui = false
    "Set to true to allow flow reversal for in-building systems"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Integer nBui = datDes.nBui
    "Number of buildings connected to DHC system"
    annotation (Evaluate=true);
  // COMPONENTS
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumDis(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datDes.mDis_flow_nominal,
    final allowFlowReversal=allowFlowReversalSer)
    "Distribution pump"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=90,
      origin={80,-60})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=Medium,
    final nPorts=1)
    "Boundary pressure condition representing the expansion vessel"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={112,-20})));
  Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Networks.UnidirectionalSeries dis(
    redeclare final package Medium = Medium,
    final nCon=nBui,
    final mDis_flow_nominal=datDes.mDis_flow_nominal,
    final dp_length_nominal=datDes.dp_length_nominal,
    final lDis=datDes.lDis,
    final lCon=datDes.lCon,
    final lEnd=datDes.lEnd,
    final allowFlowReversal=allowFlowReversalSer)
    "Distribution network"
    annotation (Placement(transformation(extent={{-20,130},{20,150}})));
    //final mCon_flow_nominal=datDes.mCon_flow_nominal,
  Buildings.Fluid.Sensors.TemperatureTwoPort TDisWatRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datDes.mDis_flow_nominal)
    "District water return temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,0})));
  replaceable BuildingTimeSerieswithChillerBorefield bui[nBui]
    constrainedby BuildingTimeSerieswithChillerBorefield(
      bui(each final facMul=facMul),
      redeclare each final package MediumBui=Medium,
      redeclare each final package MediumSer=Medium,
      each final allowFlowReversalBui=allowFlowReversalBui,
      each final allowFlowReversalSer=allowFlowReversalSer)
    "Building and ETS"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
    //need to set parameters
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupMaxSet[nBui](k=bui.THeaWatSup_nominal)
    "Heating water supply temperature set point - Maximum value"
    annotation (Placement(transformation(extent={{-250,210},{-230,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet[nBui](
    k=bui.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-220,190},{-200,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupMinSet[nBui](
    each k=28 + 273.15)
    "Heating water supply temperature set point - Minimum value"
    annotation (Placement(transformation(extent={{-280,230},{-260,250}})));
  inner parameter Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Data.DesignDataSeries
                                        datDes
    "Design data"
    annotation (Placement(transformation(extent={{-328,184},{-308,204}})));
equation
  connect(bou.ports[1], pumDis.port_a)
    annotation (Line(points={{102,-20},{80,-20},{80,-50}}, color={0,127,255}));
  connect(dis.port_bDisSup, TDisWatRet.port_a)
    annotation (Line(points={{20,140},{80,140},{80,10}}, color={0,127,255}));
  connect(TDisWatRet.port_b, pumDis.port_a)
    annotation (Line(points={{80,-10},{80,-50}}, color={0,127,255}));
  connect(bui.port_bSerAmb, dis.ports_aCon) annotation (Line(points={{10,180},{20,
          180},{20,160},{12,160},{12,150}}, color={0,127,255}));
  connect(dis.ports_bCon, bui.port_aSerAmb) annotation (Line(points={{-12,150},{
          -12,160},{-20,160},{-20,180},{-10,180}}, color={0,127,255}));
  connect(THeaWatSupMaxSet.y, bui.THeaWatSupMaxSet) annotation (Line(points={{-228,
          220},{-20,220},{-20,187},{-12,187}}, color={0,0,127}));
  connect(TChiWatSupSet.y, bui.TChiWatSupSet) annotation (Line(points={{-198,200},
          {-24,200},{-24,185},{-12,185}},      color={0,0,127}));
  connect(THeaWatSupMinSet.y, bui.THeaWatSupMinSet) annotation (Line(points={{-258,
          240},{-16,240},{-16,189},{-12,189}}, color={0,0,127}));
  connect(dis.port_aDisSup, pumDis.port_b) annotation (Line(points={{-20,140},{-34,140},
          {-34,-108},{80,-108},{80,-70}}, color={0,127,255}));
  annotation (Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,260}})),
    experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760),
    uses(Buildings(version="8.0.0")));
end Partialbuildingtonet;
