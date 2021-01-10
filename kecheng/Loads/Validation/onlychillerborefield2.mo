within ;
model onlychillerborefield2
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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(
    k=45+273.15,
    y(final unit="K",
      displayUnit="degC"))
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(
    k=7+273.15,
    y(final unit="K",
      displayUnit="degC"))
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
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
    nPorts_bChiWat=1)
    "ETS"
    annotation (Placement(transformation(extent={{-10,-84},{50,-24}})));
  Buildings.Fluid.Sources.Boundary_pT disWat(
    redeclare package Medium=Medium,
    use_T_in=true,
    nPorts=2)
    "District water boundary conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-110,-140})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold uHea(
    final t=0.01,
    final h=0.005)
    "Enable heating"
    annotation (Placement(transformation(extent={{-200,-30},{-180,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold uCoo(
    final t=0.01,
    final h=0.005)
    "Enable cooling"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));
  Modelica.Blocks.Routing.RealPassThrough heaLoaNor
    "Connect with normalized heating load"
    annotation (Placement(transformation(extent={{-250,50},{-230,70}})));
  Modelica.Blocks.Routing.RealPassThrough loaCooNor
    "Connect with normalized cooling load"
    annotation (Placement(transformation(extent={{270,50},{250,70}})));
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
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableName="tab1",
    table=[
      0,0,0;
      1,0,0;
      2,0,1;
      3,0,1;
      4,0,0.5;
      5,0,0.5;
      6,0,0.1;
      7,0,0.1;
      8,0,0;
      9,0,0;
      10,0,0;
      11,0,0;
      12,1,0;
      13,1,0;
      14,0.5,0;
      15,0.5,0;
      16,0.1,0;
      17,0.1,0;
      18,0,0;
      19,0,0;
      20,0,0;
      21,0,0;
      22,1,1;
      23,1,1;
      24,0.5,0.5;
      25,0.5,0.5;
      26,0.1,0.1;
      27,0.1,0.1;
      28,0,0;
      29,0,0;
      30,0,0;
      31,0,0;
      32,0.1,1;
      33,0.1,1;
      34,0.5,0.5;
      35,0.5,0.5;
      36,1,0.1;
      37,1,0.1;
      38,0,0;
      39,0,0;
      40,0,0;
      41,0,0;
      42,0.1,0.3;
      43,0.1,0.3;
      44,0.3,0.1;
      45,0.3,0.1;
      46,0.1,0.1;
      47,0.1,0.1;
      48,0,0;
      49,0,0],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600,
    offset={0,0},
    columns={2,3},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{-330,150},{-310,170}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisWatSup(
    redeclare final package Medium=Medium,
    final m_flow_nominal=ets.hex.m1_flow_nominal)
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-80,-80})));
  Modelica.Blocks.Continuous.Integrator EChi(
    y(unit="J"))
    "Chiller electricity use"
    annotation (Placement(transformation(extent={{300,-70},{320,-50}})));
  simpleBuildingforchillerborefield bui(
  mCon_flow_nominal=datChi.mCon_flow_nominal,
  mEva_flow_nominal=datChi.mEva_flow_nominal,
  QChiWat_flow_nominal=ets.QChiWat_flow_nominal,
  QHeaWat_flow_nominal=ets.QHeaWat_flow_nominal,
    nPorts_aChiWat=1)
    annotation (Placement(transformation(extent={{-8,42},{52,102}})));
equation
  connect(TChiWatSupSet.y,ets.TChiWatSupSet)
    annotation (Line(points={{-118,100},{-32,100},{-32,-64},{-14,-64}},color={0,0,127}));
  connect(THeaWatSupSet.y,ets.THeaWatSupSet)
    annotation (Line(points={{-118,140},{-28,140},{-28,-58},{-14,-58}},color={0,0,127}));
  connect(ets.port_bSerAmb, disWat.ports[1]) annotation (Line(points={{50,-74},{
          160,-74},{160,-180},{-100,-180},{-100,-138}},  color={0,127,255}));
  connect(heaLoaNor.y,uHea.u)
    annotation (Line(points={{-229,60},{-220,60},{-220,-20},{-202,-20}},color={0,0,127}));
  connect(loaCooNor.y,uCoo.u)
    annotation (Line(points={{249,60},{230,60},{230,-126},{-230,-126},{-230,
          -100},{-202,-100}},                                                                  color={0,0,127}));
  connect(TDisWatSup.y[1],disWat.T_in)
    annotation (Line(points={{-309,-140},{-140,-140},{-140,-136},{-122,-136}},color={0,0,127}));
  connect(uCoo.y,ets.uCoo)
    annotation (Line(points={{-178,-100},{-130,-100},{-130,-52},{-14,-52}},color={255,0,255}));
  connect(uHea.y,ets.uHea)
    annotation (Line(points={{-178,-20},{-150,-20},{-150,-44},{-120,-44},{-120,-46},
          {-14,-46}},                                                    color={255,0,255}));
  connect(disWat.ports[2],senTDisWatSup.port_a)
    annotation (Line(points={{-100,-142},{-100,-80},{-90,-80}},color={0,127,255}));
  connect(senTDisWatSup.port_b, ets.port_aSerAmb) annotation (Line(points={{-70,-80},
          {-40,-80},{-40,-74},{-10,-74}},      color={0,127,255}));
  connect(ets.PCoo, EChi.u) annotation (Line(points={{54,-50},{60,-50},{60,-60},
          {298,-60}}, color={0,0,127}));
  connect(loa.y[1], loaCooNor.u) annotation (Line(points={{-309,160},{362,160},
          {362,106},{330,106},{330,60},{272,60}}, color={0,0,127}));
  connect(loa.y[2], heaLoaNor.u) annotation (Line(points={{-309,160},{-309,60},
          {-252,60}}, color={0,0,127}));
  connect(heaLoaNor.y, bui.heating_load) annotation (Line(points={{-229,60},{
          -114,60},{-114,94.1},{-11.5,94.1}},
                                         color={0,0,127}));
  connect(loaCooNor.y, bui.cooling_load) annotation (Line(points={{249,60},{128,
          60},{128,83.3},{-11.5,83.3}}, color={0,0,127}));
  connect(bui.ports_aHeaWat[1], ets.ports_bHeaWat[1]) annotation (Line(points={
          {-8,66},{24,66},{24,-28},{50,-28}}, color={0,127,255}));
  connect(bui.ports_aChiWat[1], ets.ports_bChiWat[1]) annotation (Line(points={
          {-8,54},{-64,54},{-64,-4},{50,-4},{50,-38}}, color={0,127,255}));
  connect(bui.ports_bHeaWat[1], ets.ports_aHeaWat[1]) annotation (Line(points={
          {52,66},{24,66},{24,-28},{-10,-28}}, color={0,127,255}));
  connect(bui.ports_bChiWat[1], ets.ports_aChiWat[1]) annotation (Line(points={
          {52,54},{84,54},{84,-38},{-10,-38}}, color={0,127,255}));
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
end onlychillerborefield2;
