within kecheng.Loads.Validation;
model BuildingTimeSeriesWithchillerborefield
  package Medium=Buildings.Media.Water
    "Medium model";

  final parameter Integer idxPHeaETS=max(
    Modelica.Math.BooleanVectors.countTrue(
      {bui.have_eleHea,ets.have_eleHea}),
    1)
    "Index for connecting the ETS output connector"
    annotation (Evaluate=true);
  final parameter Integer idxPCooETS=max(
    Modelica.Math.BooleanVectors.countTrue(
      {bui.have_eleCoo,ets.have_eleCoo}),
    1)
    "Index for connecting the ETS output connector"
    annotation (Evaluate=true);
  final parameter Integer idxPFanETS=max(
    Modelica.Math.BooleanVectors.countTrue(
      {bui.have_fan,ets.have_fan}),
    1)
    "Index for connecting the ETS output connector"
    annotation (Evaluate=true);
  final parameter Integer idxPPumETS=max(
    Modelica.Math.BooleanVectors.countTrue(
      {bui.have_pum,ets.have_pum}),
    1);
  final parameter Boolean have_heaWat=ets.have_heaWat
    "Set to true if the ETS supplies heating water"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_hotWat=ets.have_hotWat
    "Set to true if the ETS supplies domestic hot water"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_chiWat=ets.have_chiWat
    "Set to true if the ETS supplies chilled water"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_eleHea=bui.have_eleHea or ets.have_eleHea
    "Set to true if the building or ETS has electric heating equipment"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_eleCoo=bui.have_eleCoo or ets.have_eleCoo
    "Set to true if the building or ETS has electric cooling equipment"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_fan=bui.have_fan or ets.have_fan
    "Set to true if fan power is computed"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_pum=bui.have_pum or ets.have_pum
    "Set to true if pump power is computed"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_weaBus=bui.have_weaBus or ets.have_weaBus
    "Set to true to use a weather bus"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean allowFlowReversalSer=false;
  parameter Real facMul=1;
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
    mEva_flow_nominal=abs(QCoo_flow_nominal)/5/4186,
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
    annotation (Placement(transformation(extent={{-12,184},{8,204}})));
  replaceable Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield ets(
    redeclare package MediumSer = Medium,
    redeclare package MediumBui = Medium,
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
    annotation (Placement(transformation(extent={{38,-132},{98,-72}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisWatSup(redeclare final
      package Medium = Medium, final m_flow_nominal=ets.hex.m1_flow_nominal)
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-122,
            -156})));
  BaseClasses.Buildingseries2 bui(
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos",
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
    annotation (Placement(transformation(extent={{40,64},{100,124}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain
                                   loaHeaNor(k=1/bui.QHea_flow_nominal)
    "Normalized heating load"
    annotation (Placement(transformation(extent={{-202,-34},{-182,-14}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain
                                   loaCooNor(k=1/bui.QCoo_flow_nominal)
    "Normalized cooling load"
    annotation (Placement(transformation(extent={{-202,-80},{-182,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold
                                               enaHeaCoo[2](each t=1e-4)
    "Threshold comparison to enable heating and cooling"
    annotation (Placement(transformation(extent={{-96,-56},{-76,-36}})));
  Buildings.Fluid.BaseClasses.MassFlowRateMultiplier
                                           mulSerAmbInl(
    redeclare final package Medium = Medium,
    final k=facMul,
    final allowFlowReversal=false) "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{-280,-132},{-260,-112}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerAmb(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversalSer then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector for ambient water service supply line"
    annotation (
      Placement(transformation(extent={{-378,-124},{-358,-104}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(final unit="K",
      displayUnit="degC") "Heating water supply temperature set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-372,154}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,94})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(final unit="K",
      displayUnit="degC") "Chilled water supply temperature set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-374,66}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,54})));
  Buildings.Fluid.BaseClasses.MassFlowRateMultiplier
                                           mulSerAmbOut(
    redeclare final package Medium = Medium,
    final k=facMul,
    final allowFlowReversal=false) "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{180,-162},{200,-142}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerAmb(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversalSer then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector for ambient water service return line"
    annotation (
      Placement(transformation(extent={{374,-162},{394,-142}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulQHea_flow(u(final unit="W"),
      final k=facMul) if
                       bui.have_heaLoa "Scaling"
    annotation (Placement(transformation(extent={{282,228},{302,248}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QHea_flow(final unit="W") if
                       bui.have_heaLoa
    "Total heating heat flow rate transferred to the loads (>=0)"
    annotation (Placement(transformation(extent={{364,218},{404,258}}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=-90,origin={48,-78})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulQCoo_flow(u(final unit="W"),
      final k=facMul) if
                       bui.have_cooLoa
    "Scaling"
    annotation (Placement(transformation(extent={{284,192},{304,212}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QCoo_flow(final unit="W") if
                       bui.have_cooLoa
    "Total cooling heat flow rate transferred to the loads (<=0)"
    annotation (Placement(transformation(extent={{364,182},{404,222}}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=-90,origin={70,-78})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPHea(final nin=
        Modelica.Math.BooleanVectors.countTrue({bui.have_eleHea,ets.have_eleHea}))
    "Total power drawn by heating equipment"
    annotation (Placement(transformation(extent={{260,152},{280,172}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulPHea(u(final unit="W"), final k=
       facMul) if      have_eleHea "Scaling"
    annotation (Placement(transformation(extent={{288,152},{308,172}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PHea(final unit="W") if
                       have_eleHea
    "Power drawn by heating equipment"
    annotation (Placement(transformation(extent={{364,142},{404,182}}),
      iconTransformation(extent={{18,-18},{-18,18}},
        rotation=270,
        origin={0,118})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPCoo(final nin=
        Modelica.Math.BooleanVectors.countTrue({bui.have_eleCoo,ets.have_eleCoo}))
    "Total power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{260,108},{280,128}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulPCoo(u(final unit="W"), final k=
       facMul) if      have_eleCoo "Scaling"
    annotation (Placement(transformation(extent={{290,108},{310,128}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PCoo(final unit="W") if
                       have_eleCoo
    "Power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{364,98},{404,138}}),
      iconTransformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={20,120})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulPFan(u(final unit="W"), final k=
       facMul) if      have_fan "Scaling"
    annotation (Placement(transformation(extent={{290,44},{310,64}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PFan(final unit="W") if
                       have_fan
    "Power drawn by fan motors"
    annotation (Placement(transformation(extent={{360,34},{400,74}}),
      iconTransformation(extent={{100,32},{140,72}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPPum(final nin=
        Modelica.Math.BooleanVectors.countTrue({bui.have_pum,ets.have_pum}))
    "Total power drawn by pump motors"
    annotation (Placement(transformation(extent={{260,-10},{280,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulPPum(u(final unit="W"), final k=
       facMul) if      have_pum "Scaling"
    annotation (Placement(transformation(extent={{290,-10},{310,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(final unit="W") if
                       have_pum
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{362,-20},{402,20}}),
      iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain
                                   mulPPumETS(u(final unit="W"), final k=facMul) if
                       have_pum "Scaling"
    annotation (Placement(transformation(extent={{290,-70},{310,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput
                                         PPumETS(final unit="W") if
                       have_pum "ETS pump power" annotation (Placement(
        transformation(extent={{358,-80},{398,-40}}),
                                                    iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-22,120})));
equation
  connect(bui.ports_aHeaWat[1],ets. ports_bHeaWat[1]) annotation (Line(points={{40,88},
          {130,88},{130,-76},{98,-76}},      color={0,127,255}));
  connect(bui.ports_aChiWat[1],ets. ports_bChiWat[1]) annotation (Line(points={{40,76},
          {174,76},{174,-86},{98,-86}},        color={0,127,255}));
  connect(bui.ports_bChiWat[1],ets. ports_aChiWat[1]) annotation (Line(points={{100,76},
          {18,76},{18,-86},{38,-86}},           color={0,127,255}));
  connect(bui.ports_bHeaWat[1],ets. ports_aHeaWat[1]) annotation (Line(points={{100,88},
          {-44,88},{-44,-76},{38,-76}},         color={0,127,255}));
  connect(bui.QReqHea_flow,loaHeaNor. u) annotation (Line(points={{90,60},{90,42},
          {-226,42},{-226,-24},{-204,-24}},   color={0,0,127}));
  connect(bui.QReqCoo_flow,loaCooNor. u) annotation (Line(points={{94,60},{94,30},
          {-222,30},{-222,-70},{-204,-70}},   color={0,0,127}));
  connect(enaHeaCoo[1].y,ets. uHea) annotation (Line(points={{-74,-46},{-44,-46},
          {-44,-94},{34,-94}},  color={255,0,255}));
  connect(enaHeaCoo[2].y,ets. uCoo) annotation (Line(points={{-74,-46},{-44,-46},
          {-44,-100},{34,-100}},color={255,0,255}));
  connect(loaHeaNor.y,enaHeaCoo [1].u) annotation (Line(points={{-180,-24},{
          -118,-24},{-118,-46},{-98,-46}},
                                         color={0,0,127}));
  connect(loaCooNor.y,enaHeaCoo [2].u) annotation (Line(points={{-180,-70},{
          -120,-70},{-120,-46},{-98,-46}},
                                         color={0,0,127}));
  connect(port_aSerAmb,mulSerAmbInl. port_a)
    annotation (Line(points={{-368,-114},{-306,-114},{-306,-122},{-280,-122}},
                                                       color={0,127,255}));
  connect(mulSerAmbInl.port_b, senTDisWatSup.port_a) annotation (Line(points={{-260,
          -122},{-226,-122},{-226,-156},{-132,-156}}, color={0,127,255}));
  connect(senTDisWatSup.port_b, ets.port_aSerAmb) annotation (Line(points={{-112,
          -156},{-38,-156},{-38,-122},{38,-122}}, color={0,127,255}));
  connect(ets.THeaWatSupSet, THeaWatSupSet) annotation (Line(points={{34,-106},{
          -234,-106},{-234,154},{-372,154}}, color={0,0,127}));
  connect(ets.TChiWatSupSet, TChiWatSupSet) annotation (Line(points={{34,-112},{
          -248,-112},{-248,66},{-374,66}}, color={0,0,127}));
  connect(ets.port_bSerAmb,mulSerAmbOut. port_a) annotation (Line(points={{98,-122},
          {144,-122},{144,-152},{180,-152}},color={0,127,255}));
  connect(mulSerAmbOut.port_b,port_bSerAmb)
    annotation (Line(points={{200,-152},{384,-152}}, color={0,127,255}));
  connect(bui.QHea_flow,mulQHea_flow. u) annotation (Line(points={{102,120},{140,
          120},{140,238},{280,238}},
                                color={0,0,127}));
  connect(mulQHea_flow.y,QHea_flow)
    annotation (Line(points={{304,238},{384,238}}, color={0,0,127}));
  connect(bui.QCoo_flow,mulQCoo_flow. u) annotation (Line(points={{102,116},{164,
          116},{164,202},{282,202}},
                                color={0,0,127}));
  connect(mulQCoo_flow.y,QCoo_flow)
    annotation (Line(points={{306,202},{384,202}}, color={0,0,127}));
  connect(bui.PHea,totPHea.u[1])
    annotation (Line(points={{102,112},{206,112},{206,162},{258,162}},
                                                               color={0,0,127}));
  connect(ets.PHea,totPHea.u[idxPHeaETS])
    annotation (Line(points={{102,-94},{230,-94},{230,160},{258,160},{258,162}},
                                                                 color={0,0,127}));
  connect(totPHea.y,mulPHea. u)
    annotation (Line(points={{282,162},{286,162}}, color={0,0,127}));
  connect(mulPHea.y,PHea)
    annotation (Line(points={{310,162},{384,162}}, color={0,0,127}));
  connect(bui.PCoo,totPCoo.u[1])
    annotation (Line(points={{102,108},{220,108},{220,118},{258,118}},
                                                              color={0,0,127}));
  connect(ets.PCoo,totPCoo.u[idxPCooETS])
    annotation (Line(points={{102,-98},{184,-98},{184,80},{258,80},{258,118}},
                                                                color={0,0,127}));
  connect(totPCoo.y,mulPCoo. u)
    annotation (Line(points={{282,118},{288,118}}, color={0,0,127}));
  connect(mulPCoo.y,PCoo)
    annotation (Line(points={{312,118},{384,118}}, color={0,0,127}));
  connect(PCoo, PCoo)
    annotation (Line(points={{384,118},{384,118}}, color={0,0,127}));
  connect(bui.PFan,mulPFan. u)
    annotation (Line(points={{102,104},{196,104},{196,54},{288,54}},
                                                   color={0,0,127}));
  connect(mulPFan.y,PFan)
    annotation (Line(points={{312,54},{380,54}},   color={0,0,127}));
  connect(bui.PPum,totPPum.u[1])
    annotation (Line(points={{102,100},{206,100},{206,0},{258,0}},
                                                              color={0,0,127}));
  connect(ets.PPum,totPPum.u[idxPPumETS])
    annotation (Line(points={{102,-106},{206,-106},{206,-2},{258,-2},{258,0}},
                                                                color={0,0,127}));
  connect(totPPum.y,mulPPum. u)
    annotation (Line(points={{282,0},{288,0}},     color={0,0,127}));
  connect(mulPPum.y,PPum)
    annotation (Line(points={{312,0},{382,0}},     color={0,0,127}));
  connect(mulPPumETS.y,PPumETS)
    annotation (Line(points={{312,-60},{378,-60}},
                                                 color={0,0,127}));
  connect(ets.PPum,mulPPumETS. u) annotation (Line(points={{102,-106},{280,-106},
          {280,-60},{288,-60}},
                             color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-120,-80},{120,140}})),  Icon(
        coordinateSystem(extent={{-120,-80},{120,140}}),  graphics={
        Rectangle(
          extent={{-100,6},{-60,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5),
        Polygon(
          points={{0,74},{-40,54},{40,54},{0,74}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95}),
        Rectangle(
          extent={{-40,54},{40,-46}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
        Rectangle(
          extent={{-30,24},{-10,44}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,24},{30,44}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,-16},{-10,4}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-16},{30,4}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,6},{100,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{-11,6},{11,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5,
          origin={66,-17},
          rotation=-90),
        Rectangle(
          extent={{40,-16},{60,-28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{-11,6},{11,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5,
          origin={-66,-17},
          rotation=-90),
        Rectangle(
          extent={{-60,-16},{-40,-28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5)}));
end BuildingTimeSeriesWithchillerborefield;
