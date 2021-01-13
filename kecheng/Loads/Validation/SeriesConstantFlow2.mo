within kecheng.Loads.Validation;
model SeriesConstantFlow2
  extends Modelica.Icons.Example;
  BuildingTimeSeriesWithchillerborefield bui
    annotation (Placement(transformation(extent={{-34,8},{30,56}})));
  package Medium = Buildings.Media.Water "Medium model";
  parameter Integer nBui = datDes.nBui;
  parameter Boolean allowFlowReversalSer = true
    "Set to true to allow flow reversal in the service lines"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalBui = false
    "Set to true to allow flow reversal for in-building systems"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  inner parameter Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Data.DesignDataSeries
                                        datDes(nBui=1, mCon_flow_nominal=fill(
        bui.ets.hex.m2_flow_nominal, nBui))
    "Design data"
    annotation (Placement(transformation(extent={{-86,72},{-66,92}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(k=bui.bui.T_aHeaWat_nominal,
      y(final unit="K", displayUnit="degC"))
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-88,34},{-68,54}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(k=bui.bui.T_aChiWat_nominal,
      y(final unit="K", displayUnit="degC"))
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-88,-6},{-68,14}})));
  Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Networks.UnidirectionalSeries
                                dis(
    redeclare final package Medium = Medium,
    final nCon=nBui,
    final mDis_flow_nominal=datDes.mDis_flow_nominal,
    final mCon_flow_nominal=datDes.mCon_flow_nominal,
    final dp_length_nominal=datDes.dp_length_nominal,
    final lDis=datDes.lDis,
    final lCon=datDes.lCon,
    final lEnd=datDes.lEnd,
    final allowFlowReversal=allowFlowReversalSer)
    "Distribution network"
    annotation (Placement(transformation(extent={{-20,-52},{20,-32}})));
  Modelica.Blocks.Sources.Constant masFloMaiPum(k=datDes.mDis_flow_nominal)
    "Distribution pump mass flow rate"
    annotation (Placement(transformation(extent={{-92,-134},{-72,-114}})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare final package Medium =
        Medium, final nPorts=1)
    "Boundary pressure condition representing the expansion vessel"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={74,-114})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                   TDisWatRet(redeclare final package Medium =
        Medium, final m_flow_nominal=datDes.mDis_flow_nominal)
    "District water return temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={42,-94})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow
                                                     pumDis(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datDes.mDis_flow_nominal,
    final allowFlowReversal=allowFlowReversalSer)
    "Distribution pump"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=90,
      origin={30,-144})));
equation
  connect(THeaWatSupSet.y, bui.THeaWatSupSet) annotation (Line(points={{-66,44},
          {-40,44},{-40,45.9636},{-34,45.9636}},
                                           color={0,0,127}));
  connect(TChiWatSupSet.y, bui.TChiWatSupSet) annotation (Line(points={{-66,4},
          {-40,4},{-40,37.2364},{-34,37.2364}},
                                         color={0,0,127}));
  connect(dis.ports_bCon[1], bui.port_aSerAmb)
    annotation (Line(points={{-12,-32},{-12,-16},{-28,-16},{-28,25.4545},{
          -28.6667,25.4545}},                     color={0,127,255}));
  connect(bui.port_bSerAmb, dis.ports_aCon[1])
    annotation (Line(points={{24.6667,25.4545},{24,25.4545},{24,-4},{12,-4},{12,
          -32}},                                       color={0,127,255}));
  connect(bou.ports[1], pumDis.port_a)
    annotation (Line(points={{64,-114},{30,-114},{30,-134}},
                                                           color={0,127,255}));
  connect(TDisWatRet.port_b, pumDis.port_a)
    annotation (Line(points={{42,-104},{42,-134},{30,-134}},
                                                 color={0,127,255}));
  connect(TDisWatRet.port_a, dis.port_bDisSup) annotation (Line(points={{42,-84},
          {32,-84},{32,-42},{20,-42}}, color={0,127,255}));
  connect(masFloMaiPum.y, pumDis.m_flow_in) annotation (Line(points={{-71,-124},
          {-26,-124},{-26,-144},{18,-144}}, color={0,0,127}));
  connect(dis.port_aDisSup, pumDis.port_b) annotation (Line(points={{-20,-42},{-40,
          -42},{-40,-176},{30,-176},{30,-154}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})));
end SeriesConstantFlow2;
