within ;
model simpleBuildingforchillerborefield
"Dummy building model for validation purposes"
  extends Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding(
  have_heaWat=true,
  have_chiWat=true,
  nPorts_aHeaWat=1,
  nPorts_bHeaWat=1,
  nPorts_aChiWat=1,
  nPorts_bChiWat=1);

  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal;
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal;
  parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal=0.9*mCon_flow_nominal
    "Nominal heating water mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal=0.9*mEva_flow_nominal
    "Nominal chilled water mass flow rate";

  parameter Modelica.SIunits.HeatFlowRate QChiWat_flow_nominal
    "Design heat flow rate for chilled water production (<0)"
    annotation (Dialog(group="Nominal condition",enable=have_chiWat));
  parameter Modelica.SIunits.HeatFlowRate QHeaWat_flow_nominal
    "Design heat flow rate for heating water production (>0)"
    annotation (Dialog(group="Nominal condition",enable=have_heaWat));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPHea(
    k=1)
    annotation (Placement(transformation(extent={{240,190},{260,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPCoo(
    k=1)
    annotation (Placement(transformation(extent={{240,150},{260,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPFan(
    k=1)
    annotation (Placement(transformation(extent={{240,110},{260,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPPum(
    k=1)
    annotation (Placement(transformation(extent={{240,70},{260,90}})));
  Modelica.Blocks.Interfaces.RealInput heating_load annotation (Placement(
        transformation(extent={{-370,186},{-300,256}}), iconTransformation(
          extent={{-370,186},{-300,256}})));
  Modelica.Blocks.Interfaces.RealInput cooling_load annotation (Placement(
        transformation(extent={{-368,80},{-302,146}}), iconTransformation(
          extent={{-368,80},{-302,146}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai3(k=-QHeaWat_flow_nominal)
    "Scale to nominal heat flow rate"
    annotation (Placement(transformation(extent={{-260,196},{-208,248}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow loaHea
    "Heating load as prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-168,198},{-120,246}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(redeclare package
      Medium = Medium, m_flow_nominal=mCon_flow_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-52,204})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHeaWatRet(redeclare final
      package Medium = Medium, m_flow_nominal=mCon_flow_nominal)
    "Heating water return temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-52,158})));
  Buildings.Fluid.MixingVolumes.MixingVolume volHeaWat(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=45 + 273.15,
    final prescribedHeatFlowRate=true,
    redeclare package Medium = Medium,
    V=10,
    final mSenFac=1,
    final m_flow_nominal=mHeaWat_flow_nominal,
    nPorts=2)
    "Volume for heating water distribution circuit"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=-90,origin={-95,178})));
  Buildings.Fluid.Sources.Boundary_pT heaWat(redeclare package Medium = Medium,
      nPorts=1)
    "Heating water boundary conditions"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=90,origin={32,224})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(final k=mHeaWat_flow_nominal)
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{-48,256},{-28,276}})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumHeaWat(
    redeclare package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    dp_nominal=100E3)
    "Heating water distribution pump"
    annotation (Placement(transformation(extent={{22,194},{2,214}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTChiWatSup(redeclare package
      Medium = Medium, m_flow_nominal=mEva_flow_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-122,42})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTChiWatRet(redeclare final
      package Medium = Medium, m_flow_nominal=mEva_flow_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-120,-36})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumChiWat(
    redeclare package Medium = Medium,
    final m_flow_nominal=mChiWat_flow_nominal,
    dp_nominal=100E3)
    "Chilled water distribution pump"
    annotation (Placement(transformation(extent={{-102,32},{-82,52}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(final k=mChiWat_flow_nominal)
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{-162,70},{-142,90}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volChiWat(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=7 + 273.15,
    final prescribedHeatFlowRate=true,
    redeclare package Medium = Medium,
    V=10,
    final mSenFac=1,
    final m_flow_nominal=mChiWat_flow_nominal,
    nPorts=2)
    "Volume for chilled water distribution circuit"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,origin={-65,-18})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai4(final k=QChiWat_flow_nominal)
    "Scale to nominal heat flow rate"
    annotation (Placement(transformation(extent={{8,50},{-12,70}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow loaCoo
    "Cooling load as prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-26,26},{-46,46}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPHea1(k=1)
    annotation (Placement(transformation(extent={{238,230},{258,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPHea2(k=1)
    annotation (Placement(transformation(extent={{240,270},{260,290}})));
equation
  connect(souPHea.y, mulPHea.u)
    annotation (Line(points={{262,200},{268,200}}, color={0,0,127}));
  connect(souPCoo.y, mulPCoo.u)
    annotation (Line(points={{262,160},{268,160}}, color={0,0,127}));
  connect(souPFan.y, mulPFan.u)
    annotation (Line(points={{262,120},{268,120}}, color={0,0,127}));
  connect(souPPum.y, mulPPum.u)
    annotation (Line(points={{262,80},{268,80}}, color={0,0,127}));
  connect(heating_load, gai3.u) annotation (Line(points={{-335,221},{-286,221},{
          -286,222},{-265.2,222}}, color={0,0,127}));
  connect(loaHea.Q_flow, gai3.y)
    annotation (Line(points={{-168,222},{-202.8,222}}, color={0,0,127}));
  connect(loaHea.port,volHeaWat.heatPort)
    annotation (Line(points={{-120,222},{-102,222},{-102,188},{-95,188}},
                                                                      color={191,0,0}));
  connect(senTHeaWatSup.port_b,volHeaWat.ports[1])
    annotation (Line(points={{-62,204},{-85,204},{-85,180}},
                                                          color={0,127,255}));
  connect(volHeaWat.ports[2],senTHeaWatRet.port_a)
    annotation (Line(points={{-85,176},{-85,158},{-62,158}}, color={0,127,255}));
  connect(pumHeaWat.port_b,senTHeaWatSup.port_a)
    annotation (Line(points={{2,204},{-42,204}},color={0,127,255}));
  connect(gai1.y,pumHeaWat.m_flow_in)
    annotation (Line(points={{-26,266},{12,266},{12,216}},
                                                      color={0,0,127}));
  connect(heaWat.ports[1],pumHeaWat.port_a)
    annotation (Line(points={{32,214},{32,204},{22,204}},
                                                      color={0,127,255}));
  connect(heating_load, gai1.u) annotation (Line(points={{-335,221},{-322,221},{
          -322,222},{-306,222},{-306,266},{-50,266}}, color={0,0,127}));
  connect(pumHeaWat.port_a, mulHeaWatInl[1].port_b) annotation (Line(points={{22,
          204},{90,204},{90,-60},{-260,-60}}, color={0,127,255}));
  connect(senTHeaWatRet.port_b, mulHeaWatOut[1].port_a) annotation (Line(points=
         {{-42,158},{108,158},{108,-60},{260,-60}}, color={0,127,255}));
  connect(pumChiWat.port_a,senTChiWatSup.port_b)
    annotation (Line(points={{-102,42},{-112,42}},
                                                color={0,127,255}));
  connect(gai2.y,pumChiWat.m_flow_in)
    annotation (Line(points={{-140,80},{-92,80},{-92,54}}, color={0,0,127}));
  connect(pumChiWat.port_b,volChiWat.ports[1])
    annotation (Line(points={{-82,42},{-75,42},{-75,-16}},
                                                        color={0,127,255}));
  connect(volChiWat.ports[2],senTChiWatRet.port_a)
    annotation (Line(points={{-75,-20},{-75,-36},{-110,-36}},
                                                       color={0,127,255}));
  connect(gai4.y,loaCoo.Q_flow)
    annotation (Line(points={{-14,60},{-22,60},{-22,36},{-26,36}},
                                                color={0,0,127}));
  connect(loaCoo.port,volChiWat.heatPort)
    annotation (Line(points={{-46,36},{-64,36},{-64,14},{-65,14},{-65,-8}},
                                                         color={191,0,0}));
  connect(cooling_load, gai4.u) annotation (Line(points={{-335,113},{-150,113},{
          -150,116},{34,116},{34,60},{10,60}}, color={0,0,127}));
  connect(cooling_load, gai2.u) annotation (Line(points={{-335,113},{-249.5,113},
          {-249.5,80},{-164,80}}, color={0,0,127}));
  connect(senTChiWatSup.port_a, mulChiWatInl[1].port_b) annotation (Line(points=
         {{-132,42},{-196,42},{-196,-260},{-260,-260}}, color={0,127,255}));
  connect(senTChiWatRet.port_b, mulChiWatOut[1].port_a) annotation (Line(points={{-130,
          -36},{-164,-36},{-164,-260},{260,-260}},   color={0,127,255}));
  connect(souPHea1.y, mulQCoo_flow.u)
    annotation (Line(points={{260,240},{268,240}}, color={0,0,127}));
  connect(souPHea2.y, mulQHea_flow.u)
    annotation (Line(points={{262,280},{268,280}}, color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(info="<html>
<p> 
This is a minimum example of a class extending 
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding\">
Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding</a>
developed for testing purposes only.
</p>
</html>"),
    uses(Modelica(version="3.2.3"), Buildings(version="8.0.0")));
end simpleBuildingforchillerborefield;
