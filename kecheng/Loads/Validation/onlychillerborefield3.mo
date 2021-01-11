within kecheng.Loads.Validation;
model Onlychillerborefield3
"Partial validation of the ETS model with heat recovery chiller and optional borefield"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
  parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal=0.9*datChi.mCon_flow_nominal
    "Nominal heating water mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal=0.9*datChi.mEva_flow_nominal
    "Nominal chilled water mass flow rate";
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(
    max=-Modelica.Constants.eps)=-1e6
    "Design cooling heat flow rate (<=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)=abs(
    QCoo_flow_nominal)*(1+1/datChi.COP_nominal)
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic datChi(
    QEva_flow_nominal=QCoo_flow_nominal,
    COP_nominal=3,
    PLRMax=1,
    PLRMinUnl=0.3,
    PLRMin=0.3,
    etaMotor=1,
    mEva_flow_nominal=abs(
      QCoo_flow_nominal)/5/4186,
    mCon_flow_nominal=QHea_flow_nominal/5/4186,
    TEvaLvg_nominal=277.15,
    capFunT={1.72,0.02,0,-0.02,0,0},
    EIRFunT={0.28,-0.02,0,0.02,0,0},
    EIRFunPLR={0.1,0.9,0},
    TEvaLvgMin=277.15,
    TEvaLvgMax=288.15,
    TConEnt_nominal=313.15,
    TConEntMin=298.15,
    TConEntMax=328.15)
    "Chiller performance data"
    annotation (Placement(transformation(extent={{20,180},{40,200}})));
  replaceable Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield ets(
    redeclare package MediumSer=Medium,
    redeclare package MediumBui=Medium,
    QChiWat_flow_nominal=QCoo_flow_nominal,
    QHeaWat_flow_nominal=QHea_flow_nominal,
    dp1Hex_nominal=20E3,
    dp2Hex_nominal=20E3,
    QHex_flow_nominal=-QCoo_flow_nominal,
    T_a1Hex_nominal=284.15,
    T_b1Hex_nominal=279.15,
    T_a2Hex_nominal=277.15,
    T_b2Hex_nominal=282.15,
    dpCon_nominal=15E3,
    dpEva_nominal=15E3,
    datChi=datChi,
    nPorts_bChiWat=1,
    nPorts_aHeaWat=1)
    "ETS"
    annotation (Placement(transformation(extent={{-10,-84},{50,-24}})));
  Buildings.Fluid.Sources.Boundary_pT disWat(
    redeclare package Medium=Medium,
    use_T_in=true,
    nPorts=2)
    "District water boundary conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-110,-140})));
  Modelica.Blocks.Sources.CombiTimeTable TDisWatSup(
    tableName="tab1",
    table=[
      0,11;
      49,11;
      50,20;
      100,20],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600,
    offset={273.15},
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-330,-150},{-310,-130}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisWatSup(
    redeclare final package Medium=Medium,
    final m_flow_nominal=ets.hex.m1_flow_nominal)
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-80,-80})));
  BaseClasses.Buildingseries bui(
    filNam="modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos",
    facMulHea=10,
    facMulCoo=40,
    k=1,
    Ti=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_inputFilter=false,
    nPorts_aHeaWat=1,
    nPorts_aChiWat=1,
    nPorts_bHeaWat=1,
    nPorts_bChiWat=1)
    annotation (Placement(transformation(extent={{52,48},{-8,108}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(k=bui.T_aHeaWat_nominal,
      y(final unit="K", displayUnit="degC"))
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-154,118},{-134,138}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(k=bui.T_aChiWat_nominal,
      y(final unit="K", displayUnit="degC"))
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-154,78},{-134,98}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain
                                   loaHeaNor(k=1/bui.QHea_flow_nominal)
    "Normalized heating load"
    annotation (Placement(transformation(extent={{-250,-50},{-230,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain
                                   loaCooNor(k=1/bui.QCoo_flow_nominal)
    "Normalized cooling load"
    annotation (Placement(transformation(extent={{-250,-96},{-230,-76}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold
                                               enaHeaCoo[2](each t=1e-4)
    "Threshold comparison to enable heating and cooling"
    annotation (Placement(transformation(extent={{-144,-72},{-124,-52}})));
equation
  connect(ets.port_bSerAmb, disWat.ports[1]) annotation (Line(points={{50,-74},{
          160,-74},{160,-180},{-100,-180},{-100,-138}},  color={0,127,255}));
  connect(TDisWatSup.y[1],disWat.T_in)
    annotation (Line(points={{-309,-140},{-140,-140},{-140,-136},{-122,-136}},color={0,0,127}));
  connect(disWat.ports[2],senTDisWatSup.port_a)
    annotation (Line(points={{-100,-142},{-100,-80},{-90,-80}},color={0,127,255}));
  connect(senTDisWatSup.port_b, ets.port_aSerAmb) annotation (Line(points={{-70,-80},
          {-70,-82},{-10,-82},{-10,-74}},      color={0,127,255}));
  connect(TChiWatSupSet.y,ets.TChiWatSupSet)
    annotation (Line(points={{-132,88},{-46,88},{-46,-64},{-14,-64}},  color={0,0,127}));
  connect(THeaWatSupSet.y,ets.THeaWatSupSet)
    annotation (Line(points={{-132,128},{-42,128},{-42,-58},{-14,-58}},color={0,0,127}));
  connect(bui.ports_aHeaWat[1], ets.ports_bHeaWat[1]) annotation (Line(points={{
          52,72},{82,72},{82,-28},{50,-28}}, color={0,127,255}));
  connect(bui.ports_aChiWat[1], ets.ports_bChiWat[1]) annotation (Line(points={{
          52,60},{126,60},{126,-38},{50,-38}}, color={0,127,255}));
  connect(bui.ports_bChiWat[1], ets.ports_aChiWat[1]) annotation (Line(points={{
          -8,60},{-30,60},{-30,-38},{-10,-38}}, color={0,127,255}));
  connect(bui.ports_bHeaWat[1], ets.ports_aHeaWat[1]) annotation (Line(points={{
          -8,72},{-76,72},{-76,-28},{-10,-28}}, color={0,127,255}));
  connect(bui.QReqHea_flow,loaHeaNor. u) annotation (Line(points={{2,44},{2,26},
          {-274,26},{-274,-40},{-252,-40}},   color={0,0,127}));
  connect(bui.QReqCoo_flow,loaCooNor. u) annotation (Line(points={{-2,44},{-2,14},
          {-270,14},{-270,-86},{-252,-86}},   color={0,0,127}));
  connect(enaHeaCoo[1].y, ets.uHea) annotation (Line(points={{-122,-62},{-92,-62},
          {-92,-46},{-14,-46}}, color={255,0,255}));
  connect(enaHeaCoo[2].y, ets.uCoo) annotation (Line(points={{-122,-62},{-92,-62},
          {-92,-52},{-14,-52}}, color={255,0,255}));
  connect(loaHeaNor.y,enaHeaCoo [1].u) annotation (Line(points={{-228,-40},{-166,
          -40},{-166,-62},{-146,-62}},   color={0,0,127}));
  connect(loaCooNor.y,enaHeaCoo [2].u) annotation (Line(points={{-228,-86},{-168,
          -86},{-168,-62},{-146,-62}},   color={0,0,127}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-340,-220},{340,220}})),
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>",
      info="<html>
<p>
This is a partial model used as a base class to construct the
validation and example models.
</p>
<ul>
<li>
The building distribution pumps are variable speed and the flow rate
is considered to vary linearly with the load (with no inferior limit).
</li>
<li>
The Boolean enable signals for heating and cooling typically provided
by the building automation system are here computed based on the condition 
that the load is greater than 1% of the nominal load.
</li>
<li>
Simplified chiller performance data are used, which represent a linear
variation of the EIR and the capacity with the evaporator outlet temperature 
and the condenser inlet temperature (no variation of the EIR at part 
load is considered).
</li>
</ul>
</html>"),
    uses(Buildings(version="8.0.0")));
end Onlychillerborefield3;
