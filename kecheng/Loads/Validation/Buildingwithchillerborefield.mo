within ;
model Buildingwithchillerborefield
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
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
    annotation (Placement(transformation(extent={{38,84},{58,104}})));

  buildingseries bui(
    filNam="D:/Modelica_file/modelica-buildings/Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos",
    facMulHea=10*QHea_flow_nominal/(1.7E5),
    facMulCoo=40*QCoo_flow_nominal/(-1.5E5),
    k=1,
    Ti=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_inputFilter=false,
    nPorts_aHeaWat=1,
    nPorts_aChiWat=1,
    nPorts_bHeaWat=1,
    nPorts_bChiWat=1)
    annotation (Placement(transformation(extent={{21,-21},{-21,21}},
        rotation=0,
        origin={-11,55})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(k=7 + 273.15,
      y(final unit="K", displayUnit="degC"))
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-148,18},{-128,38}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(k=45 + 273.15,
      y(final unit="K", displayUnit="degC"))
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-150,62},{-130,82}})));
  Buildings.Fluid.Sources.Boundary_pT
                            disWat(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2)
    "District water boundary conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-142,
            -138})));
  Modelica.Blocks.Sources.CombiTimeTable TDisWatSup(
    tableName="tab1",
    table=[0,11; 49,11; 50,20; 100,20],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600,
    offset={273.15},
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-222,-144},{-202,-124}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                   senTDisWatSup(redeclare final package Medium =
        Medium, final m_flow_nominal=ets.hex.m1_flow_nominal)
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-100,-74})));
  Buildings.Controls.OBC.CDL.Continuous.Gain
                                   loaHeaNor(k=1/bui.QHea_flow_nominal)
    "Normalized heating load"
    annotation (Placement(transformation(extent={{-206,-46},{-186,-26}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain
                                   loaCooNor(k=1/bui.QCoo_flow_nominal)
    "Normalized cooling load"
    annotation (Placement(transformation(extent={{-206,-86},{-186,-66}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold
                                               enaHeaCoo[2](each t=1e-4)
    "Threshold comparison to enable heating and cooling"
    annotation (Placement(transformation(extent={{-146,-64},{-126,-44}})));
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
    nPorts_aHeaWat=1,
    nPorts_aChiWat=1,
    nPorts_bHeaWat=1,
    nPorts_bChiWat=1)
    "ETS"
    annotation (Placement(transformation(extent={{-32,-70},{28,-10}})));
equation
  connect(bui.ports_aHeaWat[1], ets.ports_bHeaWat[1]) annotation (
     Line(points={{10,50.8},{46,50.8},{46,-14},{28,-14}}, color={0,127,255}));
  connect(bui.ports_aChiWat[1], ets.ports_bChiWat[1]) annotation (
     Line(points={{10,42.4},{60,42.4},{60,-24},{28,-24}}, color={0,127,255}));
  connect(bui.ports_bChiWat[1], ets.ports_aChiWat[1]) annotation (
     Line(points={{-32,42.4},{-32,42},{-70,42},{-70,-24},{-32,-24}}, color={0,127,
          255}));
  connect(bui.ports_bHeaWat[1], ets.ports_aHeaWat[1]) annotation (
     Line(points={{-32,50.8},{-32,50},{-56,50},{-56,-14},{-32,-14}}, color={0,127,
          255}));
  connect(THeaWatSupSet.y, ets.THeaWatSupSet) annotation (Line(points={{-128,72},
          {-76,72},{-76,-44},{-36,-44}}, color={0,0,127}));
  connect(TChiWatSupSet.y, ets.TChiWatSupSet) annotation (Line(points={{-126,28},
          {-82,28},{-82,-50},{-36,-50}}, color={0,0,127}));
  connect(ets.port_bSerAmb,disWat. ports[1]) annotation (Line(points={{28,-60},{
          94,-60},{94,-180},{-132,-180},{-132,-136}},    color={0,127,255}));
  connect(TDisWatSup.y[1],disWat.T_in)
    annotation (Line(points={{-201,-134},{-154,-134}},                        color={0,0,127}));
  connect(disWat.ports[2],senTDisWatSup.port_a)
    annotation (Line(points={{-132,-140},{-132,-74},{-110,-74}},
                                                               color={0,127,255}));
  connect(senTDisWatSup.port_b, ets.port_aSerAmb) annotation (Line(points={{-90,
          -74},{-64,-74},{-64,-60},{-32,-60}}, color={0,127,255}));
  connect(bui.QReqHea_flow,loaHeaNor. u) annotation (Line(points={{-25,31.2},{-25,
          2},{-224,2},{-224,-36},{-208,-36}}, color={0,0,127}));
  connect(bui.QReqCoo_flow,loaCooNor. u) annotation (Line(points={{-27.8,31.2},{
          -27.8,20},{-28,20},{-28,8},{-218,8},{-218,-76},{-208,-76}},
                                              color={0,0,127}));
  connect(enaHeaCoo[1].y, ets.uHea) annotation (Line(points={{-124,-54},{-112,-54},
          {-112,-32},{-36,-32}},color={255,0,255}));
  connect(enaHeaCoo[2].y, ets.uCoo) annotation (Line(points={{-124,-54},{-108,-54},
          {-108,-38},{-36,-38}},color={255,0,255}));
  connect(loaHeaNor.y,enaHeaCoo [1].u) annotation (Line(points={{-184,-36},{-166,
          -36},{-166,-54},{-148,-54}},   color={0,0,127}));
  connect(loaCooNor.y,enaHeaCoo [2].u) annotation (Line(points={{-184,-76},{-166,
          -76},{-166,-54},{-148,-54}},   color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    uses(Buildings(version="8.0.0"), Modelica(version="3.2.3")));
end Buildingwithchillerborefield;
