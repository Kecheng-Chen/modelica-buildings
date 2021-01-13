within kecheng.Loads.Validation.BaseClasses;
model Buildingseries
"Building model with heating and cooling loads provided as time series"
  extends Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding(
    redeclare package Medium=Buildings.Media.Water,
    have_heaWat=true,
    have_chiWat=true,
    final have_fan=false,
    final have_pum=true,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_weaBus=false);
  parameter Boolean have_hotWat = false
    "Set to true if SHW load is included in the time series"
    annotation (Evaluate=true);

  replaceable package Medium2=Buildings.Media.Air
    "Load side medium";
  parameter String filNam
    "File name with thermal loads as time series";
  // TODO: compute facSca* based on peak loads.
  parameter Real facMulHea=1
    "Heating terminal unit multiplier factor"
    annotation(Dialog(enable=have_heaWat, group="Scaling"));
  parameter Real facMulCoo=1
    "Cooling terminal unit scaling factor"
    annotation(Dialog(enable=have_chiWat, group="Scaling"));
  parameter Modelica.SIunits.Temperature T_aHeaWat_nominal=40+273.15
    "Heating water inlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bHeaWat_nominal(
    min=273.15,
    displayUnit="degC")=T_aHeaWat_nominal-5
    "Heating water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aChiWat_nominal=18+273.15
    "Chilled water inlet temperature at nominal conditions "
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bChiWat_nominal(
    min=273.15,
    displayUnit="degC")=T_aChiWat_nominal+5
    "Chilled water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aLoaHea_nominal=273.15 + 20
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aLoaCoo_nominal=273.15 + 24
    "Load side inlet temperature at nominal conditions in cooling mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mLoaHea_flow_nominal=1
    "Load side mass flow rate at nominal conditions in heating mode (single unit)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mLoaCoo_flow_nominal=mLoaHea_flow_nominal
    "Load side mass flow rate at nominal conditions in cooling mode (single unit)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(
    max=-Modelica.Constants.eps)=Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design cooling heat flow rate (<=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)=Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space heating load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Real k(
    min=0)=1
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti(
    min=Modelica.Constants.small)=10
    "Time constant of integrator block";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance for fan air volume"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  parameter Modelica.SIunits.Time tau=1
    "Time constant of fan air volume, used if energy or mass balance is dynamic"
    annotation (Dialog(tab="Dynamics",group="Nominal condition",
      enable=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Boolean use_inputFilter=true
    "= true, if fan speed is filtered with a 2nd order CriticalDamping filter"
    annotation (Dialog(tab="Dynamics",group="Filtered speed"));
  parameter Modelica.SIunits.Time riseTime=30
    "Rise time of the filter (time to reach 99.6 % of the speed)"
    annotation (Dialog(tab="Dynamics",group="Filtered speed",enable=use_inputFilter));
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(
      filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns=if have_hotWat then {2,3,4} else {2,3},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Reader for thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{-324,-12},{-304,8}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(
    k=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-68,48},{-48,68}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(
    k=297.15,
    y(final unit="K",
      displayUnit="degC"))
    "Maximum temperature set point"
    annotation (Placement(transformation(extent={{-182,-142},{-162,-122}})));
  replaceable Buildings.Experimental.DHC.Loads.Validation.BaseClasses.FanCoil2PipeHeating terUniHea(
    final k=k,
    final Ti=Ti,
    final tau=tau,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime) if have_heaWat
  constrainedby
    Buildings.Experimental.DHC.Loads.BaseClasses.PartialTerminalUnit(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium2,
    final facMul=facMulHea,
    final facMulZon=1,
    final QHea_flow_nominal=QHea_flow_nominal/facMulHea,
    final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    final energyDynamics=energyDynamics,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal)
    "Heating terminal unit"
    annotation (Placement(transformation(extent={{72,-30},{92,-10}})));
  Buildings.Experimental.DHC.Loads.FlowDistribution disFloHea(
    redeclare package Medium=Medium,
    m_flow_nominal=mHeaWat_flow_nominal,
    have_pum=true,
    dp_nominal=100000,
    nPorts_a1=1,
    nPorts_b1=1) if have_heaWat
    "Heating water distribution system"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Experimental.DHC.Loads.FlowDistribution disFloCoo(
    redeclare package Medium=Medium,
    final m_flow_nominal=mChiWat_flow_nominal,
    typDis=Buildings.Experimental.DHC.Loads.Types.DistributionType.ChilledWater,
    have_pum=true,
    dp_nominal=100000,
    nPorts_b1=1,
    nPorts_a1=1) if have_chiWat
    "Chilled water distribution system"
    annotation (Placement(transformation(extent={{120,-270},{140,-250}})));
  replaceable Buildings.Experimental.DHC.Loads.Validation.BaseClasses.FanCoil2PipeCooling terUniCoo(
    final QHea_flow_nominal=QHea_flow_nominal/facMulHea,
    final T_aLoaHea_nominal=T_aLoaHea_nominal,
    final k=k,
    final Ti=Ti,
    final tau=tau,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime) if have_chiWat
  constrainedby
    Buildings.Experimental.DHC.Loads.BaseClasses.PartialTerminalUnit(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium2,
    final facMul=facMulCoo,
    final facMulZon=1,
    final QCoo_flow_nominal=QCoo_flow_nominal/facMulCoo,
    final mLoaCoo_flow_nominal=mLoaCoo_flow_nominal,
    final energyDynamics=energyDynamics,
    final T_aChiWat_nominal=T_aChiWat_nominal,
    final T_bChiWat_nominal=T_bChiWat_nominal,
    final T_aLoaCoo_nominal=T_aLoaCoo_nominal)
    "Cooling terminal unit"
    annotation (Placement(transformation(extent={{-14,-166},{6,-146}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPHea(k=1)
    annotation (Placement(transformation(extent={{162,88},{182,108}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulQReqHea_flow(u(final unit="W"),
      final k=facMul) if
                       have_heaLoa "Scaling"
    annotation (Placement(transformation(extent={{272,28},{292,48}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulQReqCoo_flow(u(final unit="W"),
      final k=facMul) if
                       have_cooLoa "Scaling"
    annotation (Placement(transformation(extent={{272,-12},{292,8}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QReqHea_flow(final quantity="HeatFlowRate",
      final unit="W") if
                       have_heaLoa
    "Heating load"
    annotation (Placement(transformation(extent={{300,18},{340,58}}),
      iconTransformation(extent={{-40,-40},{40,40}},rotation=-90,origin={200,-340})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QReqCoo_flow(final quantity="HeatFlowRate",
      final unit="W") if
                       have_cooLoa
    "Cooling load"
    annotation (Placement(transformation(extent={{300,-22},{340,18}}),
      iconTransformation(extent={{-40,-40},{40,40}},rotation=-90,origin={240,-340})));
  Buildings.Fluid.Sources.Boundary_pT bou(
  redeclare final package Medium=Medium, nPorts=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-156,-86})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cpHeaWat_nominal=
    Medium.specificHeatCapacityCp(
      Medium.setState_pTX(
        Medium.p_default,
        T_aHeaWat_nominal))
    "Heating water specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cpChiWat_nominal=
    Medium.specificHeatCapacityCp(
      Medium.setState_pTX(
        Medium.p_default,
        T_aChiWat_nominal))
    "Chilled water specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal=abs(
    QCoo_flow_nominal/cpChiWat_nominal/(T_aChiWat_nominal-T_bChiWat_nominal))
    "Chilled water mass flow rate at nominal conditions (all units)";
  parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal=abs(
    QHea_flow_nominal/cpHeaWat_nominal/(T_aHeaWat_nominal-T_bHeaWat_nominal))
    "Heating water mass flow rate at nominal conditions (all units)";
equation
  connect(terUniHea.port_bHeaWat,disFloHea.ports_a1[1])
    annotation (Line(points={{92,-28.3333},{92,-20},{146,-20},{146,-54},{140,
          -54}},                                                                   color={0,127,255}));
  connect(disFloHea.ports_b1[1],terUniHea.port_aHeaWat)
    annotation (Line(points={{120,-54},{64,-54},{64,-28.3333},{72,-28.3333}},color={0,127,255}));
  connect(terUniHea.mReqHeaWat_flow,disFloHea.mReq_flow[1])
    annotation (Line(points={{92.8333,-23.3333},{100,-23.3333},{100,-64},{119,
          -64}},                                                                     color={0,0,127}));
  connect(disFloCoo.ports_b1[1],terUniCoo.port_aChiWat)
    annotation (Line(points={{120,-254},{-38,-254},{-38,-162.667},{-14,-162.667}},
                                                                             color={0,127,255}));
  connect(terUniCoo.port_bChiWat,disFloCoo.ports_a1[1])
    annotation (Line(points={{6,-162.667},{6,-162},{156,-162},{156,-254},{140,
          -254}},                                                               color={0,127,255}));
  connect(terUniCoo.mReqChiWat_flow,disFloCoo.mReq_flow[1])
    annotation (Line(points={{6.83333,-161},{8,-161},{8,-200},{86,-200},{86,-264},
          {119,-264}},                                                    color={0,0,127}));
  connect(minTSet.y,terUniHea.TSetHea)
    annotation (Line(points={{-46,58},{-20,58},{-20,-15},{71.1667,-15}},  color={0,0,127}));
  connect(maxTSet.y,terUniCoo.TSetCoo)
    annotation (Line(points={{-160,-132},{-48,-132},{-48,-152.667},{-14.8333,
          -152.667}},                                                          color={0,0,127}));
  connect(disFloCoo.port_b, mulChiWatOut[1].port_a)
    annotation (Line(points={{140,-260},{260,-260}}, color={0,127,255}));
  connect(disFloHea.port_b, mulHeaWatOut[1].port_a)
    annotation (Line(points={{140,-60},{260,-60}}, color={0,127,255}));
  connect(mulChiWatInl[1].port_b, disFloCoo.port_a)
    annotation (Line(points={{-260,-260},{120,-260}}, color={0,127,255}));
  connect(souPHea.y, mulPPum.u) annotation (Line(points={{184,98},{250,98},{250,
          80},{268,80}}, color={0,0,127}));
  connect(souPHea.y, mulPFan.u) annotation (Line(points={{184,98},{250,98},{250,
          120},{268,120}}, color={0,0,127}));
  connect(souPHea.y, mulPCoo.u) annotation (Line(points={{184,98},{184,157},{
          268,157},{268,160}}, color={0,0,127}));
  connect(souPHea.y, mulPHea.u) annotation (Line(points={{184,98},{232,98},{232,
          200},{268,200}}, color={0,0,127}));
  connect(souPHea.y, mulQCoo_flow.u) annotation (Line(points={{184,98},{202,98},
          {202,104},{268,104},{268,240}}, color={0,0,127}));
  connect(souPHea.y, mulQHea_flow.u) annotation (Line(points={{184,98},{184,254},
          {268,254},{268,280}}, color={0,0,127}));
  connect(mulQReqCoo_flow.y,QReqCoo_flow)
    annotation (Line(points={{294,-2},{320,-2}},
                                               color={0,0,127}));
  connect(mulQReqHea_flow.y,QReqHea_flow)
    annotation (Line(points={{294,38},{320,38}}, color={0,0,127}));
  connect(loa.y[1], terUniCoo.QReqCoo_flow) annotation (Line(points={{-303,-2},
          {-93.5,-2},{-93.5,-159.5},{-14.8333,-159.5}},
                                                   color={0,0,127}));
  connect(loa.y[2], terUniHea.QReqHea_flow) annotation (Line(points={{-303,-2},
          {-90,-2},{-90,-21.6667},{71.1667,-21.6667}}, color={0,0,127}));
  connect(loa.y[1], mulQReqCoo_flow.u) annotation (Line(points={{-303,-2},{8,-2},
          {8,-2},{270,-2}}, color={0,0,127}));
  connect(loa.y[2], mulQReqHea_flow.u) annotation (Line(points={{-303,-2},{10,
          -2},{10,38},{270,38}},
                             color={0,0,127}));
  connect(mulHeaWatInl[1].port_b, bou.ports[1]) annotation (Line(points={{-260,
          -60},{-208,-60},{-208,-76},{-156,-76}},
                                       color={0,127,255}));
  connect(mulHeaWatInl[1].port_b, disFloHea.port_a)
    annotation (Line(points={{-260,-60},{120,-60}}, color={0,127,255}));
    annotation (
    Documentation(
      info="
<html>
<p>
This is a simplified building model where the space heating and cooling loads
are provided as time series.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 18, 2020, by Jianjun Hu:<br/>
Changed flow distribution components and the terminal units to be conditional depending
on if there is water-based heating, or cooling system.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2147\">issue 2147</a>.
</li>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-300,-300},{300,300}})),
    uses(Buildings(version="8.0.0"), Modelica(version="3.2.3")));
end Buildingseries;
